globalVariables(c("one_artist", "yt_channel"))

#' Compares given artist's popularity on Spotify with their popularity on YouTube
#'
#' @description This function takes a Spotify artist profile URL as its argument and returns
#' a list with data comparing the artist's popularity between Spotify and YouTube.
#'
#' @details Before running this function, make sure you've set your API
#' credentials using [auth_creds()].
#'
#' @param url Link to Spotify artist profile, including `"https://"` at beginning.
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
#' # remember you must set up your API credentials with [auth_creds()] before you can run examples
#' # currently produces error when over YouTube API quota limit, so designated as don't run for now
#' # using Noah Kahan
#' \dontrun{
#' artist_comp("https://open.spotify.com/artist/2RQXRUsr4IW1f3mKyKsy4B?si=69yU_685T96XI2mWtOGfLg")}

artist_comp <- function(url) {

  spotify_artist <- spotifyr::get_artist(gsub("\\?.*", "", substr(url, 33, nchar(url))))

  message(paste("Retrieving Spotify statistics associated with", spotify_artist$name, "and matching their top songs to YouTube videos."))

  top_tracks <- spotifyr::get_artist_top_tracks(spotify_artist$id)

  matches <- get_yt_matches(top_tracks)

  confident_match <- get_confident_match_channel(matches)

  matches <- matches |>
    dplyr::select(!c(yt_channel, one_artist)) |>
    dplyr::mutate(spotify_popularity_rank = rank(dplyr::desc(matches$spotify_popularity_score), ties.method = "min"),
                  youtube_views_rank = rank(dplyr::desc(matches$youtube_view_count), ties.method = "min"))

  # matching most confidently matched YouTube channel ID with a YouTube channel and retrieving number of subscribers
  channel_stats <- tuber::get_channel_stats(confident_match, auth = "key")

  message(paste0("Retrieving YouTube subscriber count associated with ", channel_stats$title, "."))

  yt_subscribers <- ifelse(channel_stats$subscriber_count_hidden == FALSE, channel_stats$subscriber_count, NA)

  return(list(list("Artist's Spotify popularity score (0-100)" = spotify_artist$popularity, "Artist's Spotify follower count" = spotify_artist$followers$total, "Artist's YouTube channel subscriber count" = yt_subscribers),
              "Artist's top Spotify songs" = matches))
  }
