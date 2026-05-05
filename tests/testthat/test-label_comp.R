# testing what happens if user inputs:

# -an invalid record label name (the "No artists were returned" error message should appear)
testthat::test_that("label name doesn't exist", {
  testthat::expect_error(label_comp("kfflkmmawlgerkj"))
})

# -a non-character type
testthat::test_that("label name isn't a character", {
  testthat::expect_error(label_comp(7))
})

# checking if the function prints two messages for each artist returned for the given label
# and checking if the function returns a list
testthat::test_that("messages and list work", {
  testthat::expect_message(universal_comp <- label_comp("Universal"))
  testthat::expect_type(universal_comp, "list")
})
