#' Create standard descriptive statistics
#'
#' Wrapper for \code{psych::describe} that adds the name of the dataset and the
#' variable being examined to its output. Use in \code{dtable} for multiple
#' variables.
#'
#' @param data a \code{data.frame}
#' @param vnames a single variable name to examine with \code{psych::describe}
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
#' dnumeric(iris2, "Sepal.Length")
#'
#' # Use \link{\code{dtable}} for multiple variables
dnumeric <- function(data, vnames, neat = TRUE, sizesort = FALSE) {
  dataset  <- deparse(substitute(data))
  variable <- paste0(vnames)
  descript <- describe(as.numeric(data[, vnames]))
  results  <- cbind(dataset, variable, descript)

  if (neat) {
    results <- cbind(results[, 1:4], round(results[, 5:length(results)], digits = 1))
  }

  if (sizesort) {
    results <- results[order(results[, "mean"], decreasing = TRUE), ]
  }

  return(results)
}
