
#' Create an issue on a github repo
#'
#' @param path GitHub repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param title The issue's title
#' @param body The issue's body text
#' @param ... Additional parameters, see \url{https://docs.github.com/en/rest}
#'
#' @return NA; used for side effects to create a new issue on the specified GitHub repository.
#'
#' @export
#' @family Issues
#'
gh_issue_new <- function(path, title, body, ...) {

  # For subsetting the issues later
  issue_title <- title

  path <- check_path(path)

  invisible(
    gh::gh("POST /repos/{owner}/{repo}/issues",
           owner = path[1],
           repo = path[2],
           title = title,
           body = body,
           ...)
  )

  issues <- gh_issue_list(path = paste0(path[1], "/", path[2]),
                          ...)

  new_issue_link <- tryCatch(
    subset(issues, title == issue_title)$html_url[[1]],
    error = function(c) stop("hmm...the issue wasn't created. Maybe check your token permissions?")
  )


  message(paste0("Issue created at ", path[1], "/", path[2], " and can be viewed here: \n", new_issue_link))

}

#' List issues for a GitHub Repo
#'
#' @inheritParams gh_issue_new
#'
#' @return A list of issues for the specified GitHub repo
#' @export
#' @family Issues
#'
gh_issue_list <- function(path, ...) {

  path <- check_path(path)

  issues <- gh::gh("GET /repos/{owner}/{repo}/issues",
                   owner = path[1],
                   repo = path[2],
                   ...)

  output <- jsonlite::fromJSON(
    jsonlite::toJSON(issues)
  )

  return(output)

}

#' Comment on a GitHub issue
#'
#' @inheritParams gh_issue_new
#' @param issue_number The issue number on which to comment. Can be determined online or with \code{\link{gh_issue_list}}
#'
#' @return NA; called for side effects.
#'
#' @export
#' @family Issues
#'
gh_issue_comment <- function(path, issue_number, body, ...) {
  path <- check_path(path)

  invisible(
    gh::gh("POST /repos/{owner}/{repo}/issues/{issue_number}/comments",
           owner = path[1],
           repo = path[2],
           issue_number = issue_number,
           body = body,
           ...)
  )
}


#' Check to see if a person was mentioned in a GitHub issue
#'
#' @inheritParams gh_collab_invite
#'
#' @return TRUE if the collaborator was mentioned in any issues; FALSE otherwise
#' @export
#' @family Issues
#'
gh_issue_mention <- function(path, collaborator, ...) {

  list_issues <- gh_issue_list(path = path, mentioned = collaborator, ...)

  if (length(list_issues) == 0) {
    FALSE
  } else {
    TRUE
  }

}

#' Assign people to a GitHub issue
#'
#' @inheritParams gh_collab_invite
#' @inheritParams gh_issue_comment
#'
#' @return NA; called for side effects
#' @export
#' @family Issues
#'
gh_issue_assign <- function(path, issue_number, collaborator, ...) {


  assignable <- gh_check_assignable(path = path, assignee = collaborator, messages = FALSE)

  path <- check_path(path)

  if (assignable) {

    invisible(
      gh::gh("POST /repos/{owner}/{repo}/issues/{issue_number}/assignees",
             owner = path[1],
             repo = path[2],
             issue_number = issue_number,
             assignees = collaborator,
             ...)
    )
  } else {
    stop(paste0("Sorry, but ", collaborator, " does not have access to the ", path[2], " repo."))
  }
}

