#' Correlation tests
#'
#' A wrapper for `cor.test()`, that returns data in a data.frame rather than a
#' cumbersome list
#'
#' @param var1 a vector to correlate with var2
#' @param var2 a vector to correlate with var1
#' @param method the correlation method to use, either pearson, spearman, or
#'   kendall
#' @param round logical, whether or not to round the results
#'
#' @return Returns a data.frame version of the standard htest output
#' @export
#'
#' @examples
#' cor_test(sample(1:100, 100), sample(1:100, 100), method = "pearson")
#'
cor_test = function(var1, var2, method = NULL, round = TRUE){

  if(is.null(method)) {
    stop("You need to specify a correlation method")
  }

  data1 = cor.test(var1, var2, method = method)
  data1 = data.frame(t(unlist(data1)))

  grepList = c("statistic", "parameter", "p.value", "estimate", "conf.int")
  index = unlist(lapply(grepList, function(y) grep(y, names(data1))))
  for(i in index) {
    data1[, i] = as.numeric(as.character(data1[, i]))
  }

  if(round){
    for(i in index) {
      data1[, i] = round(data1[, i], 4)
    }
  }

  return(data1)
}
