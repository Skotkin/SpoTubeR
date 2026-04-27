# IDEAS FOR TESTS

# test commented out because it failed in the R CMD check due to exceeding the YouTube API usage quota at that point. it did work when I tried it before
# checking that the appropriate 2 messages are printed when a YouTube video match is found
#testthat::test_that("match messages work", {
#  testthat::expect_message(object = match_spotify_song('https://open.spotify.com/track/1fzAuUVbzlhZ1lJAx9PtY6?si=cf2a7c01466643b0'), regexp = "Returning statistics for YouTube video corresponding to.*")
#  testthat::expect_message(object = match_spotify_song('https://open.spotify.com/track/1fzAuUVbzlhZ1lJAx9PtY6?si=cf2a7c01466643b0'), regexp = "YouTube video was identified as.*")
#})

# test commented out because it failed in the R CMD check due to exceeding the YouTube API usage quota at that point. it did work when I tried it before
# checking that the output is a list
#testthat::test_that("returns list", {
#  testthat::expect_type(match_spotify_song("https://open.spotify.com/track/1fzAuUVbzlhZ1lJAx9PtY6?si=cf2a7c01466643b0"), 'list')
#})

# testing what happens if user inputs:

# -a non-Spotify URL
testthat::test_that("Spotify URL specific", {
  testthat::expect_error(match_spotify_song("https://www.google.com"))
})

# -a URL to a different Spotify page (e.g. to an artist instead of a song)
testthat::test_that("song URL specific", {
  testthat::expect_error(match_spotify_song("https://open.spotify.com/artist/6BRxQ8cD3eqnrVj6WKDok8?si=__YvjzNLTP2ox1eHOPt3VA"))
})

# -a non-character type
testthat::test_that("character specific", {
  testthat::expect_error(match_spotify_song(8))
})
