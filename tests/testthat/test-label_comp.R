# IDEAS FOR TESTS

# testing what happens if user inputs:

# -an invalid record label name (the "No artists were returned" error message should appear)
testthat::test_that("label name doesn't exist", {
  testthat::expect_error(label_comp('kfflkmmawlgerkj'))
})

# -a non-character type
testthat::test_that("label name isn't a character", {
  testthat::expect_error(label_comp(7))
})

# test commented out because it failed in the R CMD check due to exceeding the YouTube API usage quota at that point. it did work when I tried it before
# checking if the function prints two messages for each artist returned for the given label
#testthat::test_that("messages work", {
#  testthat::expect_message(label_comp("Universal"))
#})

# test commented out because it failed in the R CMD check due to exceeding the YouTube API usage quota at that point. it did work when I tried it before
# checking that the function returns a list
#testthat::test_that("returns list", {
#  testthat::expect_type(label_comp("Universal"), 'list')
#})

# test commented out because it failed in the R CMD check due to exceeding the YouTube API usage quota at that point. it did work when I tried it before
# checking that the function works for labels with less than 5 associated artists
#testthat::test_that("Small labels work", {
  #pondless has one artist (independent label)
#  testthat::expect_no_error(label_comp("pondless"))
#})

# test commented out because it failed in the R CMD check due to exceeding the YouTube API usage quota at that point. it did work when I tried it before
# checking that the function works for artists with less than 5 top songs
#testthat::test_that("Small artists work", {
  # Artist Gsjdb hdbf w/label ETIMATIC only has one song
#  testthat::expect_no_error(label_comp("ETIMATIC"))
#})
