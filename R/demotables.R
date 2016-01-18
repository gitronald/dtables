#'Generate demographic frequencies and descriptive statistics tables
#'
#'Simplifies the process and reduces the amount of code involved in generating
#'descriptive frequencies and statistics tables with or without formatting.
#'
#'@param data a \code{data.frame}
#'@param vnames all, or a subset \code{vector} of variable names from
#'  \code{data.frame}
#'@param neat logical, defaults to \code{TRUE} and returns rounded factor table
#'  with percent symbols
#'@param sizesort logical, returns data sorted by frequency and mean if
#'  \code{TRUE}
#'@return List of two \code{data.frames}, split into \code{factor} and
#'  \code{numeric} variables if \code{vnames} contains both classes, single
#'  \code{data.frame} returned if only one variable class detected in
#'  \code{vnames} by \code{dclass}.
#'@seealso \code{\link{dclass}} to see how class is identified.
#'@importFrom psych describe
#'@export
#' @examples
#' # Examine all variables
#' dtable(iris2)
#'
#' # Examine single variable - Out of service
#' dtable(iris2, "Species")
#'
#' # Examine two or more variables  - Out of service
#' dtable(iris2, c("Attractiveness", "Species"))
#'
#' # Raw output
#' dtable(iris2, neat = FALSE)
#'
dtable <- function (data1,
                    variables = NULL,
                    frequencies = NULL,
                    descriptives = NULL,
                    neat = TRUE, as.list = FALSE, sizesort = TRUE){

  var.details  <- dvariable(data1, variables)  # Extract variable details

  if (is.null(descriptives)) { # Default selection to all variables
    descriptives <- c("numeric", "integer")
  }

  if (is.null(frequencies)) { # Default selection to all variables
    frequencies <- c("character", "factor", "integer", "logical")
  }

  frequencies <- unlist(lapply(frequencies, function(x) extract(var.details, "class", x, "variable")))
  descriptives <- unlist(lapply(descriptives, function(x) extract(var.details, "class", x, "variable")))

  dtable <- create_list(c("Freq", "Desc"), 1)

  for (i in frequencies){
    dtable$Freq <- lapply(frequencies, dfactor,
                          data = data1, neat = neat,
                          sizesort = sizesort)
  }

  for (i in descriptives){
    dtable$Desc <- lapply(descriptives, dnumeric,
                          data = data1, neat = neat,
                          sizesort = sizesort)
  }

  if(!as.list){
    dtable$Freq <- do.call(rbind, dtable$Freq)
    dtable$Desc <- do.call(rbind, dtable$Desc)
  }

  return(dtable)
}


extract <- function(data1, selectCol = NULL, selectRows = NULL, column = NULL){
  if (sum(sapply(c(selectCol, selectRows, column), length)) > 0) {
    data1 <- paste(data1[data1[selectCol] == selectRows, paste(column)])
  }

  return(data1)
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
