#' Demographic Factor Frequencies Tables
#'
#' This function converts a column(s) from a \code{data.frame} into a
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
#' # Single demographic
#' dfactor(iris2, "Species")
#'
#' # Two demographics
#' dfactor(iris2, c("Color", "Species"))
dfactor <- function (data1, vars, neat = TRUE, sizesort = TRUE) {

  n           <- length(table(data1[, vars]))        # Obtain levels length
  Dataset     <- rep(deparse(substitute(data1)), n)  # Replicate object name n times
  Demographic <- rep(vars, n)                        # Replicate variable name(s)

  if(neat){
    dft <- data_frame_table(data1[, vars], prop = FALSE, perc = TRUE)
  } else{
    dft <- data_frame_table(data1[, vars], prop = TRUE, perc = TRUE)
  }

  if (length(vars) == 1) {
    names(dft)[1] <- "Group"
  } else {
    Demographic <- paste(vars, collapse = ".")
  }

  # Sort by Freq
  if (sizesort) {
    dft <- dft[order(dft[, "Freq"], decreasing = TRUE), ]
  }

  dft <- cbind(Dataset, Demographic, dft)
  rownames(dft) <- NULL

  return(dft)
}




