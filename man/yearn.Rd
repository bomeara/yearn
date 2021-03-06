% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/yearn.R
\name{yearn}
\alias{yearn}
\title{Do yearn on a single package}
\usage{
yearn(pkg, maxdist = 0, username.pref = c("cran", "ropensci", "rstudio",
  "tidyverse", "hadley", "yihui", "RcppCore", "eddelbuettel", "ropenscilabs",
  "hrbrmstr", "thej022214", "bomeara"))
}
\arguments{
\item{pkg}{The package name (bare text, NOT in quotes)}

\item{maxdist}{The maximum distance that counts as a match}

\item{username.pref}{In case of matches, user names in order of preference.}
}
\value{
NULL if success, a string describing the problem otherwise
}
\description{
Do yearn on a single package
}
\details{
See the readme file. Basically, this tries to load an installed package. If that fails, it then looks (in order) on Bioconductor, CRAN, GitHub's CRAN mirror, and other GitHub repositories for the package and installs it if it can find it.
}
\examples{
\dontrun{
yearn(laser) # A package that was on CRAN but has been removed.
}

}
