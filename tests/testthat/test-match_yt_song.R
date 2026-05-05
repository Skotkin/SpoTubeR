# checking that the appropriate 2 messages are printed when a Spotify video match is found
# and checking if the output is a list
testthat::test_that("match messages and list works", {
  testthat::expect_message(object = match_yt_song("https://www.youtube.com/watch?v=E1mU6h4Xdxc"), regexp = "Returning statistics for Spotify song corresponding to.*")
  testthat::expect_message(song <- match_yt_song("https://www.youtube.com/watch?v=E1mU6h4Xdxc"), regexp = "Spotify song was identified as.*")
  testthat::expect_type(song, "list")
})

# testing what happens if user inputs:

# -a non-YouTube URL
testthat::test_that("YouTube URL specific", {
  testthat::expect_error(match_yt_song("https://www.google.com"))
})

# -a non-character type
testthat::test_that("character specific", {
  testthat::expect_error(match_yt_song(8))
})
