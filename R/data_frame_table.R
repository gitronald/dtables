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
data_frame_table <- function(data1, prop = TRUE, perc = TRUE){
  t    <- table(data1)
  dft  <- data.frame(t)

  if(ncol(dft) == 2) {
    names(dft) <- c("group", "n")
  } else if(ncol(dft) > 2){
    names(dft)[3] <- "n"
  }

  if(prop) {
    prop <- table_prop(t)
    dft  <- data.frame(dft, prop)
  }
  if(perc) {
    perc <- table_perc(t)
    dft <- data.frame(dft, perc)
  }

  return(dft)
}

# data_frame_table helper function - proportions
# test - print(table_prop(table(iris2$Species)))
table_prop <- function(table){
  table.prop <- as.vector(table)/sum(table)
}

# data_frame_table helper function - percentages
# test - print(table_perc(table(iris2$Species)))
table_perc <- function(table){
  table.prop <- table_prop(table)
  table.perc <- format(round(table.prop*100, 1), nsmall = 1)
  table.perc <- gsub("$", "%", table.perc)
}
