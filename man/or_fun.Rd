% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/probability.R
\name{or_fun}
\alias{or_fun}
\title{P(A | B) = P(A) + P(B)}
\usage{
or_fun(dens.oblist)
}
\arguments{
\item{dens.oblist}{An object derived from the cRacle::dens_ob() function.}
}
\description{
Using an object from the cRacle::dens_obj() function. Create a single density object (i.e., like that produced by cRacle::densform()) where the probability curves correspond to the probability density function of any one taxon/species from the original set occurring. This is not actually used in the implementation of finding the maximum joint likelihood in a CRACLE analysis, but is a good companion to the cRacle::and_fun() function.
}
\examples{
\dontrun{
#distr <- read.table('test_mat.txt', head=T, sep ="\t");
#OR:
data(distr);
data(climondbioclim);
extr.raw = extraction(data=distr, clim= climondbioclim, schema='raw');
dens.list.raw <- dens_obj(extr.raw, clim = climondbioclim, bw = 'nrd0', n = 1024);
multiplot(dens.list.raw, names(climondbioclim[[1]]));
or <- or_fun(dens.list.raw);
addplot(or, names(climondbioclim[[1]]), col ='black');
}
}
