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
