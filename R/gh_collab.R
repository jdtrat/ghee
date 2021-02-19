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

#' Uninvite a collaborator to a Github repo
#'
#' This only works if the individual's invite is pending.
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param uninvitee The person to uninvite.
#' @param ... Additional parameters, see https://docs.github.com/rest/reference/repos#add-a-repository-collaborator
#'
#' @export

gh_collab_uninvite <- function(path, uninvitee, ...) {

  #substitute the uninvitee for delayed evaluation
  uninvitee <- substitute(uninvitee)

  path <- check_path(path = path)

  # list the pending invites
  pending <- gh::gh("GET /repos/{owner}/{repo}/invitations",
                    owner = path[1],
                    repo = path[2],
                    ...)

  # get the invitation ids
  ids <- data.frame(ids = do.call(rbind, lapply(pending, "[[", "id")))
  # get the usernames for whom those ids apply
  users <- data.frame(usernames = do.call(rbind, data.frame(do.call(rbind, lapply(pending, "[[", "invitee")))$login))
  #overwrite pending with just the relevant info
  pending <- cbind(ids, users)
  invite_id <- subset(pending, usernames == eval(uninvitee, envir = pending))$ids

  invisible(
    gh::gh("DELETE /repos/{owner}/{repo}/invitations/{invitation_id}",
           owner = path[1],
           repo = path[2],
           invitation_id = invite_id)
  )
}


#' Check if a user is a collaborator
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param collaborator Github username to check if they are a collaborator
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

#' List pending invitations for a repo
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param ... Additional parameters, see GitHub API
#'
#' @return A dataframe listing the usernames of pending invitees (or dataframe of length 0 if no pending invitees).
#' @export
#'
gh_collab_pending_invites <- function(path, ...) {

  path <- check_path(path = path)

  pending <- gh::gh("GET /repos/{owner}/{repo}/invitations",
                    owner = path[1],
                    repo = path[2],
                    ...)

  if (length(pending) == 0) {
    output <- data.frame(usernames = NULL)
  } else {
    output <- data.frame(usernames = do.call(rbind, data.frame(do.call(rbind, lapply(pending, "[[", "invitee")))$login))
    rownames(output) <- NULL
  }

  return(output)

}

