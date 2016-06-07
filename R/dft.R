#' Create a data.frame table (dft)
#'
#' Create a table with a data.frame structure and optional proportion,
#' percentage, and descriptive statistics columns. Can be used by its shorthand
#' alias \code{dft}.
#'
#' @param data1 a vector or data.frame column
#' @param prop logical, if \code{TRUE} returns an additional proportion column
#' @param perc logical, if \code{TRUE} returns an additional percentage column
#' @param by numeric variable to return descriptive statistics for
#' @param neat logical, if \code{TRUE} returns a tailored dataset
#'
#' @return a data.frame table with optional proportion, percentage, and
#'   descriptive statistics columns
#' @import psych
#' @export
#'
#' @examples
#' dft(iris2$Species)
#' dft(iris2$Species, by = iris2$Sepal.Length)
#'
dft <- function(data1, prop = TRUE, perc = TRUE, by = NULL, neat = TRUE){
  t    <- table(data1)
  dft  <- data.frame(t)

  if(ncol(dft) == 2) {
    names(dft) <- c("group", "n")
  } else if(ncol(dft) > 2){
    names(dft)[length(dft)] <- "n"
  }

  if(prop) {
    prop <- table_prop(t)
    dft  <- data.frame(dft, prop)
  }
  if(perc) {
    perc <- table_perc(t)
    dft <- data.frame(dft, perc)
  }
  if(!is.null(by)) {
    descr <- describeBy(by, data1, mat = T)
    dft <- cbind(dft, descr[, 5:15])

    if(neat) {
      dft <- dft[, c("group", "n", "prop", "perc", "mean", "sd", "se")]
    }
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

