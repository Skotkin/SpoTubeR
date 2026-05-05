globalVariables(c("one_artist", "yt_channel"))

#' Compares given artist's popularity on YouTube with their popularity on Spotify
#'
#' @description This function takes an artist's YouTube channel URL as its argument and returns
#' a list with data comparing the artist's popularity between YouTube and Spotify
#'
#' @details Before running this function, make sure you've set your API
#' credentials using [auth_creds()].
#'
#' @param url Link to artist's YouTube channel, in the format beginning with
#' `"https://www.youtube.com/channel/"`.
#'
#' @returns This function returns a list containing:
#' * A list providing the given artist's overall popularity score on Spotify,
#' total follower count on Spotify, and subscriber count on YouTube. (If YouTube
#'  subscriber count is hidden, the value will appear as `NA`).
#' * A data frame where each row represents one of
#' the given artist's top songs on Spotify. There are columns for song name,
#' Spotify popularity score, YouTube view count, match confidence score (i.e.
#' confidence in the match between the Spotify song and YouTube video), Spotify
#'  popularity rank within the top songs, and YouTube view count rank within
#'  the top songs.
#'
#' @export
#'
#' @examples
#' # remember you must set up your API credentials with the auth_creds function
#' #  before you can run examples
#' # using Noah Kahan
#' yt_artist_comp("https://www.youtube.com/channel/UCXY5pi3MbsaP1WEgClmglsA")
yt_artist_comp <- function(url) {
  # retrieving statistics for YouTube channel corresponding to given URL
  channel_stats <- tryCatch(
    {
      tuber::get_channel_stats(substr(url, 33, 56), auth = "key")
    },
    error = function(e) {
      if (substr(e$message, nchar(e$message) - 18, nchar(e$message)) == "HTTP 403 Forbidden.") {
        stop("YouTube API quota appears to be overloaded at this point. You may need to wait a minute, or you may have exceeded your quota for the day.")
      } else {
        stop("Did you provide a correct channel URL as specified in the function guidelines?")
      }
    },
    warning = function(w) {
      if (w$message == "No channel stats available. Likely cause: Incorrect channel_id") {
        stop("Did you provide a correct channel URL as specified in the function guidelines?")
      }
    }
  )

  message(paste("Retrieving YouTube subscriber count associated with", channel_stats$title, "and matching them to a Spotify artist."))

  # retrieving number of subscribers to YouTube channel, or NA if subscriber count is hidden
  yt_subscribers <- ifelse(channel_stats$subscriber_count_hidden == FALSE, channel_stats$subscriber_count, NA)

  # attempting to match YouTube channel to Spotify artist
  spotify_artist <- tryCatch(
    {
      spotifyr::search_spotify(channel_stats$title, type = "artist")[1, ]
    },
    error = function(e) {
      stop("YouTube channel could not be matched to Spotify artist. Does this channel correspond to an artist likely listed on Spotify?")
    }
  )

  message(paste("Retrieving Spotify statistics associated with", spotify_artist$name, "and matching their top songs to YouTube videos."))

  # retrieving matched Spotify artist's top tracks on Spotify
  top_tracks <- spotifyr::get_artist_top_tracks(spotify_artist$id)

  # matching top Spotify tracks to YouTube videos
  matches <- get_yt_matches(top_tracks)

  # ranking songs by Spotify popularity score and YouTube view count
  matches <- matches |>
    dplyr::select(!c(yt_channel, one_artist)) |>
    dplyr::mutate(
      spotify_popularity_rank = rank(dplyr::desc(matches$spotify_popularity_score), ties.method = "min"),
      youtube_views_rank = rank(dplyr::desc(matches$youtube_view_count), ties.method = "min")
    )

  return(list(list("Artist's Spotify popularity score (0-100)" = spotify_artist$popularity, "Artist's Spotify follower count" = spotify_artist$followers.total, "Artist's YouTube channel subscriber count" = yt_subscribers),
    "Artist's top Spotify songs" = matches
  ))
}
