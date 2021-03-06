#' A wrapper for cRacle::densform where a multi-taxon extraction object can be passed to densform one taxon at a time.
#'
#' This function takes extracted climate data (from an object generated by the cRacle::extraction() function) and generates probability density functions for each taxon/variable pair using both a Gaussian (normal) approximation and a Gaussian Kernel Density estimator.
#' @param ex An object derived from the extraction() function.
#' @param clim A raster object (see raster::raster() and raster::stack() documentation for reading raster files into R).
#' @param bw A bandwidth compatible with stats::density(). Options include "nrd", "nrd0", "ucv", "bcv", etc.. Default (and recommended) value is "nrd0".
#' @param kern Type of Kernel to smooth with. Recommend 'gaussian', 'optcosine', or 'epanechnikov'. See: stats::density for options.
#' @param n Number of equally spaced points at which the probability density is to be estimated. Defaults to 1024. A lower number increases speed but decreases resolution in the function. A higher number increases resolution at the cost of speed. Recommended values: 512, 1024, 2048, ....
#' @param clip A character string of value "range" or "95conf" or "99conf". Should the probability functions be clipped to either the empirical range or the 95 or 99 percent confidence interval?
#' @param manip Character string of 'reg' for straight likelihood, 'condi' for conditional likelihood statement.
#' @param parallel TRUE or FALSE. Make use of multicore architecture.
#' @param nclus Number of cores to allocate to this function
#' @param bg.n If there is not a background matrix, how many background points PER OCCURRENCE record should be sampled. Default is 1000.
#' @export
#' @examples
#' #distr <- read.table('test_mat.txt', head=T, sep ="\t");
#' #OR:
#' data(distr);
#' data(climondbioclim);
#' extr.raw = extraction(data=distr, clim= climondbioclim,
#'  schema='flat', factor = 4, rm.outlier=FALSE);
#' dens.list.raw <- dens_obj(extr.raw, clim = climondbioclim,
#'  manip = 'condi', bg.n = 200, bw = 'nrd0', n = 1024);
#' multiplot(dens.list.raw, names(climondbioclim[[1]]));


dens_obj <- function(ex, clim, manip = 'condi', bw = "nrd0", kern='optcosine',
                     clip = 0, n = 1024, parallel = FALSE,
                     nclus = 4, bg.n = 200) {
  rawbioclim = clim;
  ex <- data.frame(ex);
  condi = FALSE;
  bayes = FALSE;
  head = which(colnames(ex) == 'cells');
  from = raster::minValue(clim);
  to = raster::maxValue(clim);
  ####



  if(manip == 'condi') {
    condi = TRUE; #print("Conditional Likelihood")
  }
  dens.list <- list();
  nlist <- vector();
  site.ex <- "NOSITE";

  site.coord = 0;
  if(ex[1,2] == "SITECOORD"){
    site.coord <- ex[1,];
    ex <- subset(ex, ex$tax != "SITECOORD");
    site.ex <- ex[1,];

  };
  tax.list <- unique(ex$tax);
  tax.list <- stats::na.omit(tax.list);
  if(parallel == TRUE){

    cl <- parallel::makeCluster(nclus, type = "SOCK")
    doSNOW::registerDoSNOW(cl);

    dens.list <-
      foreach::foreach(i = 1:length(tax.list),

                       .packages = 'cRacle') %dopar% {
                         #   source('~/Desktop/cracle_testing/cRacle/R/search_fun.R')
                         #   source('~/Desktop/cracle_testing/cRacle/R/cracle_build.R')
                         s.ex <- subset(ex, ex$tax == tax.list[[i]]);

                         s.ex <- stats::na.omit(s.ex);

                         dlist <- (densform(s.ex, rawbioclim, name = tax.list[[i]],
                                            manip = manip, bw = bw, kern=kern,
                                            n=n, from = from, to = to,
                                            clip = clip, bg.n = bg.n));

                         len <- length(dlist);
                         if(len <= 1) {
                           dlist <- NULL;
                         };
                         return(dlist);


                       }
    parallel::stopCluster(cl)

  } else {


    for(i in 1:length(tax.list)){
      # print(i);
      s.ex <- subset(ex, ex$tax == tax.list[[i]]);

      s.ex <- stats::na.omit(s.ex);

      nlist[[i]] <- length(s.ex[,1])

      dens.list[[i]] <- (densform(s.ex, rawbioclim, name = tax.list[[i]],
                                  manip = manip, bw = bw, kern = kern,
                                  n=n, from = from, to = to,
                                  clip = clip, bg.n = bg.n));

      len <- length(dens.list[[i]]);
      if(len <= 1) {
        dens.list[[i]] <- NULL;
      };
    };
  };
  return(dens.list);
}
