data_frame_table <- function(data1){
  t   <- table(data1)
  dft <- data.frame(t)
  return(dft)
}

data_frame_prop_table <- function(data1){
  t   <- table(data1)
  prop <- as.vector(t/sum(t))
  dft <- data.frame(t, p)
  return(dft)
}
