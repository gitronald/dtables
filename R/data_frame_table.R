#' Create a data.frame table
#'
#' Create a data.frame table with an optional proportion column
#'
#' @param data1 a vector or data.frame column
#' @param prop logical, if \code{TRUE} returns an additional proportion column
#'
#' @return a data.frame table with an optional proportion column
#' @export
#'
#' @examples
#' data_frame_table(iris2$Species)
#' data_frame_table(iris2$Species, prop = FALSE)
data_frame_table <- function(data1, prop = TRUE){
  t    <- table(data1)
  prop <- table_prop(t)
  dft  <- data.frame(t, prop)
  names(dft) <- c("group", "n", "prop")
  return(dft)
}

# data_frame_table helper function - proportions
table_prop <- function(table){
  table.prop <- as.vector(table)/sum(table)
}
