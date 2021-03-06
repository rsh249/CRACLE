% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grab.R
\name{gbif_get}
\alias{gbif_get}
\title{Download distribution data directly from GBIF API}
\usage{
gbif_get(taxon, maxrec = 2e+05)
}
\arguments{
\item{taxon}{A string of the form 'genus species' or 'genus'.}

\item{maxrec}{Maximum number of records to download.
Under 300 really doesn't mean anything because a single page (300)
of results is returned and all records are kept.}
}
\description{
This function requests data from the GBIF database for a single taxon using the GBIF callback API.
}
\examples{
\dontrun{
abies <- gbif_get('Abies');
}
}
