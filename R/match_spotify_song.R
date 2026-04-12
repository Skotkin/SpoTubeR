#' Matches Spotify song to corresponding YouTube music video
#'
#' @param url Link to Spotify song, including `"https://"` at beginning.
#'
#' @returns This function returns a list containing the Spotify popularity score,
#'  corresponding YouTube video view count, and match confidence score (i.e. the
#'   confidence that the correct YouTube video was matched to the given Spotify
#'    song).
#' @export
#'
#' @examples

match_spotify_song <- function(url) {

  output <- song_match(url)

  if (output$matched == FALSE) {

    message(paste("No potential YouTube video match was found for", spotify_track$name, "by", ifelse(length(spotify_track$artists$name) == 1, spotify_track$artists$name, paste(spotify_track$artists$name, collapse = "and")), "on Spotify."))

  }

  if (output$matched == TRUE) {

    message(paste("Returning statistics for YouTube video corresponding to", spotify_track$name, "by", ifelse(length(spotify_track$artists$name) == 1, spotify_track$artists$name, paste(spotify_track$artists$name, collapse = "and")), "on Spotify."))

    message(paste0("YouTube video was identified as ", tuber_match$title, " on the channel ", tuber_match$channelTitle, "."))
}

return(output$final_list)
}
