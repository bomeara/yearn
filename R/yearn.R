#' Do yearn on a single package
#' @param pkg The string with the package name
#' @param prompt Ask user which of several options to choose
#' @return NULL if success, a string describing the problem ohterwise
yearn.one <- function(pkg, prompt=FALSE) {
  failure.type <- NULL
  if(!suppressWarnings(require(pkg, character.only=TRUE, quietly=TRUE))) {
    suppressWarnings(utils::install.packages(pkg, quiet=TRUE, verbose=FALSE))
    if(!suppressWarnings(require(pkg, character.only=TRUE, quietly=TRUE))) {
      potential.packages <- suppressWarnings(githubinstall::gh_suggest(pkg))
      if(length(potential.packages)==1) {
        suppressWarnings(githubinstall::githubinstall(potential.packages, ask=FALSE, quiet=TRUE))
        if(!suppressWarnings(require(pkg, character.only=TRUE, quietly=TRUE))) {
          failure.type <- paste(pkg, ": installed", potential.packages, "for", pkg, "but", pkg, "not loaded")
        }
      }
      if(length(potential.packages)==0) {
        failure.type <- paste(pkg, ": no matches for", pkg)
      }
      if(length(potential.packages)>1) {
        if(!prompt) {
          failure.type <- paste(pkg, ": there were", length(potential.packages),"matches for", pkg, "on github")
        } else {
          cat(paste("Need user input for package", pkg,"\n\n"))
          githubinstall::githubinstall(pkg)
          if(!suppressWarnings(require(pkg, character.only=TRUE, quietly=TRUE))) {
            failure.type <- paste(pkg, ": there were", length(potential.packages),"matches for", pkg, "on github; tried to install one, but it still would not load")
          }
        }
      }
    }
  }
  return(failure.type)
}

#' Do yearn on a vector
#' @param package A vector of packages (could be length 1)
#' @param success.return If FALSE, only return info on failing packages
#' @param prompt If TRUE, ask user to choose between options.
#' @return A list of return strings (NULL if installed)
#' @export
yearn <- function(package, success.return=FALSE, prompt=TRUE) {
  result <- sapply(package, yearn.one, prompt=prompt)
  if(!success.return) {
    result <- result[!sapply(result, is.null)]
  }
  return(result)
}
