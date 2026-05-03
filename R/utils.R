globalVariables(c("yt_channel", "one_artist", "match_confidence_score"))


# this function matches a Spotify song to a YouTube video
spotify_to_yt <- function(url) {

  # attempting to match given URL with Spotify track
  spotify_track <- tryCatch({
    spotifyr::get_track(substr(url, 32, nchar(url)))
  }, error = function(e) {
      stop("URL cannot be matched with Spotify track at this time. Did you enter the URL correctly?")
  })

  # every Spotify song seems to have an ISRC. when we search it on YouTube, we get the song's music video
  tuber_match <- tryCatch({
    tuber::yt_search(term = paste(spotify_track$external_ids$isrc), max_results = 1, auth = "key")[1,]
  }, error = function(e) {
    if (substr(e$message, nchar(e$message) - 18, nchar(e$message)) == "HTTP 403 Forbidden.") {
      stop("YouTube API quota appears to be overloaded at this point. You may need to wait a minute, or you may have exceeded your quota for the day.")}
  })

  if (ncol(tuber_match) == 0) {

    # if ISRC doesn't work, we will try matching by song title and artist name (album name seems to hinder correct matching)
    tuber_match <- tryCatch({
      tuber::yt_search(term = paste(spotify_track$name, paste(spotify_track$artists$name, collapse = " ")), max_results = 1, auth = "key")[1,]
    }, error = function(e) {
      if (substr(e$message, nchar(e$message) - 18, nchar(e$message)) == "HTTP 403 Forbidden.") {
        stop("YouTube API quota appears to be overloaded at this point. You may need to wait a minute, or you may have exceeded your quota for the day.")}
    })
  }

  if (ncol(tuber_match) == 0) {

    # returning suitable data if no YouTube match is found
    output <- list(matched = FALSE,
                   final_list = list("Spotify popularity score (0-100)" = spotify_track$popularity, "Video view count on YouTube" = NA, "Match confidence score (0-10)" = 0),
                   yt_channel = NA,
                   spotify_track = spotify_track,
                   one_artist = ifelse(length(spotify_track$artists$name) == 1, TRUE, FALSE))
  } else {

    # producing TRUE/FALSE values to indicate whether Spotify track and YouTube song match in terms of exact date, month and year, and year, respectively
    day_match <- ifelse(spotify_track$album$release_date == tuber_match$publishedAt, TRUE, FALSE)

    month_match <- ifelse(substr(spotify_track$album$release_date, 1, 7) == substr(tuber_match$publishedAt, 1, 7), TRUE, FALSE)

    year_match <- ifelse(substr(spotify_track$album$release_date, 1, 4) == substr(tuber_match$publishedAt, 1, 4), TRUE, FALSE)

    # retrieving statistics for matched YouTube video
    tuber_stats <- tuber::get_stats(tuber_match$video_id, include_content_details = TRUE, auth = "key")

    # computing durations of YouTube video and Spotify song in seconds
    tuber_duration_sec <- ifelse(grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("H.*", "", tuber_stats$contentDetails_duration)))*60*60), 0) +
      ifelse((grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*H", "", gsub("M.*", "", tuber_stats$contentDetails_duration)))*60),
             ifelse(grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("M.*", "", tuber_stats$contentDetails_duration))))*60, 0)) +
      ifelse((grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*M", "", gsub("S", "", tuber_stats$contentDetails_duration)))),
             ifelse((grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*H", "", gsub("S", "", tuber_stats$contentDetails_duration)))),
                    ifelse(grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("S.*", "", tuber_stats$contentDetails_duration)))), 0)))

    spotify_duration_sec <- round(spotify_track$duration_ms/1000)

    #  producing TRUE/FALSE values to indicate whether Spotify track and YouTube song match in terms of exact length in seconds, within 1 second, or within 30 seconds, respectively
    same_sec <- (tuber_duration_sec == spotify_duration_sec)

    within_1_sec <- ((tuber_duration_sec - spotify_duration_sec) %in% (-1:1))

    within_30_sec <- ((tuber_duration_sec - spotify_duration_sec) %in% (-30:30))

    # Boolean for whether Spotify track name is in YT video title
    name_in_title <- (grepl(spotify_track$name, tuber_match$title, fixed = TRUE))

    # if any artists listed for the Spotify song are in the channel title, sets Boolean to TRUE, otherwise is FALSE
    artist_in_channel <- FALSE

    for (i in spotify_track$artists$name) {

      if (grepl(i, tuber_match$channelTitle, fixed = TRUE)) {

        artist_in_channel <- TRUE
      }
    }

    # Boolean for whether Spotify album title is in YT video description
    album_in_desc <- (grepl(spotify_track$album$name, tuber_match$description, fixed = TRUE))

    # starting with baseline score of 1 because some match was found.
    # adding 3 points for matching exact day of release, 2 points for month, and 1 point for year
    # adding 3 points for same number of seconds, 2 points for within 1 second, and 1 point for within 30 seconds
    # adding a point for each of the following: track name in video title, artist name in channel title, and album title in video description
    confidence_score <- 1 + day_match + month_match + year_match + same_sec + within_1_sec + within_30_sec + name_in_title + artist_in_channel + album_in_desc

    # creating output for if Spotify song is matched to a YouTube video
    output <- list(matched = TRUE,
                   final_list = list("Spotify popularity score (0-100)" = spotify_track$popularity, "Video view count on YouTube" = as.numeric(tuber_stats$statistics_viewCount), "Match confidence score (0-10)" = confidence_score),
                   yt_channel = tuber_match$channelId,
                   spotify_track = spotify_track,
                   tuber_match = tuber_match,
                   one_artist = ifelse(length(spotify_track$artists$name) == 1, TRUE, FALSE))
  }

  return(output)
}


# this function matches a YouTube video to a Spotify song
yt_to_spotify <- function(url) {

  # attempting to retrieve details associated with given YouTube video URL
  tuber_match <- tryCatch({
    tuber::get_video_details(video_ids = substr(url, 33, 43), auth = "key")
  }, error = function(e) {
    if (substr(e$message, nchar(e$message) - 18, nchar(e$message)) == "HTTP 403 Forbidden.") {
      stop("YouTube API quota appears to be overloaded at this point. You may need to wait a minute, or you may have exceeded your quota for the day.")}
    else {stop("Did you provide a correct video URL as specified in the function guidelines?")}
  },
  warning = function(w) {
    if (substr(w$message, 1, 29) == "No video details found for ID") {
      stop("Did you provide a correct channel URL as specified in the function guidelines?")
    }})

  # matching YouTube video with Spotify song through searching video title and channel name on Spotify and taking the first result
  # sets spotify_match to NA if error is produced (as an error is produced when no match is found)
  spotify_match <- tryCatch({
    spotifyr::search_spotify(paste(tuber_match$snippet_title, tuber_match$snippet_channelTitle), type = "track")[1,]
  }, error = function(e) {NA})

  # retrieving statistics for matched YouTube video
  tuber_stats <- tryCatch({
    tuber::get_stats(video_ids = tuber_match$id, include_content_details = TRUE, auth = "key")
  }, error = function(e) {
    if (substr(e$message, nchar(e$message) - 18, nchar(e$message)) == "HTTP 403 Forbidden.") {
      stop("YouTube API quota appears to be overloaded at this point. You may need to wait a minute, or you may have exceeded your quota for the day.")}
  })

  if (is.na(spotify_match)) {

    # if no Spotify song is found to match YouTube video, returns relevant data
    output <- list(matched = FALSE,
                   final_list = list("Spotify popularity score (0-100)" = NA, "Video view count on YouTube" = as.numeric(tuber_stats$statistics_viewCount), "Match confidence score (0-10)" = 0),
                   tuber_match = tuber_match,
                   one_artist = NA)
  } else {

    # setting TRUE/FALSE values depending on whether or not exact date, month and year, or year of release, respectively, match between YouTube video and Spotify track
    day_match <- ifelse(spotify_match$album.release_date == tuber_match$snippet_publishedAt, TRUE, FALSE)

    month_match <- ifelse(substr(spotify_match$album.release_date, 1, 7) == substr(tuber_match$snippet_publishedAt, 1, 7), TRUE, FALSE)

    year_match <- ifelse(substr(spotify_match$album.release_date, 1, 4) == substr(tuber_match$snippet_publishedAt, 1, 4), TRUE, FALSE)

    # computing duration in seconds for YouTube video and matched Spotify track
    tuber_duration_sec <- ifelse(grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("H.*", "", tuber_stats$contentDetails_duration)))*60*60), 0) +
      ifelse((grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*H", "", gsub("M.*", "", tuber_stats$contentDetails_duration)))*60),
             ifelse(grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("M.*", "", tuber_stats$contentDetails_duration))))*60, 0)) +
      ifelse((grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*M", "", gsub("S", "", tuber_stats$contentDetails_duration)))),
             ifelse((grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*H", "", gsub("S", "", tuber_stats$contentDetails_duration)))),
                    ifelse(grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("S.*", "", tuber_stats$contentDetails_duration)))), 0)))

    spotify_duration_sec <- round(spotify_match$duration_ms/1000)

    # setting TRUE/FALSE values for whether YouTube video and Spotify song are the same length in seconds, within one second, or within 30 seconds of each other, respectively
    same_sec <- (tuber_duration_sec == spotify_duration_sec)

    within_1_sec <- ((tuber_duration_sec - spotify_duration_sec) %in% (-1:1))

    within_30_sec <- ((tuber_duration_sec - spotify_duration_sec) %in% (-30:30))

    # Boolean for whether Spotify track name is in YT video title
    name_in_title <- (grepl(spotify_match$name, tuber_match$snippet_title, fixed = TRUE))

    # if any artists listed for the Spotify song are in the channel title, sets Boolean to TRUE, otherwise is FALSE
    artist_in_channel <- FALSE

    for (i in spotify_match$artists[[1]]$name) {

      if (grepl(i, tuber_match$snippet_channelTitle, fixed = TRUE)) {

        artist_in_channel <- TRUE
      }
    }

    # Boolean for whether Spotify album title is in YT video description
    album_in_desc <- (grepl(spotify_match$album.name, tuber_match$snippet_description, fixed = TRUE))

    # starting with baseline score of 1 because some match was found.
    # adding 3 points for matching exact day of release, 2 points for month, and 1 point for year
    # adding 3 points for same number of seconds, 2 points for within 1 second, and 1 point for within 30 seconds
    # adding a point for each of the following: track name in video title, artist name in channel title, and album title in video description
    confidence_score <- 1 + day_match + month_match + year_match + same_sec + within_1_sec + within_30_sec + name_in_title + artist_in_channel + album_in_desc

    # assigning output with suitable data for when YouTube video is successfully matched with Spotify song
    output <- list(matched = TRUE,
                   final_list = list("Spotify popularity score (0-100)" = spotify_match$popularity, "Video view count on YouTube" = as.numeric(tuber_stats$statistics_viewCount), "Match confidence score (0-10)" = confidence_score),
                   spotify_match = spotify_match,
                   tuber_match = tuber_match,
                   one_artist = ifelse(length(spotify_match$artists[[1]]$name) == 1, TRUE, FALSE))
  }

  return(output)

}

# matches Spotify tracks to YouTube videos
get_yt_matches <- function(top_tracks) {

  # initializing data frame
  matches <- data.frame(song_name = character(), spotify_popularity_score = numeric(), youtube_view_count = numeric(), match_confidence_score = numeric(), yt_channel = character(), one_artist = logical())

  for (i in 1:nrow(top_tracks)) {

    # matching given Spotify song's URL to YouTube video
    matches1 <- spotify_to_yt(top_tracks$external_urls.spotify[i])

    # creating vector with name and attributes of given track
    matches1 <- c(top_tracks$name[i], as.numeric(matches1$final_list$`Spotify popularity score (0-100)`), as.numeric(matches1$final_list$`Video view count on YouTube`), as.numeric(matches1$final_list$`Match confidence score (0-10)`), matches1$yt_channel, matches1$one_artist)

    # assigning matches1 to new row of matches data frame
    matches[nrow(matches)+1,] <- matches1
  }

  return(matches)
}

# using data from Spotify songs from the same artist, matched to YouTube videos, to determine the YouTube channel most likely corresponding to the artist
get_confident_match_channel <- function(matches) {

  # unless all songs have multiple artists, filtering out songs with multiple artists to reduce the risk of being matched to another artist's YouTube channel
  if (TRUE %in% unique(matches$one_artist)) {
    confident_match <- matches |>
      dplyr::filter(one_artist == TRUE)
    } else {
    confident_match <- matches
    }

  # filtering to most confidently matched YouTube video(s), and reducing to 1 video if multiple videos have the same match confidence score
  confident_match <- confident_match |>
    dplyr::filter(match_confidence_score == max(match_confidence_score)) |>
    utils::head(1)

  # retrieving YouTube channel ID most likely corresponding to artist
  confident_match <- confident_match$yt_channel

  return(confident_match)
}
