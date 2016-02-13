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
#' dtable(iris2, variables = c("Color", "Sold", "LikelyToBuy"))
#'
#' # Analyze a single variable
#' dtable(iris2, variables = "Color")
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

  if(is.null(variables)) variables <- names(data1)
  var.details  <- dvariable(data1, variables)  # Extract variable details

  if(is.null(frequencies)) { # Default to dvariable prediction
    frequencies <- paste(var.details[var.details["frequencies"] == 1, "variable"])
  }
  if(is.null(statistics)) { # Default to dvariable prediction
    statistics  <- paste(var.details[var.details["statistics"] == 1, "variable"])
  }

  dtable <- create_list(c("Frequencies", "Statistics"), 1)

  dtable$Frequencies <- lapply(frequencies, dfactor,
                               data = data1, neat = neat,
                               sizesort = sizesort)

  dtable$Statistics <- lapply(statistics, dnumeric,
                              data = data1, neat = neat,
                              sizesort = sizesort)

  if(!as.list){
    dtable$Frequencies <- do.call(rbind, dtable$Freq)
    dtable$Statistics <- do.call(rbind, dtable$Statistics)
  }

  dtable$Frequencies$Dataset <- gsub("data1", deparse(substitute(data1)),
                                     dtable$Frequencies$Dataset)
  dtable$Statistics$dataset <- gsub("data1", deparse(substitute(data1)),
                                    dtable$Statistics$dataset)

return(dtable)
}


#' Extract and paste from a data.frame
#'
#' @param data1 a \code{data.frame}
#' @param selectCol select a column
#' @param selectRows select value in that column
#' @param column select column to extract
#'
#' @return String vector with selected values
extract <- function(data1, selectCol = NULL, selectRows = NULL, column = NULL) {
  if (sum(sapply(c(selectCol, selectRows, column), length)) > 0) {
    data1 <- paste(data1[data1[selectCol] == selectRows, paste(column)])
  }

  return(data1)
}
