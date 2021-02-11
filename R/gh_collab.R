#' Invite a collaborator to a Github repo
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param invitee The person to invite.
#' @param ... Additional parameters, see https://docs.github.com/rest/reference/repos#add-a-repository-collaborator
#'
#' @export

gh_collab_invite <- function(path, invitee, ...) {

  path <- check_path(path = path)

  invisible(
    gh::gh("PUT /repos/{owner}/{repo}/collaborators/{username}",
           owner = path[1],
           repo = path[2],
           username = invitee,
           ...)
  )
}

#' Check if a user is a collaborator
#'
#' @param path
#' @param collaborator
#' @param messages
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
gh_collab_check <- function(path, collaborator, ..., messages = TRUE) {

  if (missing(collaborator)) stop("Must supply user collaborator to check for.")
  path <- check_path(path = path)

  result <-
    if (
      isFALSE(
        tryCatch(gh::gh("GET /repos/{owner}/{repo}/collaborators/{username}",
                        owner = path[1],
                        repo = path[2],
                        username = collaborator,
                        ...),
                 error = function(c) FALSE))) {FALSE} else {TRUE}

  if (messages) {
    if(result) {
      message(paste0(collaborator), " is a member of the ", path[2], " repository.")
    } else {
      message(paste0(collaborator), " is not a member of the ", path[2], " repository.")
    }
  }

  return(result)

}
