# this function will take a YouTube song URL, attempt to find the corresponding Spotify song, and return information comparing the YouTube and Spotify songs (similar to match_spotify_song, but in reverse)

#' Matches YouTube music video to corresponding Spotify song
#'
#' @description Takes a YouTube music video URL and returns a list with data comparing the song's
#' popularity between YouTube and Spotify
#'
#' @details Before running this function, make sure you've set your API
#' credentials using [auth_creds()].
#'
#' @param url Link to YouTube music video, in the format beginning with
#' `"https://www.youtube.com/watch?v="`.
#'
#' @returns This function returns a list containing the Spotify popularity score,
#'  corresponding YouTube video view count, and match confidence score (i.e. the
#'   confidence that the correct YouTube video was matched to the given Spotify
#'    song).
#' @export
#'
#' @examples
#' # remember you must set up your API credentials with [auth_creds()] before you can run examples
#' # currently produces error when over YouTube API quota limit, so designated as don't run for now
#' # using Ordinary by Alex Warren
#' \dontrun{
#' match_yt_song("https://www.youtube.com/watch?v=u2ah9tWTkmk")}

# function is not yet good at matching to correct song. will try to improve for final submission

match_yt_song <- function(url) {

  output <- yt_to_spotify(url)

  if (output$matched == FALSE) {

    message(paste("No potential Spotify song match was found for", output$tuber_match$snippet_title, "from channel", output$tuber_match$snippet_channelTitle, "on YouTube"))

  }

  if (output$matched == TRUE) {

    message(paste("Returning statistics for Spotify song corresponding to", output$tuber_match$snippet_title, "from channel", output$tuber_match$snippet_channelTitle, "on YouTube"))

    message(paste0("Spotify song was identified as ", output$spotify_match$name, " by ", ifelse(length(output$spotify_match$artists[[1]]$name) == 1, output$spotify_match$artists[[1]]$name, paste(output$spotify_match$artists[[1]]$name, collapse = "and")), "."))
  }

  return(output$final_list)
}
