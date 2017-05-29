#' Do yearn on a single package
#' @param pkg The string with the package name
#' @param maxdist The maximum distance that counts as a match
#' @return NULL if success, a string describing the problem otherwise
yearn.one <- function(pkg, maxdist=0) {
  failure.type <- NULL
  if(!suppressWarnings(require(pkg, character.only=TRUE, quietly=TRUE))) {
    everything.installed <- utils::installed.packages()
    matching.installed <- everything.installed[grepl(paste0('^', pkg, '$'),everything.installed,ignore.case=TRUE)] #based on answer from https://stackoverflow.com/questions/39996324/case-insensitive-package-installation-ignore-case-while-installing-packages/39996637
    if(length(matching.installed)==1) {
      if(suppressWarnings(require(matching.installed, character.only=TRUE, quietly=FALSE))) {
        print(paste("You asked for", pkg, "but it's actually", matching.installed, "-- package names are case-sensitive. Loaded, but fix this in the future."))
      }
    } else {
      print(paste(pkg, "not installed, now going to try to find it on CRAN"))
      on.cran <- utils::available.packages()[,"Package"]
      to.install <- on.cran[grepl(paste0('^', pkg, '$'),on.cran,ignore.case=TRUE)] #based on answer from https://stackoverflow.com/questions/39996324/case-insensitive-package-installation-ignore-case-while-installing-packages/39996637
      if(length(to.install)==1 && pkg != to.install) {
        print(paste("You asked for", pkg, "but it's actually", matching.installed, "on CRAN. Package names are case-sensitive. Will try to load anyway, but fix this in the future."))
        pkg <- to.install
      }
      suppressWarnings(utils::install.packages(pkg, quiet=FALSE, verbose=FALSE))
      if(!suppressWarnings(require(pkg, character.only=TRUE, quietly=TRUE))) {
        print(paste("Installing", pkg, "from CRAN failed, now trying to install from github"))
        potential.packages <- FindClosestPackage(pkg, maxdist=maxdist)
        print(paste("Now trying to install", potential.packages, "from github"))
        if(length(potential.packages)==1) {
          suppressWarnings(githubinstall::githubinstall(potential.packages, ask=FALSE, quiet=FALSE))
          new.pkg.name <- strsplit(potential.packages, '/')[[1]][2]
          if(!suppressWarnings(require(new.pkg.name, character.only=TRUE, quietly=TRUE))) {
            failure.type <- paste(pkg, ": installed", potential.packages, "for", pkg, "but", pkg, "not loaded")
          } else {
            print(paste("Successfully installed", pkg, "from", potential.packages, "on github"))
          }
        }
        if(length(potential.packages)==0) {
          failure.type <- paste(pkg, ": no matches for", pkg)
          print(paste("Did not successfully install", pkg))
        }
      } else {
        print(paste("Successfully installed", pkg, "from CRAN"))
      }
    }
  }
  return(failure.type)
}

#' Do yearn on a vector
#' @param package A vector of packages (could be length 1)
#' @param maxdist The maximum distance that counts as a match
#' @return A list of return strings (NULL if installed); by default invisible, wrap in parens if you want to see
#' @export
yearn <- function(package, maxdist=0) {
  result <- sapply(package, yearn.one, maxdist=maxdist)
  return(invisible(result))
}

#' Find closest matching package
#' @param pkg A single package
#' @param maxdist The maximum distance that counts as a match
#' @param auto.select If TRUE, make a best guess in case of multiple equally good
#' @param username.pref In case of matches, user names in order of preference.
#' @return pkgs that match the constraints
#' @export
#' @examples
#' yearn("TreEvo") # A package on github, not CRAN (yet)
#'
#' @details
#' Inspired by githubinstall::gh_suggest() but allows being pickier about match
FindClosestPackage <- function(pkg, maxdist=2, auto.select=TRUE, username.pref = c("ropensci", "rstudio", "tidyverse", "hadley", "yihui", "RcppCore", "eddelbuettel", "ropenscilabs", "hrbrmstr", "bomeara")) {
  githubinstall::gh_update_package_list()
  all.packages <- githubinstall::gh_list_packages()
  distances <- utils::adist(pkg, all.packages$package_name, ignore.case=TRUE)
  min.dist <- min(distances)
  closest <- which(distances==min.dist)
  if(min(distances)>maxdist) {
    closest <- NULL
  }
  best.matches <- all.packages[closest,]
  if(length(closest)>0 & auto.select) {
    matching.names <- which(username.pref %in% best.matches$username)
    if(length(matching.names)>=1) {
      best.matches <- subset(best.matches, username == username.pref[matching.names[1]])[1,]
    }
  }
  final.names <- paste(best.matches$username, best.matches$package_name, sep="/")
  return(final.names)
}
