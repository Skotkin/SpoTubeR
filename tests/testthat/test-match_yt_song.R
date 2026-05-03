# checking that the appropriate 2 messages are printed when a Spotify video match is found
testthat::test_that("match messages work", {
  testthat::expect_message(object = match_yt_song('https://www.youtube.com/watch?v=E1mU6h4Xdxc'), regexp = "Returning statistics for Spotify Songs corresponding to.*")
  testthat::expect_message(object = match_yt_song('https://www.youtube.com/watch?v=E1mU6h4Xdxc'), regexp = "Spotify song was identified as.*")
})

# checking that the output is a list
testthat::test_that("returns list", {
  testthat::expect_type(match_yt_song("https://www.youtube.com/watch?v=E1mU6h4Xdxc"), 'list')
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
