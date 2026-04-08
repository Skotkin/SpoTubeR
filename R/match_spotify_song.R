#' Matches Spotify song to corresponding YouTube music video
#'
#' @param url Link to Spotify song, including `"https://"` at beginning.
#'
#' @returns
#' @export
#'
#' @examples

match_spotify_song <- function(url) {

spotify_track <- spotifyr::get_track(substr(url, 32, nchar(url)))

tuber_match <- tuber::yt_search(term = paste(spotify_track$name, spotify_track$artists$name, spotify_track$album$name))[1,]

day_match <- ifelse(spotify_track$album$release_date == tuber_match$publishedAt, TRUE, FALSE)

month_match <- ifelse(substr(spotify_track$album$release_date, 1, 7) == substr(tuber_match$publishedAt, 1, 7), TRUE, FALSE)

year_match <- ifelse(substr(spotify_track$album$release_date, 1, 4) == substr(tuber_match$publishedAt, 1, 4), TRUE, FALSE)
}
