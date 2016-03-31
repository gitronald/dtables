#' Generate descriptive frequencies and statistics tables
#'
#' Simplifies the process and reduces the amount of code involved in generating
#' descriptive frequencies and statistics tables by taking your entire dataset
#' as input and generating the tables it predicts you would need given various
#' variable aspects such as class.
#'
#' @param data1 a \code{data.frame} or \code{matrix}
#' @param variables select which columns of \code{data1} to analyze
#' @param frequencies select which columns to create frequencies tables for
#' @param statistics select which columns to create statistics tables for
#' @param neat logical, if \code{TRUE} returns rounded and formatted tables
#' @param as.list logical, if \code{TRUE} it returns frequencies and statistics
#'   tables in a list format, split by \code{variables}
#' @param sizesort logical, if \code{TRUE} returns data sorted by frequency and
#'   mean
#'
#' @return Returns descriptive frequencies and statistics tables for all
#'   variables in \code{data1} by default. Predicts whether to create a
#'   frequencies table, statistics table, or both for each varible based on
#'   information gathered using \code{dvariable}.
#'
#' @export
#'
#' @examples
#' # Analyze all data
#' dtable(iris2)
#'
#' #Analyze two or more variables
#' dtable(iris2, c("Color", "Sold", "LikelyToBuy"))
#'
#' # Analyze a single variable
#' dtable(iris2, "Color")
#'
#' # Return raw output
#' dtable(iris2, neat = FALSE)
#'
#' # Return list output
#' dtable(iris2, as.list = TRUE)
#'
#' # Frequencies sorted by size
#' dtable(iris2, sizesort = TRUE)
#'
dtable <- function (data1,
                    variables = NULL,
                    frequencies = NULL,
                    statistics = NULL,
                    neat = TRUE, as.list = FALSE, sizesort = FALSE){

  if(is.null(variables) & is.null(frequencies) & is.null(statistics)){
    variables = names(data1)
    var.details  <- dvariable(data1, variables)  # Extract variable details
  }
  if(is.null(variables) & !is.null(frequencies) & is.null(statistics)) {
    frequencies = frequencies
  }
  if(is.null(variables) & is.null(frequencies) & !is.null(statistics)) {
    statistics = statistics
  }
  if(!is.null(variables) & is.null(frequencies) & is.null(statistics)) {
    variables = variables
    var.details  <- dvariable(data1, variables)  # Extract variable details
  }

  dtable <- create_list(c("Frequencies", "Statistics"), 1)

  dtable$Frequencies <- lapply(frequencies, dfactor,
                               data1 = data1, neat = neat,
                               sizesort = sizesort)

  dtable$Statistics <- lapply(statistics, dnumeric,
                              data = data1, neat = neat,
                              sizesort = sizesort)

  if(!as.list){
    dtable$Frequencies <- do.call(rbind, dtable$Frequencies)
    dtable$Statistics <- do.call(rbind, dtable$Statistics)
  }

  if(!is.null(dtable$Frequencies)) {
    dtable$Frequencies$dataset <- gsub("data1", deparse(substitute(data1)),
                                       dtable$Frequencies$dataset)
  }
  if(!is.null(dtable$Statistics)) {
    dtable$Statistics$dataset <- gsub("data1", deparse(substitute(data1)),
                                      dtable$Statistics$dataset)
  }

return(dtable)
}
