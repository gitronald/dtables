#' Create a list of named lists
#'
#' Use \code{create_list} to create a list of named lists, each of length \code{list.lengths}.
#'
#' @param list.names a string vector containing list names
#' @param list.lengths a numeric value that determines the length of each \code{list.names} list
#'
#' @return
#'    Returns a list of named lists, each of length \code{list.lengths}.
#' @export
#'
#' @examples
#' # Generate lists, each of length 4
#' create_list(c("a", "b", "c"), 4)
create_list <- function(list.names, list.lengths) {
  new.list <- sapply(list.names, function(x) lapply(x, function(x) vector("list", length = list.lengths)))
  return(new.list)
}
