% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grab.R
\name{getextr}
\alias{getextr}
\title{Download distribution data, filter, and merge with climate or environmental}
\usage{
getextr(
  x,
  clim = clim,
  maxrec = 500,
  schema = "flat",
  repo = c("gbif"),
  rm.outlier = FALSE,
  alpha = 0.01,
  factor = 4,
  nmin = 5,
  parallel = FALSE,
  nclus = 4
)
}
\arguments{
\item{x}{A taxon name or list of taxon names. It is sometimes good to
test these on the cRacle::get_gbif() function first.}

\item{clim}{A raster object of climate or other environmental data to extract from.}

\item{maxrec}{Maximum number of records to download.}

\item{schema}{To be passed to cRacle::extraction}

\item{repo}{Pass to get_dist_all}

\item{rm.outlier}{To be passed to cRacle::extraction}

\item{alpha}{To be passed to cRacle::extraction}

\item{factor}{To be passed to cRacle::extraction}

\item{nmin}{To be passed to cRacle::extraction}

\item{parallel}{TRUE or FALSE. Should this be executed in parallel.}

\item{nclus}{If parallel == TRUE then how many cores should be used? Default is 4.}
}
\description{
getextr is a function that gets GBIF data and extracts climate or environmental
data for each occurrence. This is a whole workflow for distribution
data acquisition and value addition that draws on several other functions in cRacle
including gbif_get and extraction. Parallel option is useful for speeding up data collection for
many species when computational resources are available.
}
\examples{
\dontrun{
abies <- getextr(c('Abies fraseri', 'Abies lasiocarpa', 'Pinus strobus'),
clim = clim, maxrec=500,
schema= 'flat', rm.outlier = TRUE,
alpha=0.01, factor = 2, nmin = 5, parallel=FALSE, nclus = 4);
}

}
