# TODO:
#  - Add sizesort argument to dtable
#  - Move examples into roxygen comments

#' detectClass
#'
#' Helper function for \code{\link{dtable}}. Obtains column classes and splits
#' variable names into a list of two vectors based on numeric/integer or factor
#' class.
#'
#' @param data data.frame
#' @param vnames a vector of variable names from data.frame to classify
#'
#' @return Returns a list with a vector containing factor variable names, and a
#'   vector containing numeric variable names.
#' @seealso \code{\link{class}} to examine method for extracting class type.
#' @export
#' @examples
#' # All variables
#' detectClass(iris2, names(iris2))
#'
#' # Single variable
#' detectClass(iris2, "Species")
detectClass <- function(data, vnames){
  detect <- cbind(vnames = vnames, dclass = NA)
  for (i in 1:length(vnames)){
    detect[, "dclass"][i] <- class(data[, vnames[i]])
  }

  detected <- list()
  detected[["factor"]] <- detect[detect[, "dclass"] == "factor", "vnames"]
  detected[["numeric"]] <- detect[detect[, "dclass"] %in% c("numeric", "integer"), "vnames"]

  return(detected)
}

#'dtable
#'
#'Demographic frequency tables and descriptive statistics tables for R.
#'
#' @param data data.frame
#' @param vnames a vector of variable names from \code{data.frame} to use in creation of
#'   demographic tables
#' @param neat logical, \code{TRUE} returns rounded factor table with percent
#'   symbols
#' @return List of two \code{data.frame}s, split into factor and numeric variables if
#'   \code{vnames} contains both classes, single \code{data.frame} returned if only one
#'   variable class detected in \code{vnames}.
#' @importFrom psych describe
#' @export
#' @examples
#' # Examine all variables
#' dtable(iris2, names(iris2))
#'
#' # Examine single variable
#' dtable(iris2, "Species")
#'
#' # Round all output and add percent symbols to factor output
#' dtable(iris2, names(iris2), neat = TRUE)
dtable <- function (data, vnames, neat = TRUE){

  detected <- detectClass(data, vnames)
  dtable <- list()

  if(length(detected$f) > 0) {
    dtable[["factor"]] <- do.call(rbind.data.frame, lapply(detected$f, dfactor, data = data, neat = neat))
    if(neat) {
      dataset <- c(deparse(substitute(data)), rep("", nrow(dtable[["factor"]]) - 1))
    } else {
      dataset <- rep(deparse(substitute(data)), nrow(dtable[["factor"]]))
    }
    dtable[["factor"]] <- cbind(dataset, dtable[["factor"]])
    row.names(dtable[["factor"]]) <- NULL
  }

  if(length(detected$n) > 0) {
    dtable[["numeric"]] <- do.call(rbind.data.frame, lapply(detected$n, dnumeric, data = data, neat = neat))
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

#' dfactor
#'
#' This function converts a column(s) from a \code{data.frame} into a frequencies table
#' formatted in standard presentation structure with percent symbols.
#'
#' @param data a \code{data.frame}
#' @param vnames a vector of variable names from \code{data.frame} to use in
#'   creation of demographics table, multiple variables produces more specific
#'   groups.
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

#' dnumeric
#'
#' Wrapper for \code{psych::describe} that adds the name of the dataset and the
#' variable being examined to its output. Use in \code{dtable} for multiple
#' variables.
#'
#' @param data a \code{data.frame}
#' @param vnames a single variable name to examine with \code{psych::describe}
#' @param neat logical, returns rounded values if \code{TRUE}
#' @seealso See \code{\link{dtable}}
#' @seealso See \code{\link[psych]{describe}} for details on the descriptives
#'   returned
#' @return Returns a \code{data.frame} with common descriptive statistics for a
#'   numeric variable, as defined in \code{psych::describe}, concatenated with
#'   the name of the dataset and the name of the variable.
#' @importFrom psych describe
#' @export
#' @examples
#' # Single variable
#' dnumeric(iris2, "Sepal.Length")
#'
#' # Use dtable for multiple variables
dnumeric <- function(data, vnames, neat = FALSE) {
  dataset  <- deparse(substitute(data))
  variable <- paste0(vnames)
  descript <- describe(data[, vnames])
  results  <- cbind(dataset, variable, descript)

  if (neat) {
    results <- cbind(results[, 1:4], round(results[, 5:length(results)], digits = 1))
  }

  return(results)
}
