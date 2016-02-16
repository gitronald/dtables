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

  # First column - Name the demographic from object name
  n           <- length(table(data1[, vars]))
  Dataset     <- rep(deparse(substitute(data1)), n)
  Demographic <- vector(length = n)
  name        <- paste0(vars)
  Demographic <- rep(name, n)

  dgroup <- data_frame_table(data1[, vars])

  # Rename demographic group variable and demographic ID if more than 1 used
  if (length(vars) == 1) {
    names(dgroup)[1] <- "Group"
  } else {
    Demographic <- paste(vars, collapse = ".")
  }

  # Sort by Freq
  if (sizesort) {
    dgroup <- dgroup[order(dgroup[, "Freq"], decreasing = TRUE), ]
  }

  dgroup <- cbind(Dataset, Demographic, dgroup)
  rownames(dgroup) <- NULL

  return(dgroup)
}




