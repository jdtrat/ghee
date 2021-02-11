
#' Create an issue on a github repo
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param title The issue's title
#' @param body The issue's body text
#' @param ... Additional parameters, see https://docs.github.com/en/rest/reference/issues#create-an-issue
#'
#' @export
#'
gh_issue_new <- function(path, title, body, ...) {

  path <- check_path(path = path)

  invisible(
    gh::gh("POST /repos/{owner}/{repo}/issues",
           owner = path[1],
           repo = path[2],
           title = title,
           body = body,
           ...)
  )
}



#' List issues for a Github Repo
#'
#' @param path Github repo path of the form "{username}/{repo}". If not provided, will default to current repo.
#' @param ... Additional parameters, see https://docs.github.com/en/rest/reference/issues#list-repository-issues
#'
#' @return
#' @export
#'
#' @examples
gh_issue_list <- function(path, ...) {

  path <- check_path(path = path)

  issues <- gh::gh("GET /repos/{owner}/{repo}/issues",
                   owner = path[1],
                   repo = path[2],
                   ...)

  output <- jsonlite::fromJSON(
    jsonlite::toJSON(issues)
  )

  return(output)

}

#' Comment on a Github issue
#'
#' @param path
#' @param issue_number
#' @param body
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
gh_issue_comment <- function(path, issue_number, body, ...) {
  path <- check_path(path = path)

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
#' @param path
#' @param collaborator
#' @param ...
#'
#' @return TRUE if the collaborator was mentioned in any issues; FALSE otherwise
#' @export
#'
gh_issue_mention <- function(path, collaborator, ...) {

  list_issues <- gh_issue_list(path, mentioned = collaborator, ...)

  if (length(list_issues) == 0) {
    FALSE
  } else {
    TRUE
  }

}

#' Assign people to a Github issue
#'
#' @param path
#' @param issue_number
#' @param assignees
#' @param ...
#'
gh_issue_assign <- function(path, issue_number, assignees, ...) {

  assignable <- vapply(assignees,
                       gh_check_assignable,
                       path = path,
                       messages = FALSE,
                       ...,
                       FUN.VALUE = logical(1))

  path <- check_path(path = path)

  if (all(assignable)) {

    invisible(
      gh::gh("POST /repos/{owner}/{repo}/issues/{issue_number}/assignees",
             owner = path[1],
             repo = path[2],
             issue_number = issue_number,
             assignees = assignees,
             ...)
    )
  } else {
    stop("One of the assignees does not have access to the repo.")
  }
}

