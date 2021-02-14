
gh_secrets_list <- function(path, ...) {

  path <- check_path(path = path)

  secrets <- gh::gh("GET /repos/{owner}/{repo}/actions/secrets",
                    owner = path[1],
                    repo = path[2],
                    ...)

  output <- jsonlite::fromJSON(
    jsonlite::toJSON(secrets)
  )

  return(output)
}

