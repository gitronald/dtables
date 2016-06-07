#' Demographic Factor Frequencies Tables
#'
#' This function converts columns from a \code{data.frame} into a
#' frequencies table formatted in standard presentation structure with percent
#' symbols.
#'
#' @param data1 a \code{data.frame}
#' @param vars a vector of one or more variable names in \code{data1}
#' @param neat logical, \code{TRUE} returns a rounded table with percent symbols
#' @param sizesort logical, \code{TRUE} returns table sorted by size
#' @return Returns a demographic frequencies table in \code{data.frame} format.
#' @export
#' @examples
#' # Single frequency table
#' dfactor(iris2, "Species")
#'
#' # Multiple frequency tables
#' dfactor(iris2, c("Color", "Species"))
dfactor <- function (data1, vars, neat = TRUE, sizesort = TRUE) {

  n           <- length(table(data1[, vars])) # Obtain levels length
  dataname    <- deparse(substitute(data1))   # Obtain data object name
  dataset     <- neatify(dataname, n, neat)   # Replicate object name n times or neatly
  demographic <- neatify(vars, n, neat)       # Replicate demographic name n times or neatly

  if(neat){
    dft <- dft(data1[, vars], prop = FALSE, perc = TRUE)
  } else {
    dft <- dft(data1[, vars], prop = TRUE, perc = TRUE)
  }

  # Sort by Freq
  if (sizesort) {
    dft <- dft[order(dft[, "n"], decreasing = TRUE), ]
  }

  dft <- cbind(dataset, demographic, dft)
  rownames(dft) <- NULL

  return(dft)
}

neatify <- function(vars, n, neat = TRUE){
  if(length(vars) > 1) {
    vars <- paste(vars, collapse = ".")
  }
  if(neat) {
    new <- c(vars, rep("", (n - 1)))
  } else {
    new <- rep(vars, n)
  }

  return(new)
}

