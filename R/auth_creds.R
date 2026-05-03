#' Saves YouTube and Spotify API credentials
#'
#' @description This function must be run before the other SpoTubeR functions can be used.
#'
#' @details You will need to first sign up for a Spotify API account
#' [here](https://developer.spotify.com/documentation/web-api) (requires a
#' Spotify Premium subscription) and obtain an API key for the YouTube API
#' [here](https://developers.google.com/youtube/v3/). Currently, the
#'   user may need to restart R after running [auth_creds()] in order for the
#'   credentials to become retrievable by other functions. However, the user
#'   only needs to run [auth_creds()] once ever; after this, the saved credentials
#'    will be retrievable even in new R sessions.
#'
#' @return This function does not return anything. It does provide a message
#' informing the user that their credentials have been saved and tests if those
#' credentials are valid.
#'
#' @param spotify_id Your Spotify API client ID (as character type).
#' @param spotify_secret Your Spotify API client secret (as character type).
#' @param yt_key Your YouTube API key (as character type).
#'
#' @export
#'
#' @examples \dontrun{auth_creds(spotify_id = "YOUR ID HERE",
#' spotify_secret = "YOUR SECRET HERE",
#' yt_key = "YOUR SECRET HERE")}

auth_creds <- function(spotify_id, spotify_secret, yt_key) {

  # checks if R environ exists, and creates it if not
  renv <- file.path(Sys.getenv("HOME"), ".Renviron")
  if (!file.exists(renv)) {
    file.create(renv)
  }

  # initializing variables for the old R environ contents, and whether or not the Spotify and YouTube credentials were replaced
  oldenv <- readLines(renv)
  replaced_spotify_id <- FALSE
  replaced_spotify_secret <- FALSE
  replaced_yt_key <- FALSE

  # checks if SPOTIFY_CLIENT_ID already exists in R environ, and replaces it if so ("SPOTIFY_CLIENT_ID" is the particular variable name spotifyr looks for when authorizing)
  for (i in 1:length(oldenv)) {
    if (substr(oldenv[i], 1, 17) == "SPOTIFY_CLIENT_ID") {
      oldenv[i] <- paste0("SPOTIFY_CLIENT_ID=\"", spotify_id, "\"")
      replaced_spotify_id <- TRUE
    }
  }

  # checks if SPOTIFY_CLIENT_SECRET already exists in R environ, and replaces it if so ("SPOTIFY_CLIENT_SECRET" is the particular variable name spotifyr looks for when authorizing)
  for (i in 1:length(oldenv)) {
    if (substr(oldenv[i], 1, 21) == "SPOTIFY_CLIENT_SECRET") {
      oldenv[i] <- paste0("SPOTIFY_CLIENT_SECRET=\"", spotify_secret, "\"")
      replaced_spotify_secret <- TRUE
    }
  }

  # checks if YOUTUBE_KEY already exists in R environ, and replaces it if so ("YOUTUBE_KEY" is the particular variable name tuber looks for when querying)
  for (i in 1:length(oldenv)) {
    if (substr(oldenv[i], 1, 11) == "YOUTUBE_KEY") {
      oldenv[i] <- paste0("YOUTUBE_KEY=\"", yt_key, "\"")
      replaced_yt_key <- TRUE
    }
  }

  # if any values were replaced, writing the new file to the R environ
  if (replaced_spotify_id == TRUE | replaced_spotify_secret == TRUE | replaced_yt_key == TRUE) {

    write(oldenv, renv, sep = "\n", append = FALSE)
  }

  # for any values that did not already exist in R environ, writing them to end of R environ
  if (replaced_spotify_id == FALSE) {
    write(paste0("SPOTIFY_CLIENT_ID=\"", spotify_id, "\""), renv, sep = "\n", append = TRUE)
  }

  if (replaced_spotify_secret == FALSE) {
    write(paste0("SPOTIFY_CLIENT_SECRET=\"", spotify_secret, "\""), renv, sep = "\n", append = TRUE)
  }

  if (replaced_yt_key == FALSE) {
    write(paste0("YOUTUBE_KEY=\"", yt_key, "\""), renv, sep = "\n", append = TRUE)
  }

  message("Your credentials have been saved!")

  # testing credentials to ensure they will work

  spotify_test <- tryCatch({
    spotifyr::get_spotify_access_token()
  }, error = function(e) {stop(e$message)}
  )

  tuber_test <- tryCatch({
    tuber::get_channel_stats("UCXY5pi3MbsaP1WEgClmglsA", auth = "token")
  }, error = function(e) {stop("Provided YouTube API key not working. Unless you have exceeded your API limit, this key is incorrect.")}
  )

message("Your provided credentials have been tested and are correct!")
}
