test_that("HTTPS clone works", {
  expect_equal("https://github.com/jdtrat/ghee.git",
               gh_get_clone_url("jdtrat/ghee"))
})

test_that("SSH clone works", {
  expect_equal("git@github.com:jdtrat/ghee.git",
               gh_get_clone_url("jdtrat/ghee",
                                clone_type = "SSH"))
})

test_that("GitHub CLI clone works", {
  expect_equal("gh repo clone jdtrat/ghee",
               gh_get_clone_url("jdtrat/ghee",
                                clone_type = "GitHub CLI"))
})
