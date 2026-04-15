# IDEAS FOR TESTS
# testing what happens if user inputs:
# -a non-Spotify URL
# -a URL to a different Spotify page (e.g. to a song instead of an artist)
# -a non-character type
# checking if the function prints two messages when provided with a valid input
# checking that the function returns a list
# checking that the function still works for artists with less than 10 top songs

URL_spot <- 'https://open.spotify.com/track/65DbTqJKhbwqYbZ1Okr0rc?si=4e9a52796fff470f'
URL_not <- 'https://www.youtube.com/watch?v=nUsrYVxrDwI&list=RDnUsrYVxrDwI'

testthat::test_that("URL spotify specific works", {
  # User inputs a non-spotify URL
  testthat::expect_error(artist_comp('https://www.youtube.com/watch?v=nUsrYVxrDwI&list=RDnUsrYVxrDwI'))
  })

testthat::test_that("URL for artist works", {
  # User inputs a URL to a song instead of an artist
  testthat::expect_error(artist_comp('https://open.spotify.com/track/65DbTqJKhbwqYbZ1Okr0rc?si=4e9a52796fff470f'))
  })

testthat::test_that("type is a character", {
  # User inputs a non-character type
  testthat::expect_error(artist_comp(12))
})

testthat::test_that("two messages works", {
  # checking if the function prints two messages when provided with a valid input
  testthat::expect_message(artist_comp('https://open.spotify.com/artist/6BRxQ8cD3eqnrVj6WKDok8?si=ImCQ7g50TBaQQ2ikChEZdg'))
})

testthat::test_that("list return works", {
  # checking that the function returns a list
  testthat::expect_identical(class(artist_comp('https://open.spotify.com/artist/7zPS0577bqv2gQDSDa34Gf?si=844m5H6FRYSatUwqbnzSaA'), "list"))
})

testthat::test_that("less common artists works", {
  # checking that the function still works for artists with less than 10 top songs
  testthat::expect_no_error(artist_comp('https://open.spotify.com/artist/7zPS0577bqv2gQDSDa34Gf?si=844m5H6FRYSatUwqbnzSaA'))
})
