#' Compares given artist's popularity on Spotify with their popularity on YouTube
#'
#' @param url Link to Spotify artist profile, including `"https://"` at beginning.
#'
#' @returns This function returns a list containing:
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

artist_comp <- function(url) {

  spotify_artist <- spotifyr::get_artist(gsub("\\?.*", "", substr(url, 33, nchar(url))))

  top_tracks <- spotifyr::get_artist_top_tracks(spotify_artist$id)

  matches <- data.frame(song_name = character(), spotify_popularity_score = numeric(), youtube_view_count = numeric(), match_confidence_score = numeric(), yt_channel = character())

  for (i in 1:nrow(top_tracks)) {

    matches1 <- spotify_track(top_tracks$external_urls.spotify[i])

    matches1 <- c(top_tracks$name[i], as.numeric(matches1$final_list$`Spotify popularity score (0-100)`), as.numeric(matches1$final_list$`Video view count on YouTube`), as.numeric(matches1$final_list$`Match confidence score (0-10)`), matches1$yt_channel)

    matches[nrow(matches)+1,] <- matches1
  }

  # retrieving YouTube channel ID from the most confidently matched song (taking the first listed one if there are multiple with the same confidence score)
  confident_match <- matches |>
    dplyr::filter(match_confidence_score == max(match_confidence_score)) |>
    head(1)

  confident_match <- confident_match$yt_channel

  matches <- matches |>
    dplyr::select(!yt_channel) |>
    dplyr::mutate(spotify_popularity_rank = rank(dplyr::desc(matches$spotify_popularity_score), ties.method = "min"),
                  youtube_views_rank = rank(dplyr::desc(matches$youtube_view_count), ties.method = "min"))

  # matching most confidently matched YouTube channel ID with a YouTube channel and retrieving number of subscribers
  channel_stats <- tuber::get_channel_stats(confident_match)
  # add code to retrieve the specific subscriber count number from this and save it to yt_subscribers variable


  return(list(list("Artist Spotify popularity score (0-100)" = spotify_artist$popularity, "Artist followers on Spotify" = spotify_artist$followers$total, "Artist YouTube channel subscriber count" = yt_subscribers),
              "Artist's top 10 Spotify songs" = matches))
  }
