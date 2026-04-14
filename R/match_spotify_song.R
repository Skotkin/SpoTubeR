#' Matches Spotify song to corresponding YouTube music video
#'
#' @description Takes a Spotify song URL and returns a list with data comparing the song's
#' popularity between Spotify and YouTube.
#'
#' @details Before running this function, make sure you've set your API
#' credentials using [auth_creds()].
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
#' # remember you must set up your API credentials with [auth_creds()] before you can run examples
#' # using Ordinary by Alex Warren
#' match_spotify_song("https://open.spotify.com/track/6qqrTXSdwiJaq8SO0X2lSe?si=ba9ef90830b24d28")

match_spotify_song <- function(url) {

  output <- song_match(url)

  if (output$matched == FALSE) {

    message(paste("No potential YouTube video match was found for", output$spotify_track$name, "by", ifelse(length(output$spotify_track$artists$name) == 1, output$spotify_track$artists$name, paste(output$spotify_track$artists$name, collapse = "and")), "on Spotify."))

  }

  if (output$matched == TRUE) {

    message(paste("Returning statistics for YouTube video corresponding to", output$spotify_track$name, "by", ifelse(length(output$spotify_track$artists$name) == 1, output$spotify_track$artists$name, paste(output$spotify_track$artists$name, collapse = "and")), "on Spotify."))

    message(paste0("YouTube video was identified as ", output$tuber_match$title, " on the channel ", output$tuber_match$channelTitle, "."))
}

return(output$final_list)
}
