song_match <- function(url) {

  spotify_track <- spotifyr::get_track(substr(url, 32, nchar(url)))

  # every Spotify song seems to have an ISRC. when we search it on YouTube, we get the song's music video
  tuber_match <- tuber::yt_search(term = paste(spotify_track$external_ids$isrc), max_results = 1, auth = "key")[1,]

  if (ncol(tuber_match) == 0) {

    # if ISRC doesn't work, we will try matching by song title and artist name (album name seems to hinder correct matching)
    tuber_match <- tuber::yt_search(term = paste(spotify_track$name, paste(spotify_track$artists$name, collapse = " ")), max_results = 1, auth = "key")[1,]
  }

  if (ncol(tuber_match) == 0) {

    output <- list(matched = FALSE,
                   final_list = list("Spotify popularity score (0-100)" = spotify_track$popularity, "Video view count on YouTube" = NA, "Match confidence score (0-10)" = 0),
                   yt_channel = NA,
                   spotify_track = spotify_track,
                   one_artist = ifelse(length(spotify_track$artists$name) == 1, TRUE, FALSE))
  } else {

    #  if exact date, month and year, and year, respectively
    day_match <- ifelse(spotify_track$album$release_date == tuber_match$publishedAt, TRUE, FALSE)

    month_match <- ifelse(substr(spotify_track$album$release_date, 1, 7) == substr(tuber_match$publishedAt, 1, 7), TRUE, FALSE)

    year_match <- ifelse(substr(spotify_track$album$release_date, 1, 4) == substr(tuber_match$publishedAt, 1, 4), TRUE, FALSE)

    tuber_stats <- tuber::get_stats(tuber_match$video_id, include_content_details = TRUE, auth = "key")

    tuber_duration_sec <- ifelse(grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("H.*", "", tuber_stats$contentDetails_duration)))*60*60), 0) +
      ifelse((grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*H", "", gsub("M.*", "", tuber_stats$contentDetails_duration)))*60),
             ifelse(grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("M.*", "", tuber_stats$contentDetails_duration))))*60, 0)) +
      ifelse((grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("M", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*M", "", gsub("S", "", tuber_stats$contentDetails_duration)))),
             ifelse((grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE) & grepl("H", tuber_stats$contentDetails_duration, fixed = TRUE)), (as.numeric(gsub(".*H", "", gsub("S", "", tuber_stats$contentDetails_duration)))),
                    ifelse(grepl("S", tuber_stats$contentDetails_duration, fixed = TRUE), (as.numeric(gsub("PT", "", gsub("S.*", "", tuber_stats$contentDetails_duration)))), 0)))

    spotify_duration_sec <- round(spotify_track$duration_ms/1000)

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

    output <- list(matched = TRUE,
                   final_list = list("Spotify popularity score (0-100)" = spotify_track$popularity, "Video view count on YouTube" = as.numeric(tuber_stats$statistics_viewCount), "Match confidence score (0-10)" = confidence_score),
                   yt_channel = tuber_match$channelId,
                   spotify_track = spotify_track,
                   tuber_match = tuber_match,
                   one_artist = ifelse(length(spotify_track$artists$name) == 1, TRUE, FALSE))
  }

  return(output)
}

get_yt_matches <- function(top_tracks) {

  matches <- data.frame(song_name = character(), spotify_popularity_score = numeric(), youtube_view_count = numeric(), match_confidence_score = numeric(), yt_channel = character(), one_artist = logical())

  for (i in 1:nrow(top_tracks)) {

    matches1 <- song_match(top_tracks$external_urls.spotify[i])

    matches1 <- c(top_tracks$name[i], as.numeric(matches1$final_list$`Spotify popularity score (0-100)`), as.numeric(matches1$final_list$`Video view count on YouTube`), as.numeric(matches1$final_list$`Match confidence score (0-10)`), matches1$yt_channel, matches1$one_artist)

    matches[nrow(matches)+1,] <- matches1
  }

  return(matches)
}

get_confident_match_channel <- function(matches) {

  # retrieving YouTube channel ID from the most confidently matched song (taking the first listed one if there are multiple with the same confidence score) of those with only one artist on Spotify (to ensure songs are not used from another artist's channel)
  confident_match <- matches |>
    dplyr::filter(one_artist == TRUE) |>
    dplyr::filter(match_confidence_score == max(match_confidence_score)) |>
    head(1)

  confident_match <- confident_match$yt_channel

  return(confident_match)
}
