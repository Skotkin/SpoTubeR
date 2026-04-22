# IDEAS FOR TESTS

# testing what happens if R environ does vs. doesn't already exist on the user's computer
testthat::test_that("", {
  testthat::expect_error(auth_creds())
})

# checking that the user-provided values are successfully saved into the R environ whether or not the associated variable names already existed in the R environ
testthat::test_that("", {
  testthat::expect_error(auth_creds())
})

# testing what happens if the user provides a non-character input
testthat::test_that("non-character", {
  testthat::expect_error(auth_creds())
})
