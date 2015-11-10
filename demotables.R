
setwd("C:/Users/aibrt/Desktop/Rprojects/dtables")
mydata <- read.table("demoData.txt", sep = ",", header = T)

# Histograms
ggplot(x, aes(x = Gender, y = Freq)) + geom_bar(stat = "identity")
ggplot(x, aes(x = Gender, y = Freq)) + geom_bar(stat = "identity") + facet_grid(~ GroupNumber)

dtable <- function (x, y, type = c("factor", "numeric"), round = F, neat = F){
  # Demographic Frequency Tables
  #  Args: 
  #    x: Object
  #    y: Variable Name
  #  Returns:
  #    dtable - List of Frequency table and numeric data.

  # Default type to factor
  if (length(type) > 1) {
    type = "factor"  
  }
  
  # If type = factor, use dfactor function to produce frequencies table
  # Else if type = numeric, produce descriptive stats table
  if(type == "factor") {
    dtable <- do.call(rbind.data.frame, lapply(y, dfactor, x = x, neat = neat))
  } else if(type == "numeric") {
    dtable <- do.call(rbind.data.frame, lapply(y, dnumeric, x = x, round = round))
    dtable <- dtable[, -1]
  }

  # If neat = T, convert frequencies table to publication ready (round and format)
  if(neat) {
    data <- c(paste0(deparse(substitute(x))), rep("", nrow(dtable) - 1))
  } else {
    data <- rep(paste0(deparse(substitute(x))), nrow(dtable))
  }
  
  dtable <- cbind(data, dtable)
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
