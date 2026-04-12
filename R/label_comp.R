#' Compares given label's popularity on Spotify with its popularity on YouTube
#'
#' @param label Name of record label.
#'
#' @returns This function returns a list with a sublist for each of the first 10
#'  (or less) artists returned by Spotify as being associated with the given label.
#'   Each sublist contains the following:
#' *A list providing the given artist's overall popularity score on Spotify,
#' total follower count on Spotify, and subscriber count on YouTube.
#' *A data frame where each row represents one of
#' the given artist's top songs on Spotify. There are columns for song name,
#' Spotify popularity score, YouTube view count, match confidence score (i.e.
#' confidence in the match between the Spotify song and YouTube video), Spotify
#'  popularity rank within the top songs, and YouTube view count rank within
#'  the top songs.
#'
#' @export
#'
#' @examples

label_comp <- function(label) {

  output <- vector(mode = "list", length = nrow(artists))

  output_names <- rep(NA, nrow(artists))

  artists <- spotifyr::get_label_artists(label, limit = 10)

  if (nrow(artists) == 0) {

    stop("No artists were returned. Did you enter the label name correctly?")
  }

  for (i in 1:nrow(artists)) {

    output[i] <- artist_comp(artists$external_urls.spotify)

    output_names[i] <- artists$name[i]
  }

  names(output) <- output_names

  return(output)
}
