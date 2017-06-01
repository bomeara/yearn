test_that("A package with no matches does not match", {
 options(repos="https://cloud.r-project.org/")
 result <- (yearn(Iamapackagethatdoesnotexistnorwillever))
 expect_equal(length(result), 1)
})

test_that("FindClosestPackage can return multiple matches", {
  options(repos="https://cloud.r-project.org/")
  result <- FindClosestPackage("ggplot2", auto.select=FALSE)
  expect_gte(length(result),2)
})

test_that("FindClosestPackage selects properly", {
  options(repos="https://cloud.r-project.org/")
  result <- FindClosestPackage("ggplot2", auto.select=TRUE)
  expect_equal(length(result),1)
  expect_true(grepl("tidyverse", result))
})
