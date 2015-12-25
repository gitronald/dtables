# TODO:
#  - Neatify numeric return on TRUE argument in dtable
#  - Add sizesort argument to dtable
#' detectClass
#'
#' Helper function for dtable. Obtains column classes and splits variable 
#' names into a list of two vectors based on numeric/integer or factor class.
#' 
#' @param data data.frame
#' @param vnames vector of variable names from data.frame to classify
#'
#' @return Returns a list with a vector containing factor variable names, 
#'    and a vector containing numeric variable names.
#' @seealso \code{\link{class}} which this function relies on
#' @export
#' @examples
#' data(demoData)
#' detectClass(myData, "Education")
#'
#' vars <- c("Education", "Age")
#' detectClass(myData, vars)
#' 
detectClass <- function(data, vnames){
    # Helper function used in dtable  
detect <- cbind(vnames = vnames, dclass = NA)
for (i in 1:length(vnames)){
  detect[, "dclass"][i] <- class(data[, vnames[i]])
}
detected <- list()
detected[["factor"]] <- detect[detect[, "dclass"] == "factor", "vnames"]
detected[["numeric"]] <- detect[detect[, "dclass"] %in% c("numeric", "integer"), "vnames"]

return(detected)
}
#' dtable
#'
#' @param data data.frame
#' @param vnames vector of variable names from data.frame to use in creation
#'    of demographic tables
#' @param round logical, TRUE returns rounded numeric table
#' @param neat logical, TRUE returns rounded factor table with percent symbols
#'
#' @return list of data.frames $factor and $numeric if `vnames` contains both classes,
#'    single data.frame returned if only one variable class in vnames.
#'    
dtable <- function (data, vnames, round = F, neat = F){
  # Demographic Frequency Tables
  #  Args: 
  #    data: Object
  #    vnames: Variable Name
  #  Returns:
  #    dtable - List of Frequency table and numeric data.
  detected <- detectClass(data, vnames)
  # Produce frequencies table and descriptive stats table (dependent on available data)
  dtable <- list()
  if(length(detected$f) > 0) {
    dtable[["factor"]] <- do.call(rbind.data.frame, lapply(detected$f, dfactor, data = data, neat = neat))
    if(neat) {
      data <- c(paste0(deparse(substitute(data))), rep("", nrow(dtable[["factor"]]) - 1))
    } else {
      data <- rep(paste0(deparse(substitute(data))), nrow(dtable[["factor"]]))
    }
    dtable[["factor"]] <- cbind(data, dtable[["factor"]]) 
    row.names(dtable[["factor"]]) <- NULL
  } 
  if(length(detected$n) > 0) {
    dtable[["numeric"]] <- do.call(rbind.data.frame, lapply(detected$n, dnumeric, data = data, round = round))
    dtable[["numeric"]] <- dtable[["numeric"]][, -1]
    if(neat) {
      data <- c(paste0(deparse(substitute(data))), rep("", nrow(dtable[["numeric"]]) - 1))
    } else {
      data <- rep(paste0(deparse(substitute(data))), nrow(dtable[["numeric"]]))
    }
    dtable[["numeric"]] <- cbind(data, dtable[["numeric"]])
    row.names(dtable[["numeric"]]) <- NULL
  }

  return(dtable)
}
#' dfactor
#'
#' @param data data.frame
#' @param vnames vector of variable names from data.frame to use in creation
#'    of demographics table, multiple names examines crosstabs.
#' @param neat logical, TRUE returns rounded factor table with percent symbols
#' @param sizesort logical, TRUE returns table sorted by size
#'
#' @return data.frame
#'
dfactor <- function (data, vnames, neat = FALSE, sizesort = FALSE) {
  # Demographic Frequencies Table (Factors)
  #  Args: 
  #    data: Data Object
  #    vnames: Variable Name
  #
  # First column - Name the demographic from object name
  Demographic <- vector()
  DemoName    <- paste0(vnames)
  Demographic <- rep(DemoName, (length(table(data[vnames]))))
  
  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- table(data[, vnames])
  dgroup <- data.frame(dgroup)

  # Fourth column - Percent value of frequency count
  dgroup <- transform(dgroup, Prop = prop.table(Freq))
  
  # Make table neat by rounding and removing repetitive labels
  if (neat) {
    # Convert proportion to percent
    dgroup[, "Perc"] <- dgroup[, "Prop"]*100
    dgroup[, "Perc"] <- format(round(dgroup[, "Perc"], 1), nsmall = 1)
    dgroup[, "Prop"] <- NULL
    
    # Add percent symbol: "$" is end of string in regex
    dgroup[, "Perc"] <- gsub("$", "%", dgroup[, "Perc"])
    
    # If only one variable, remove repetitive demographic IDs (presentation format)
    if (length(vnames) == 1) {
      Demographic <- c(DemoName, rep("", (length(table(data[vnames]))-1)))
    }
  }
  
  # Rename demographic group variable and demographic ID if more than 1 used
  if (length(vnames) == 1) {
    names(dgroup)[1] <- "Group"
  } else {
    Demographic <- paste(vnames, collapse = ".")
  }
  
  # Sort by Freq
  if (sizesort) {
    dgroup <- dgroup[order(dgroup[, "Freq"], decreasing = TRUE), ]
  }
  
  dgroup <- cbind(Demographic, dgroup)
  rownames(dgroup) <- NULL
  
  return(dgroup)
}
#' dnumeric
#'
#' @param data data.frame
#' @param vnames single variable name to describe 
#' @param round 
#'
#' @return data.frame
#'
dnumeric <- function(data, vnames, round = FALSE) {
  # Demographic Frequencies Table (Numerics)
  #  Args: 
  #    data: Object
  #    vnames: Variable Name
  #
  
  require(psych)
  data     <- paste0(deparse(substitute(data)))
  variable <- paste0(vnames)
  descript <- describe(data[[vnames]])
  results  <- cbind(data, variable, descript)
  
  if (round) {
    results <- cbind(results[, 1:4], round(results[, 5:length(results)], digits = 1))
  }
  
  return(results)
}