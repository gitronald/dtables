Dtable <- function(x, round = FALSE) {
  # Demographic Frequencies Table 
  #  Args: 
  #    x: Object$FactorVariableName
  # First column - Name the demographic from object name
  Demographic <- vector()
  DemoName    <- unlist(strsplit(paste(deparse(substitute(x))), "\\$"))[2]
  Demographic <- c(DemoName, rep("", (nlevels(x)-1)))
  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- x
  dgroup <- data.frame(table(dgroup))
  #Fourth column - Percent value of frequency count
  if (round) {
    dgroup <- transform(dgroup, Perc = round(prop.table(Freq)*100, digits=1))
  } else {
    dgroup <- transform(dgroup, Perc = prop.table(Freq)*100)
  }
  dgroup <- cbind(Demographic, dgroup)
  return(dgroup)
}

Dtable2 <- function (x, y, round = FALSE) {
  # Demographic Frequencies Table 
  #  Args: 
  #    x: Object$FactorVariableName
  #    y: Character vector
  #
  #First column - Name the demographic from object name
  Demographic <- vector()
  DemoName    <- paste0(y)
  Demographic <- c(DemoName, rep("", (length(table(x[y]))-1)))
  # Second & Third columns - Demographic factors and frequency counts
  dgroup <- x[y]
  dgroup <- data.frame(table(dgroup))
  dgroup <- cbind(Demographic, dgroup)
  #Fourth column - Percent value of frequency count
  if (round) {
    dgroup <- transform(dgroup, Perc = round(prop.table(Freq)*100, digits=1))
  } else {
    dgroup <- transform(dgroup, Perc = prop.table(Freq)*100)
  }
  rownames(dgroup) <- NULL
  return(dgroup)
}