#' Compares given label's popularity on Spotify with its popularity on YouTube
#'
#' This function takes a record label name as an argument and returns a list
#' with data comparing the popularity, between Spotify and YouTube, of the
#' label's first 5 associated artists returned by Spotify. Before running this
#'  function, make sure you've set your API credentials using [auth_creds()].
#'
#' @param label Name of record label.
#'
#' @returns This function returns a list with a sublist for each of the first 5
#'  (or less) artists returned by Spotify as being associated with the given label.
#'   Each sublist contains the following:
#' * A list providing the given artist's overall popularity score on Spotify,
#' total follower count on Spotify, and subscriber count on YouTube. (If YouTube
#'  subscriber count is hidden, the value will appear as `NA`).
#' * A data frame where each row represents one of the given artist's top songs
#' on Spotify, with up to 5 songs included. There are columns for song name,
#' Spotify popularity score, YouTube view count, match confidence score (i.e.
#' confidence in the match between the Spotify song and YouTube video), Spotify
#'  popularity rank within the top songs, and YouTube view count rank within
#'  the top songs.
#'
#' @export
#'
#' @examples
#' # remember you must set up your API credentials with [auth_creds()] before you can run examples
#' # using Mercury Records
#' label_comp("Mercury Records")

label_comp <- function(label) {

  # am using capture.output to suppress the print output that would otherwise be produced
  capture.output(artists <- spotifyr::get_label_artists(label, limit = 5))

  if (nrow(artists) == 0) {

    stop("No artists were returned. Did you enter the label name correctly?")
  }

  output <- vector(mode = "list", length = nrow(artists))

  output_names <- rep(NA, nrow(artists))

  matches_all <- vector(mode = "list", length = nrow(artists))

  confident_match_all <- rep(NA, nrow(artists))

  for (i in 1:nrow(artists)) {

    message(paste("Retrieving Spotify statistics associated with", artists$name[i], "and matching their top songs to YouTube videos."))

    top_tracks <- spotifyr::get_artist_top_tracks(artists$id[i]) |>
      head(5)

    matches <- get_yt_matches(top_tracks)

    confident_match <- get_confident_match_channel(matches)

    matches <- matches |>
      dplyr::select(!c(yt_channel, one_artist)) |>
      dplyr::mutate(spotify_popularity_rank = rank(dplyr::desc(matches$spotify_popularity_score), ties.method = "min"),
                    youtube_views_rank = rank(dplyr::desc(matches$youtube_view_count), ties.method = "min"))

    matches_all[i] <- list(matches)

    confident_match_all[i] <- confident_match

    output_names[i] <- artists$name[i]
  }

  # for each artist, matching most confidently matched YouTube channel ID with a YouTube channel and retrieving number of subscribers
  channel_stats <- tuber::get_channel_stats(confident_match_all, auth = "key")

  for (i in 1:nrow(artists)) {

    message(paste0("Retrieving YouTube subscriber count associated with ", channel_stats$title[i], "."))

    yt_subscribers <- ifelse(channel_stats$subscriber_count_hidden[i] == FALSE, channel_stats$subscriber_count[i], NA)

    output[i] <- list(list(list("Artist's Spotify popularity score (0-100)" = artists$popularity[i], "Artist's Spotify follower count" = artists$followers.total[i], "Artist's YouTube channel subscriber count" = yt_subscribers),
                      "Artist's top Spotify songs" = matches_all[i]))
  }

  names(output) <- output_names

  return(output)
}
