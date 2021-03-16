# ghee

#### Easily Interact with 'GitHub' through R

<!-- badges: start -->

[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

[![CRAN status](https://www.r-pkg.org/badges/version/ghee)](https://CRAN.R-project.org/package=ghee)
<!-- badges: end -->

------------------------------------------------------------------------

<img src="https://www.jdtrat.com/packages/ghee/resources/ghee_hex.png" width="328" height="378" align="right"/>

{ghee} is a user-friendly wrapper for the [{gh}](https://gh.r-lib.org/) package that provides client access to GitHub's REST API for common tasks such as creating issues and inviting collaborators.

## Table of contents

-   [Installation](#installation)
-   [Getting Started](#getting-started)
-   [Further Reading](#further-reading)
-   [Feedback](#feedback)
-   [Code of Conduct](#code-of-conduct)

------------------------------------------------------------------------

## Installation

You can install the development version of {ghee} from GitHub and load it as follows:

``` {.r}
# Install the development version from GitHub
remotes::install_github("jdtrat/ghee")

# Load package
library(ghee)
```

## Getting Started

{ghee} is **not** meant to be an exhaustive package, though I do hope it will help you interact with GitHub easier. By design, all functions begin with the prefix `gh_`, followed by categories of actions such as `collab` and `issue`. This allows you to take advantage of RStudio's auto-completion feature and quickly achieve your programming goals. Below are currently supported functions.

### Repositories

{ghee} provides the following functions for interacting with GitHub repositories.

|      Function       |                                                     Description                                                      | Example Use                                                                          |
|:-------------------:|:--------------------------------------------------------------------------------------------------------------------:|--------------------------------------------------------------------------------------|
| `gh_repos_create()` |                                           Create a new GitHub repository.                                            | `gh_repos_create(path = "jdtrat/ghee_test", private = TRUE))`                        |
| `gh_repos_delete()` |                             Delete an existing GitHub repository. **Use with caution.**                              | `gh_repos_delete(path = "jdtrat/ghee_test")`                                         |
| `gh_repos_mutate()` | Mutate (alter) a repository's features. Potential changes include the repository's name, privacy settings, and more. | `gh_repos_mutate(path = "jdtrat/ghee_test", name = "ghee_testing", private = FALSE)` |
|  `gh_repos_list()`  |                                          List a user's GitHub repositories.                                          | `gh_repos_list(user = "jdtrat")`                                                     |

### Issues

{ghee} provides the following functions for dealing with GitHub issues.

|       Function       |                                 Description                                  | Example Use                                                                                     |
|:--------------------:|:----------------------------------------------------------------------------:|-------------------------------------------------------------------------------------------------|
|   `gh_issue_new()`   |                 Create a new issue for a GitHub repository.                  | `gh_issue_new(path = "jdtrat/ghee", title = "README Demo", body = "{ghee} is great!")`          |
| `gh_issue_comment()` |            Comment on an existing issue for a GitHub repository.             | `gh_issue_comment(path = "jdtrat/ghee", issue_number = 1, body = "Commenting from the README")` |
| `gh_issue_assign()`  |  Assign yourself, or others, to an existing issue for a GitHub repository.   | `gh_issue_assign(path = "jdtrat/ghee", issue_number = 1, collaborator = "jdtrat")`              |
| `gh_issue_mention()` | Check to see if a person was mentioned in any issues of a GitHub repository. | `gh_issue_mention(path = "jdtrat/ghee", collaborator = "jdtrat")`                               |
|  `gh_issue_list()`   |                List existing issues for a GitHub repository.                 | `gh_issue_list("jdtrat/ghee")`                                                                  |

### Collaboration

{ghee} provides the following functions for collaborating via GitHub.

|        Function        |                                   Description                                   | Example Use                                                              |
|:----------------------:|:-------------------------------------------------------------------------------:|--------------------------------------------------------------------------|
|  `gh_collab_check()`   |        Check to see if someone is a collaborator on a GitHub repository.        | `gh_collab_check(path = "jdtrat/ghee", collaborator = "hadley")`         |
|  `gh_collab_invite()`  |              Invite someone to collaborate on a GitHub repository.              | `gh_collab_invite(path = "jdtrat/ghee", collaborator = "hadley")`        |
| `gh_collab_pending()`  |                List the pending invites for a GitHub repository.                | `gh_collab_pending(path = "jdtrat/ghee")`                                |
| `gh_collab_uninvite()` | Uninvite someone whose invite to collaborate on a GitHub repository is pending. | `gh_collab_uninvite(path = "jdtrat/ghee", collaborator = "mean-person")` |
|  `gh_collab_remove()`  |            Remove an existing collaborator from a GitHub repository.            | `gh_collab_remove(path = "jdtrat/ghee", collaborator = "mean-person")`   |

## Further Reading

If you are looking for a more in-depth explanation of these functions, I encourage you to check out my [blog post introducing {ghee}](https://www.jdtrat.com/blog/projects/ghee/).

## Feedback

If you want to see a feature, or report a bug, please [file an issue](https://github.com/jdtrat/ghee/issues) or open a [pull-request](https://github.com/jdtrat/ghee/pulls)! As this package is just getting off the ground, we welcome all feedback and contributions. See our [contribution guidelines](https://github.com/jdtrat/ghee/blob/main/.github/CONTRIBUTING.md) for more details on getting involved!

## Code of Conduct

Please note that the ghee project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
