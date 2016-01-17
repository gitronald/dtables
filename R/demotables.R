#' Data.frame of Variables and Classes
#'
#' Helper function for \code{\link{dtable}}. Returns information about variable
#' class in a \code{data.frame}, or \code{list} if \code{as.list = TRUE}.
#'
#' @param data1 a \code{data.frame}
#' @return Returns a data.frame or list with the variable names and their
#'   respective classes. Returns a data.frame by default.
#' @seealso \code{\link{class}} to examine method for extracting class.
#' @export
#' @examples
#' # Load sample data
#' dclass(iris2)
#'
#' # Return variable and class data in data.frame
#' dclass(iris2)
#'
#' # Return variable and class data in list
#' dclass(iris2, as.list = TRUE)
dclass <- function(data1, as.list = FALSE){
  data1 <- lapply(data1, class)                          # Collect data
  data1 <- data.frame((unlist(data1)))                   # Shape data
  data1 <- pull_rownames(data1)                          # Pull in row names
  data1 <- setNames(data1, c("variable", "class"))       # Set column names
  if (as.list) data1 <- split(data1, data1[["class"]])   # If, convert to list

  return(data1)
}

dmode <- function(data1, as.list = FALSE){
  data1 <- lapply(data1, mode)                           # Collect data
  data1 <- data.frame((unlist(data1)))                   # Shape data
  data1 <- pull_rownames(data1)                          # Pull in row names
  data1 <- setNames(data1, c("variable", "mode"))        # Set column names
  if (as.list) data1 <- split(data1, data1[["mode"]])    # If, convert to list

  return(data1)
}

dtypeof <- function(data1, as.list = FALSE){
  data1 <- lapply(data1, typeof)                        # Collect data
  data1 <- data.frame((unlist(data1)))                  # Shape data
  data1 <- pull_rownames(data1)                         # Pull in row names
  data1 <- setNames(data1, c("variable", "typeof"))     # Set column names
  if (as.list) data1 <- split(data1, data1[["typeof"]]) # If, convert to list

  return(data1)
}

dvariable <- function(data1){
  if (!("data.frame" %in% class(data1))) {
    stop("Input 'data1' must be of class data.frame")
  }
  variable <- names(data1)
  class    <- dclass(data1)[, 2]
  mode     <- dmode(data1)[, 2]
  type     <- dtypeof(data1)[, 2]
  data2 <- data.frame(variable, class, mode, type)

  return(data2)
}

pull_rownames <- function(data1){
  data1 <- data.frame(row.names(data1), data1)
  row.names(data1) <- NULL
  return(data1)
}


#' Generate demographic frequencies and descriptive statistics tables
#'
#' Generate demographic frequencies tables and descriptive statistics tables in
#' data.frame format for R.
#'
#' @param data a \code{data.frame}
#' @param vnames all, or a subset \code{vector} of variable names from
#'   \code{data.frame}
#' @param neat logical, defaults to \code{TRUE} and returns rounded factor table
#'   with percent symbols
#' @param sizesort logical, returns data sorted by frequency and mean if
#'   \code{TRUE}
#' @return List of two \code{data.frames}, split into \code{factor} and
#'   \code{numeric} variables if \code{vnames} contains both classes, single
#'   \code{data.frame} returned if only one variable class detected in
#'   \code{vnames} by \code{dclass}.
#' @seealso \code{\link{dclass}} to see how class is identified.
#' @importFrom psych describe
#' @export
#' @examples
#' # Load sample data
#' data(iris2)
#'
#' # Examine all variables
#' dtable(iris2, names(iris2))
#'
#' # Examine single variable
#' dtable(iris2, "Species")
#'
#' # Round all output and add percent symbols to factor output
#' dtable(iris2, names(iris2), neat = TRUE)
#'
#' # Raw output
#' dtable(iris2, names(iris2), neat = FALSE)
#'
dtable <- function (data, vnames = NULL, neat = TRUE, sizesort = TRUE){

  if (is.null(vnames)) vnames <- names(data1)  # Default selection to all variables

  class.data  <- dclass(data, as.list = TRUE)
  dtable <- list()

  if(length(type[["factor"]]) > 0) {
    dtable[["factor"]] <- do.call(rbind.data.frame, lapply(class.data$factor$variable, dfactor,
                                                           data = data, neat = neat,
                                                           sizesort = sizesort))
    if(neat) {
      dataset <- c(deparse(substitute(data)), rep("", nrow(dtable[["factor"]]) - 1))
    } else {
      dataset <- rep(deparse(substitute(data)), nrow(dtable[["factor"]]))
    }
    dtable[["factor"]] <- cbind(dataset, dtable[["factor"]])
    row.names(dtable[["factor"]]) <- NULL
  }

  if(length(class.data$n) > 0) {
    class.data$numeric$variable
    dtable[["numeric"]] <- do.call(rbind.data.frame, lapply(class.data$numeric$variable,dnumeric,
                                                            data = data, neat = neat,
                                                            sizesort = sizesort))
    dtable[["numeric"]] <- dtable[["numeric"]][, -1]
    if(neat) {
      dataset <- c(deparse(substitute(data)), rep("", nrow(dtable[["numeric"]]) - 1))
    } else {
      dataset <- rep(deparse(substitute(data)), nrow(dtable[["numeric"]]))
    }
    dtable[["numeric"]] <- cbind(dataset, dtable[["numeric"]])
    row.names(dtable[["numeric"]]) <- NULL
  }

  return(dtable)
}

#' Demographic Factor Frequencies Tables
#'
#' This function converts a column(s) from a \code{data.frame} into a
#' frequencies table formatted in standard presentation structure with percent
#' symbols.
#'
#' @param data a \code{data.frame}
#' @param vnames a vector of variable names from \code{data.frame} to use in
#'   creation of demographic frequency table, multiple variables produces more
#'   specific groups.
#' @param neat logical, \code{TRUE} returns rounded factor table with percent
#'   symbols
#' @param sizesort logical, \code{TRUE} returns table sorted by size
#' @return Returns a demographic frequency table of varying specificity.
#' @seealso \link{\code{table}} which this function utilizes.
#' @export
#' @examples
#' # Load sample data
#' data(iris2)
#'
#' # Single demographic
#' dfactor(iris2, "Species")
#'
#' # Two demographics
#' dfactor(iris2, c("Color", "Species"))
dfactor <- function (data, vnames, neat = TRUE, sizesort = TRUE) {

  # First column - Name the demographic from object name
  Demographic <- vector()
  DemoName    <- paste0(vnames)
  Demographic <- rep(DemoName, (length(table(data[vnames]))))

  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- table(data[, vnames])
  dgroup <- data.frame(dgroup)

  # Fourth column - Percent value of frequency count
  dgroup <- transform(dgroup, Prop = prop.table(Freq))

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
      Demographic <- c(DemoName, rep("", (length(table(data[vnames])) - 1)))
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

  dgroup <- cbind(Demographic, dgroup)
  rownames(dgroup) <- NULL

  return(dgroup)
}

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
  descript <- describe(data[, vnames])
  results  <- cbind(dataset, variable, descript)

  if (neat) {
    results <- cbind(results[, 1:4], round(results[, 5:length(results)], digits = 1))
  }

  if (sizesort) {
    results <- results[order(results[, "mean"], decreasing = TRUE), ]
  }

  return(results)
}
