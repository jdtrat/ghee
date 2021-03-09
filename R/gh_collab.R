#' Invite a collaborator to a GitHub repo
#'
#' @param path GitHub repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param collaborator The collaborator for whom to call this function.
#' @param ... Additional parameters, see \url{https://docs.github.com/en/rest}
#'
#' @return NA; used for side effects to invite a collaborator to the specified GitHub repository.
#'
#' @export
#' @family Collaborations

gh_collab_invite <- function(path, collaborator, ...) {

  path <- check_path(path)

  invisible(
    gh::gh("PUT /repos/{owner}/{repo}/collaborators/{username}",
           owner = path[1],
           repo = path[2],
           username = collaborator,
           ...)
  )
}

#' Uninvite a collaborator to a GitHub repo
#'
#' This only works if the individual's invite is pending.
#'
#' @inheritParams gh_collab_invite
#'
#' @return NA; called for side effects to uninvite a collaborator to the specified GitHub repository.
#'
#' @export
#' @family Collaborations

gh_collab_uninvite <- function(path, collaborator, ...) {

  path <- check_path(path)

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
  invite_id <- pending[pending$usernames == collaborator, "ids"]

  invisible(
    gh::gh("DELETE /repos/{owner}/{repo}/invitations/{invitation_id}",
           owner = path[1],
           repo = path[2],
           invitation_id = invite_id)
  )

}

#' List pending invitations for a repo
#'
#' @inheritParams gh_collab_invite
#'
#' @return A dataframe listing the usernames of pending invitees (or dataframe of length 0 if no pending invitees).
#' @export
#' @family Collaborations
#'
gh_collab_pending <- function(path, ...) {

  path <- check_path(path)

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

#' Check if a user is a collaborator
#'
#' @inheritParams gh_collab_invite
#' @param messages Logical: Should a message indicating the status of the function be printed? TRUE by default.
#'
#' @return TRUE if the individual is a collaborator on the repo; FALSE otherwise.
#'
#' @seealso [gh_collab_list()] for listing all current repository collaborators.
#' @export
#' @family Collaborations
#'
gh_collab_check <- function(path, collaborator, ..., messages = TRUE) {

  if (missing(collaborator)) stop("Must supply user collaborator to check for.")
  path <- check_path(path)

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

#' List current collaborators for a GitHub repo
#'
#' @inheritParams gh_collab_invite
#'
#' @return A data frame that contains the collaborators for the specified repository.
#'
#' @export
#'
#' @seealso [gh_collab_check()] for checking whether a specific user is a collaborator.
#' @family Collaborations
#'
gh_collab_list <- function(path, ...) {

  path <- check_path(path)

  collaborators <- gh::gh("GET /repos/{owner}/{repo}/collaborators",
                          owner = path[1],
                          repo = path[2],
                          ...)

  output <- as.data.frame(do.call(rbind, lapply(collaborators, "[[", "login")))
  names(output) <- "collaborators"
  rownames(output) <- NULL

  return(output)

}

#' Remove a collaborator from a repository
#'
#' This will remove a collaborator from a repository and confirm the individual is no longer a member.
#'
#' @inheritParams gh_collab_invite
#' @param messages Logical: Should a message indicating the status of the function be printed? TRUE by default.
#'
#' @return NA; called for its side effects.
#' @export
#' @family Collaborations
#'
gh_collab_remove <- function(path, collaborator, ..., messages = TRUE) {

  path <- check_path(path)

  invisible(
    gh::gh("DELETE /repos/{owner}/{repo}/collaborators/{username}",
           owner = path[1],
           repo = path[2],
           username = collaborator,
           ...)
  )

  if (gh_collab_check(path = path, collaborator = collaborator, ..., messages = messages)) {
    stop(paste0("hmm...", collaborator, " is still a collaborator. Maybe check your token permissions?"))
  }

}
