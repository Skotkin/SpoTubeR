# testing what happens if user inputs:
# -a non-YouTube URL
# -a URL to a different YouTube page (e.g. to a song instead of an artist)
# -a non-character type
# checking if the function prints two messages when provided with a valid input
# checking that the function returns a list
# checking that the function still works for artists with less than 10 top songs

testthat::test_that("URL YouTube specific works", {
  # User inputs a non-YouTube URL
  testthat::expect_error(yt_artist_comp("https://www.google.com"))
})

testthat::test_that("type is a character", {
  # User inputs a non-character type
  testthat::expect_error(yt_artist_comp(12))
})

testthat::test_that("two messages works", {
  # checking if the function prints message output when provided with a valid input
  testthat::expect_message(object = yt_artist_comp("https://www.youtube.com/channel/UCqC_GY2ZiENFz2pwL0cSfAw"), regexp = "Retrieving YouTube subscriber count associated with.*")
  testthat::expect_message(object = yt_artist_comp("https://www.youtube.com/channel/UCqC_GY2ZiENFz2pwL0cSfAw"), regexp = "Retrieving Spotify statistics associated with.*")
})

testthat::test_that("list return works", {
  # checking that the function returns a list
  testthat::expect_identical(class(yt_artist_comp("https://www.youtube.com/channel/UCqC_GY2ZiENFz2pwL0cSfAw")), "list")
})

testthat::test_that("less common artists works", {
  # checking that the function still works for artists with less than 10 top songs on Spotify and a low YouTube view count (<500)
  testthat::expect_no_error(yt_artist_comp("https://www.youtube.com/channel/UCoxnsf4tTMAyUkWj84WB71w"))
})
