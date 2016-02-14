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
  vars <- c("group", "n")

  expr  <- named_vector_data_frame(match.call())
  args  <- named_vector_data_frame(formals())
  calls <- rbind(expr, args[which(!args[, "names"] %in% expr[, "names"]), ])

  if(as.logical(calls[calls["names"] == "prop", "values"])) {
    prop <- table_prop(t)
    dft  <- data.frame(dft, prop)
  }
  if(as.logical(calls[calls["names"] == "perc", "values"])) {
    perc <- table_perc(t)
    dft <- data.frame(dft, perc)
  }

  return(dft)
}

# Convert named vector or list to data.frame
named_vector_data_frame <- function(named.vector){
  names <- names(named.vector)
  values <- paste(named.vector)
  named.vector.df  <- data.frame(names, values)
  return(named.vector.df)
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
