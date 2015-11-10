
detectClass <- function(data, dvariable){
    # Helper function used in dtable  
detect <- cbind(dvariable = dvariable, dclass = NA)
for (i in 1:length(dvariable)){
  detect[, "dclass"][i] <- class(data[, dvariable[i]])
}
detected <- list()
detected[["factor"]] <- detect[detect[, "dclass"] == "factor", "dvariable"]
detected[["numeric"]] <- detect[detect[, "dclass"] %in% c("numeric", "integer"), "dvariable"]

return(detected)
}

dtable <- function (x, y, round = F, neat = F){
  
  # Demographic Frequency Tables
  #  Args: 
  #    x: Object
  #    y: Variable Name
  #  Returns:
  #    dtable - List of Frequency table and numeric data.
  detected <- detectClass(x, y)
  # Produce frequencies table and descriptive stats table (dependent on available data)
  dtable <- list()
  if(length(detected$f) > 0) {
    dtable[["factor"]] <- do.call(rbind.data.frame, lapply(detected$f, dfactor, x = x, neat = neat))
    if(neat) {
      data <- c(paste0(deparse(substitute(x))), rep("", nrow(dtable[["factor"]]) - 1))
    } else {
      data <- rep(paste0(deparse(substitute(x))), nrow(dtable[["factor"]]))
    }
    dtable[["factor"]] <- cbind(data, dtable[["factor"]]) 
    row.names(dtable[["factor"]]) <- NULL
  } 
  if(length(detected$n) > 0) {
    dtable[["numeric"]] <- do.call(rbind.data.frame, lapply(detected$n, dnumeric, x = x, round = round))
    dtable[["numeric"]] <- dtable[["numeric"]][, -1]
    if(neat) {
      data <- c(paste0(deparse(substitute(x))), rep("", nrow(dtable[["numeric"]]) - 1))
    } else {
      data <- rep(paste0(deparse(substitute(x))), nrow(dtable[["numeric"]]))
    }
    dtable[["numeric"]] <- cbind(data, dtable[["numeric"]])
    row.names(dtable[["numeric"]]) <- NULL
  }

  return(dtable)
}


dfactor <- function (x, y, neat = FALSE, sizesort = FALSE) {
  # Demographic Frequencies Table (Factors)
  #  Args: 
  #    x: Data Object
  #    y: Variable Name
  #
  # First column - Name the demographic from object name
  Demographic <- vector()
  DemoName    <- paste0(y)
  Demographic <- rep(DemoName, (length(table(x[y]))))
  
  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- table(x[, y])
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
    if (length(y) == 1) {
      Demographic <- c(DemoName, rep("", (length(table(x[y]))-1)))
    }
  }
  
  # Rename demographic group variable and demographic ID if more than 1 used
  if (length(y) == 1) {
    names(dgroup)[1] <- "Group"
  } else {
    Demographic <- paste(y, collapse = ".")
  }
  
  # Sort by Freq
  if (sizesort) {
    dgroup <- dgroup[order(dgroup[, "Freq"], decreasing = TRUE), ]
  }
  
  dgroup <- cbind(Demographic, dgroup)
  rownames(dgroup) <- NULL
  
  return(dgroup)
}


dnumeric <- function(x, y, round = FALSE) {
  # Demographic Frequencies Table (Numerics)
  #  Args: 
  #    x: Object
  #    y: Variable Name
  #
  
  require(psych)
  data     <- paste0(deparse(substitute(x)))
  variable <- paste0(y)
  descript <- describe(x[[y]])
  results  <- cbind(data, variable, descript)
  
  if (round) {
    results <- cbind(results[, 1:4], round(results[, 5:length(results)], digits = 1))
  }
  
  return(results)
}
