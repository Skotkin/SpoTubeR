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
#' # remember you must set up your API credentials with the auth_creds function before you can run examples
#' # using Noah Kahan
#' spotify_artist_comp("https://open.spotify.com/artist/2RQXRUsr4IW1f3mKyKsy4B?si=69yU_685T96XI2mWtOGfLg")
#' # using Kacey Musgraves
#' spotify_artist_comp("https://open.spotify.com/artist/70kkdajctXSbqSMJbQO424?si=XXlTn6IrSR69auGUdtGzDQ")

spotify_artist_comp <- function(url) {

  # attempting to match given URL to Spotify artist
  spotify_artist <- tryCatch({
    spotifyr::get_artist(gsub("\\?.*", "", substr(url, 33, nchar(url))))
  }, error = function(e) {
      stop("URL cannot be matched with Spotify artist at this time. Did you enter the URL correctly?")
  })

  message(paste("Retrieving Spotify statistics associated with", spotify_artist$name, "and matching their top songs to YouTube videos."))

  # retrieving artist top tracks
  top_tracks <- spotifyr::get_artist_top_tracks(spotify_artist$id)

  # attempting to match artist top tracks to YouTube videos
  matches <- get_yt_matches(top_tracks)

  # retrieving most confidently matched YouTube channel to Spotify artist
  confident_match <- get_confident_match_channel(matches)

  # ranking artist's songs by Spotify popularity score and YouTube view count
  matches <- matches |>
    dplyr::select(!c(yt_channel, one_artist)) |>
    dplyr::mutate(spotify_popularity_rank = rank(dplyr::desc(matches$spotify_popularity_score), ties.method = "min"),
                  youtube_views_rank = rank(dplyr::desc(matches$youtube_view_count), ties.method = "min"))

  # matching most confidently matched YouTube channel ID with a YouTube channel
  channel_stats <- tryCatch({
    tuber::get_channel_stats(confident_match, auth = "key")
  }, error = function(e) {
    if (substr(e$message, nchar(e$message) - 18, nchar(e$message)) == "HTTP 403 Forbidden.") {
      stop("YouTube API quota appears to be overloaded at this point. You may need to wait a minute, or you may have exceeded your quota for the day.")}
  }
)

  message(paste0("Retrieving YouTube subscriber count associated with ", channel_stats$title, "."))

  # retrieving number of subscribers to matched YouTube channel, or NA if subscriber count is hidden
  yt_subscribers <- ifelse(channel_stats$subscriber_count_hidden == FALSE, channel_stats$subscriber_count, NA)

  return(list(list("Artist's Spotify popularity score (0-100)" = spotify_artist$popularity, "Artist's Spotify follower count" = spotify_artist$followers$total, "Artist's YouTube channel subscriber count" = yt_subscribers),
              "Artist's top Spotify songs" = matches))
  }
