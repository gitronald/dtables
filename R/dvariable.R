#' Data.frame of Variables and Classes
#'
#' Helper function for \code{\link{dtable}}. Returns information about each
#' variable's class, mode, type, and number of response levels in a
#' \code{data.frame}, or \code{list} if \code{as.list = TRUE}.
#'
#' @param data1 a \code{data.frame}
#' @param vars specify one or more variable names with a character vector
#' @param as.list logical, \code{TRUE} returns a list split by class
#' @return Returns a data.frame or list with the variable names and their
#'   respective classes. Returns a data.frame by default.
#' @seealso \code{\link{class}} to examine method for extracting class.
#' @seealso \code{\link{mode}} to examine method for extracting mode.
#' @seealso \code{\link{typeof}} to examine method for extracting type.
#' @importFrom stats setNames
#'
#' @export
#' @examples
#' # Describe all variables in iris2
#' dvariable(iris2)
#'
#' # Describe one or more specific variables in iris2
#' dvariable(iris2, vars = "Species")
#'
#' # Return variable and class data in list
#' dvariable(iris2, as.list = TRUE)
dvariable <- function(data1, vars = NULL, as.list = FALSE){
  if (!("data.frame" %in% class(data1))) {
    warning("Input 'data1' should be a data.frame,
            attempting to coerce input to data.frame")
    data1 <- as.data.frame(data1)
  }
  if (is.null(vars)) {           # Default to all variables
    variable <- names(data1)
  } else {
    data1    <- setNames(data.frame(data1[, vars]), vars)    # Or use a selection
    variable <- names(data1)
  }

  class     <- dclass(data1)[, 2]
  mode      <- dmode(data1)[, 2]
  type      <- dtypeof(data1)[, 2]
  levels    <- factor_length(data1)[, 2]
  data2     <- data.frame(variable, class, mode, type, levels)

  treatas   <- predict_variable(data2)
  data3 <- cbind(data2, treatas)

  if (as.list) data3 <- split(data3, data3[["class"]])  # If, convert to list

  return(data3)
}


predict_variable <- function(data1) {
  treatas <- matrix(nrow = nrow(data1), ncol = 2)
  for(i in 1:nrow(data1)){
    treatas[i, 1] <- ifelse(data1[i, "levels"] < 15 & data1[i, "levels"] > 0, 1, 0)
    treatas[i, 2] <- ifelse(data1[i, "class"] %in% c("numeric", "integer"), 1, 0)
    if(sum(treatas[i, 1:2]) == 0) {
      message("Note: '", data1[i, "variable"], "' was not classified.")
    }
  }

  treatas <- setNames(as.data.frame(treatas),
                      c("frequencies", "statistics"))
  return(treatas)
}


dclass <- function(data1, as.list = FALSE){
  data2 <- lapply(data1, function(x) class(x))          # Collect data
  data2 <- list_collapse(data2)                         # Concatenate extra names
  data2 <- data.frame(unlist(data2))                    # Shape data
  data2 <- cbind(names(data1), data2)                   # Attach variable names
  data2 <- setNames(data2, c("variable", "class"))      # Set column names
  if (as.list) data2 <- split(data2, data2[["class"]])  # If, convert to list

  return(data2)
}

list_collapse <- function(data1, collapse = "."){
  data1 <- lapply(names(data1), function (x) paste(data1[[x]], collapse = collapse))

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


#' Return factor level lengths for all variables in a data.frame
#'
#' @param data1 a \code{data.frame}
#'
#' @return a \code{data.frame} with variable names and factor level lengths
#' @export
#'
#' @examples
#' factor_length(iris2)
factor_length <- function(data1) {
  variable <- names(data1)
  data1 <- lapply(variable, function(x) length(levels(as.factor((data1[, x])))))
  data1 <- data.frame(variable, (unlist(data1)))
  data1 <- setNames(data1, c("variable", "length"))     # Set column names

  return(data1)
}

pull_rownames <- function(data1){
  data1 <- data.frame(row.names(data1), data1)
  row.names(data1) <- NULL
  return(data1)
}
