#' Check github path
#'
#' @param path
#' @keywords internal
#'
check_path <- function(path) {

  if(missing(path)) {
    as.character(gh::gh_tree_remote())
  } else {
    unlist(strsplit(path, split = "/"))
  }
}




#' Check that a person can be assigned to an issue
#'
#' @param path
#' @param assignee
#'
#' @keywords internal
gh_check_assignable <- function(path, assignee, ..., messages = TRUE) {

  path <- check_path(path = path)

  result <-
    if (
      isFALSE(
        tryCatch(gh::gh("GET /repos/{owner}/{repo}/assignees/{assignee}",
                        owner = path[1],
                        repo = path[2],
                        assignee = assignee,
                        ...),
                 error = function(c) FALSE))) {FALSE} else {TRUE}

  if (messages) {
    if(result) {
      message(paste0(assignee), " can be assigned to an issue of the ", path[2], " repository.")
    } else {
      message(paste0(assignee), " cannot be assigned to an issue of the ", path[2], " repository.")
    }
  }

  return(result)

}
