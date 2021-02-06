#' Invite a collaborator to a Github repo
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param invitee The person to invite.
#' @param ... Additional parameters, see https://docs.github.com/rest/reference/repos#add-a-repository-collaborator
#'
#' @export

gh_invite <- function(path, invitee, ...) {

  if(missing(path)) {
    path <- as.character(gh::gh_tree_remote())
  } else {
    path <- unlist(strsplit(path, split = "/"))
  }

  invisible(
    gh::gh("PUT /repos/{owner}/{repo}/collaborators/{username}",
           owner = path[1],
           repo = path[2],
           username = invitee,
           ...)
  )
}

#' Create an issue on a github repo
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param title The issue's title
#' @param body The issue's body text
#' @param ... Additional parameters, see https://docs.github.com/en/rest/reference/issues#create-an-issue
#'
#' @export
#'
gh_issue <- function(path, title, body, ...) {

  if(missing(path)) {
    path <- as.character(gh::gh_tree_remote())
  } else {
    path <- unlist(strsplit(path, split = "/"))
  }

  invisible(
    gh::gh("POST /repos/{owner}/{repo}/issues",
           owner = path[1],
           repo = path[2],
           title = title,
           body = body,
           ...)
  )
}
