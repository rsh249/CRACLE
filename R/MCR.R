#Code to add ECV alternative methods
#Thompson’s Mutual Climatic Range (MCRun = CA and S/A MCR; MCRw = weighted MCR)
#MCRun = Sinka/Atkinson MCR + Coexistence Approach
#	-Overlapping intervals of BC envelope model.

#' A function to estimate climate using the Mutual Climatic Range method according to Thompson et al 2012.
#' 
#' The Mutual Climatic Range method (see especially: Thompson et al 2012) and the Coexistence Approach are fundamentally similar methods implemented in this function to find the minimum interval of coexistence of a list of taxa. This function implements the MCR in both the weighted and unweighted form using a data.frame of climate data attached to species locality information. 
#' @param ext An object generated by the extraction() function in this package or equivalent data.frame containing species IDs and climate data. 
#' @param method A character string of value "weight" or "unweight" only. Defaults to "unweight" as this is the classic model.
#' @param plot Boolean (T or F) to indicate whether coexistence interval plots should be generated for each variable.
#' @param file If plot=T then provide a file name stub (prefix) to identify the plots to be generated. To this stub each variable name and the file extension will be appended.
#' @export
#' @examples \dontrun{
#' data(distr);
#' data(climondbioclim);
#' extr.raw = extraction(data=distr, clim= climondbioclim, schema='raw');
#' mcr = MCR(extr.raw, method = 'unweight', plot=FALSE);
#' mcrw = MCR(extr.raw, method = 'weight', plot=TRUE, file = 'mcr_plot');
#' }

MCR <- function(ext, method="unweight", plot = FALSE, file = 'mcr_plot'){
	head = which(colnames(ext) %in% 'cells');
	nvars = ncol(ext) - (head);
	tax <- unique(ext$tax); #Exclude "SITECOORD" if necessary here
	ntax <- length(tax);
		varseq <- list();
		countmatrix <- list(); 

		for (k in 1:nvars){
			j = k+head;
			varseq[[k]] <- sort(unique(ext[,j]), decreasing=F)
			countmatrix[[k]] = matrix(nrow=as.numeric(ntax), ncol=length(varseq[[k]]));
		}
		optimatr <- list();
		optim <- matrix(nrow=2, ncol = nvars);
		for(i in 1:ntax){
			sub <- 0;
			sub <- ext[which(ext$tax == tax[i]),]; 
			for(x in 1:nvars){
				nseq = length(varseq[[x]]); #print(nseq);
				
			  lsub.x= length(sub[,x])
			  
				for(z in 1:nseq){	
					prop = sum(sub[,x+(head)]<=varseq[[x]][z])/lsub.x; #should give proportion of this sp. with values less than that (~percentile estimation)
					val = 0;
					if(method == 'unweight'){
						if(prop == 0){val = 0} # less than the species minimum
						if(prop > 0 & prop < 1){val = 1} # greater than species minimum but less than the maximum
						if(prop == 1) {val=0} # greater than the species max
						
					}
					if(method== 'weight'){
						if(prop==0){val = 0}
						if(prop<=0.01 & prop > 0){val = 1}
						if(prop<=0.05 & prop > 0.01){val = 2}
						if(prop<=0.10 & prop > 0.05){val = 3}
						if(prop<=0.90 & prop > 0.10){val = 4}
						if(prop<=0.95 & prop > 0.90){val = 3}
						if(prop<=0.99 & prop > 0.95){val = 2}
						if(prop<1 & prop > 0.99){val=1}
						if(prop==1){val=0}
					}
					#print(val);print(prop);print(z);
					countmatrix[[x]][i,z] = val;
					
					
					##PLOTTING OF SPECIES CURVES POSSIBLE HERE	
					if(i == ntax & z == nseq){
						y = apply(countmatrix[[x]], 2, sum);  
						z = varseq[[x]]; #return(cbind(x, y));
						c <- cbind(z,y);
						#optimatr[[x]] = c;
						##Get optimal range here:
						#return(c);
						if(max(c[,2]) < ntax){
						  optim[,x] = rbind('NA', 'NA');
						  print(paste("INCONGRUENCE in variable:", x, " of ", nvars, ". NO MUTUAL RANGE...", sep = ''))
						} else {
  						range = subset(c, c[,2] == max(c[,2]));
						
						  optim[,x] = rbind(min(range[,1]), max(range[,1]));
						}
						if(plot==TRUE){
							grDevices::png(paste(file, colnames(ext)[head+x], '.png', sep=''), height = 4, width = 4, res = 400, unit='in');
							graphics::par(mai=c(0.8, 0.8, 0.2, 0.2))
							graphics::plot(c, type = 'l');
							grDevices::dev.off()
						
						}
					}			
				}
			}
				
			
		}
	#return(optimatr)
	colnames(optim) <- colnames(ext[,(head+1):ncol(ext)])
	optim <- data.frame(optim)
	optim = list(optim);
	names(optim) = c(method)
	return(optim);
}
