#' Demographic Factor Frequencies Tables
#'
#' This function converts a column(s) from a \code{data.frame} into a
#' frequencies table formatted in standard presentation structure with percent
#' symbols.
#'
#' @param data1 a \code{data.frame}
#' @param vnames a vector of one or more variable names in \code{data1}
#' @param neat logical, \code{TRUE} returns rounded factor table with percent
#'   symbols
#' @param sizesort logical, \code{TRUE} returns table sorted by size
#' @return Returns a demographic frequency table of varying specificity.
#' @export
#' @examples
#' # Single demographic
#' dfactor(iris2, "Species")
#'
#' # Two demographics
#' dfactor(iris2, c("Color", "Species"))
dfactor <- function (data1, vnames, neat = TRUE, sizesort = TRUE) {

  # First column - Name the demographic from object name
  Dataset <- rep(deparse(substitute(data1)), length(table(data1[, vnames])))
  Demographic <- vector(mode = "logical", length(table(data1[, vnames])))
  DemoName    <- paste0(vnames)
  Demographic <- rep(DemoName, length(table(data1[vnames])))

  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- table(data1[, vnames])
  dgroup <- data.frame(dgroup)

  # Fourth column - Percent value of frequency count
  dgroup <- transform(dgroup, Prop = prop.table(dgroup[, "Freq"]))

  # Make table neat by rounding and removing repetitive labels
  if (neat) {
    # Convert proportion to percent
    dgroup[, "Perc"] <- dgroup[, "Prop"]*100
    dgroup[, "Perc"] <- format(round(dgroup[, "Perc"], 1), nsmall = 1)
    dgroup[, "Prop"] <- NULL

    # Add percent symbol: "$" is end of string in regex
    dgroup[, "Perc"] <- gsub("$", "%", dgroup[, "Perc"])

    # If only one variable, remove repetitive demographic IDs (presentation format)
    if (length(vnames) == 1) {
      Dataset <- c(Dataset[1], rep("", (length(table(data1[, vnames])) - 1)))
      Demographic <- c(DemoName, rep("", (length(table(data1[, vnames])) - 1)))
    }
  }

  # Rename demographic group variable and demographic ID if more than 1 used
  if (length(vnames) == 1) {
    names(dgroup)[1] <- "Group"
  } else {
    Demographic <- paste(vnames, collapse = ".")
  }

  # Sort by Freq
  if (sizesort) {
    dgroup <- dgroup[order(dgroup[, "Freq"], decreasing = TRUE), ]
  }

  dgroup <- cbind(Dataset, Demographic, dgroup)
  rownames(dgroup) <- NULL

  return(dgroup)
}
