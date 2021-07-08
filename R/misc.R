
#' Get Clone URL for a Repository
#'
#' This function is a basic utility tool for getting a remote repository's
#' cloning URL. This is especially helpful when creating an RStudio Project from
#' a repository hosted on GitHub.
#'
#' @param path GitHub repo path of the form "{username}/{repo}". If not
#'   provided, will default to current repo.
#' @param clone_type Method to clone remote repositories with. Default is
#'   "HTTPS". "SSH" and "GitHub CLI" are also supported. See
#'   \url{https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories}
#'    for more details.
#'
#' @return A cloning URL corresponding to the GitHub repo suppliied by the
#'   'path' argument.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' # Create a Private Repo
#' gh_repos_create(path = "jdtrat/ghee_test", private = TRUE, description = "A test repository.")
#'
#' gh_get_clone_url("jdtrat/ghee_test")
#'
#' }
#'
gh_get_clone_url <- function(path, clone_type = "HTTPS") {
  path <- check_path(path)

  if (clone_type == "HTTPS") {
    paste0("https://github.com/", path[1], "/", path[2], ".git")
  } else if (clone_type == "SSH") {
    paste0("git@github.com:", path[1], "/", path[2], ".git")
  } else if (clone_type == "GitHub CLI") {
    paste0("gh repo clone ", path[1], "/", path[2])
  }

}
