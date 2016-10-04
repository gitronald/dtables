#' Create standard descriptive statistics
#'
#' Wrapper for \code{psych::describe} that adds the name of the dataset and the
#' variable being examined to its output. Used in \code{dtable} for multiple
#' variables.
#'
#' @param data a \code{data.frame} column or columns, or a \code{list}
#' @param neat logical, returns rounded values if \code{TRUE}
#' @param sizesort logical, returns sorted data by mean if \code{TRUE}
#' @seealso See \code{\link{dtable}}
#' @seealso See \code{\link[psych]{describe}} for more details on the
#'   descriptive statistics returned
#' @return Returns a \code{data.frame} with common descriptive statistics for a
#'   numeric variable, as defined in \code{psych::describe}, concatenated with
#'   the name of the dataset and the name of the variable.
#' @importFrom psych describe
#' @export
#' @examples
#' # Single variable
#' dnum(iris2$Sepal.Length)
#'
#' # Multiple variables
#' dnum(iris2[, c("Sepal.Length", "Sepal.Width")])
#'
#' # Use \link{\code{dtable}} for multiple variables
dnum <- function(data1, neat = TRUE, sizesort = FALSE) {
  data  <- deparse(substitute(data1))
  data2 <- describe(data1)

  if(grepl("\\$", data)){
    data = strsplit(data, "\\$")[[1]]
    var = data[2]
    data = data[1]
    data2 = cbind(data, var, data2)
  } else {
    data2 = cbind("var" = row.names(data2), data2)
    data = strsplit(data, "\\[")[[1]][1]
    data2 <- cbind(data, data2)
  }

  row.names(data2) = NULL
  data2[["vars"]] = NULL

  if (neat) {
    data2 <- cbind(data2[, 1:4], round(data2[, 5:length(data2)], digits = 1))
  }

  if (sizesort) {
    data2 <- data2[order(data2[, "mean"], decreasing = TRUE), ]
  }

  return(data2)
}
