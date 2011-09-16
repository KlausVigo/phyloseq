####################################################################################
#' phyloseq package extension for \code{vegan::rda}.
#'
#' A formula is main input to \code{vegan::cca}. This complicates dispatch based
#' on object signature. A new method with a separate name is defined instead.
#' 
#' @param X formula-class object specifying the input. No need to splat higher-order
#'  objects. \code{rda.phyloseq} understands where to find the abundance table
#'  and sample characteristics. The left-hand side should specify a single 
#'  phyloseq object that contains (at minimum) an \code{otuTable} and a 
#'  \code{sampleMap}. The right-hand side expects at least two different
#'  variates, present in the \code{sampleMap} of the LHS. For available
#'  variate names in your object, try \code{colnames(sampleMap(ex1))}, where
#'  \code{ex1} is the phyloseq object containing your data. Because this is
#'  a formula object, quotes should not be used. See \code{\link{formula}}
#'  for details about writing a formula in R.
#'
#' @param data \code{data.frame} containing information equivalent to
#'  a \code{sampleMap} object / component. Only necessary if complex object
#'  does not already contain \code{sampleMap} or you are keeping the data 
#'  separate for some reason.
#'
#' @return same output as \code{vegan::\link{rda}}
#'
#' @rdname rda.phyloseq-methods
#' @docType methods
#'
#' @seealso \code{\link{cca.phyloseq}}
#' @export
#' @import vegan
#' @examples #
#' ## data(ex1)
#' ## rda.phyloseq(ex1 ~ Diet + Gender)
setGeneric("rda.phyloseq", function(X, ...) standardGeneric("rda.phyloseq"))
#' @aliases rda.phyloseq,formula-method
#' @rdname rda.phyloseq-methods
setMethod("rda.phyloseq", "formula", function(X, data=NULL){
	#require(vegan)
	phylobject <- get( as.character(X)[2] )
	OTU        <- otuTable( phylobject )
	if( speciesAreRows(OTU) ){
		OTU <- t(OTU)@.Data
	} else {
		OTU <- OTU@.Data
	}
	# Create the new formula
	newFormula = as.formula(paste("OTU", as.character(X)[3], sep=" ~ "))
	# If an alternative table is not provided, assume it is from the sampleMap slot
	if( is.null(data) ){
		data <- data.frame(sampleMap(phylobject))
	}
	vegan::rda(newFormula, data=data)	
})
####################################################################################