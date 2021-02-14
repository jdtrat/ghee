
#' Create a new repository
#'
#' @param name Name of the repository.
#' @param private Will this repository be private? TRUE/FALSE; default is TRUE.
#' @param description A short description of the repository.
#' @param ... Any other parameters (https://docs.github.com/en/rest/reference/repos#create-a-repository-for-the-authenticated-user)
#'
#' @export
#'
gh_repos_create <- function(name, private = TRUE, description = NULL, ...) {

  invisible(
    gh::gh("POST /user/repos",
         name = name,
         private = private,
         description = NULL,
         ...)
  )

}

#' List a user's github repository
#'
#' @param username
#' @param ...
#'
#' @return Repositories for the specified user
#' @export
#'
#' @example gh_repos_list("jdtrat")

gh_repos_list <- function(user, ...) {

  repos <- gh::gh("GET /users/{username}/repos",
         username = user,
         ...)

  output <- jsonlite::fromJSON(
    jsonlite::toJSON(repos)
  )

  return(output)

}

#' Actually delete repo
#'
#' @param owner
#' @param repo
#' @param ...
#'
#' @keywords internal
#'
gh_repos_delete_internal <- function(owner, repo, ...) {

  gh::gh("DELETE /repos/{owner}/{repo}",
         owner = owner,
         repo = repo,
         ...)

  cat(paste0("Okay, the ", repo, " repository was just deleted."))

}


#' Delete a Github repository
#'
#' \strong{Use with caution!} By default the github token created with `usethis`
#' does not allow this functionality. You must create your own PAT that has the
#' appropriate permissions to delete repositories.
#'
#' @param path Github repo path of the form "{username}/{repo}".
#' @param ...
#'
#' @export
#'
gh_repos_delete <- function(path, ...) {

  path <- check_path(path = path)

  yes <- paste0("Yes, I want to permanently delete the ", path[2], " repository.")
  no <- paste0("No, I don't want to permanently delete the ", path[2], " repository.")
  no_2 <- paste0("Aw hell naw. I do NOT want to permanently delete the ", path[2], " repository.")

  switch(menu(c(no, yes, no_2), title = paste0("Are you sure you want to permanently delete the ", path[2], " repository?")),
         cat(paste0("Noice, the ", path[2], " repository was not deleted.")),
         gh_repos_delete_internal(owner = path[1], repo = path[2], ...),
         cat(paste0("Your wish is my command. The ", path[2], " repository was not deleted.")))
}

#' Change repository settings
#'
#' @param path Github repo path of the form "{username}/{repo}".
#' @param ... Any of the options here https://docs.github.com/en/rest/reference/repos#update-a-repository
#'
#' @export
#'
#'
gh_repos_mutate <- function(path, ...) {

  path <- check_path(path = path)

  invisible(
  gh::gh("PATCH /repos/{owner}/{repo}",
         owner = path[1],
         repo = path[2],
         ...)
  )
}


