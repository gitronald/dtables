# Create sample data for dtables
data(iris)

iris2 <- iris[sample(nrow(iris), 150, replace = TRUE), ]                            # Sample iris data
iris2[["Color"]] <- sample(c("orange", "blue", "red", "yellow"), 150, replace = T)  # Add factor
iris2[["Attractiveness"]] <- sample(1:5, 150, replace = T)                          # Add ordered factor
iris2[["LikelyToBuy"]] <- sample(-5:5, 150, replace = T)                            # Add ordered factor
iris2[["Sold"]] <- sample(c(TRUE, FALSE), 150, replace = T)                         # Add logical
iris2[["Review"]] <- as.numeric(sample(1:5, 150, replace = T))                      # Add numeric integer
iris2[["Approval"]] <- rep(NA, 150)                                                 # Add missing data
iris2[["Date"]] <- sample(seq.Date(as.Date("2015-09-01"), Sys.Date(), "day"),       # Add date
                          150, replace = T)

row.names(iris2) <- NULL

devtools::use_data(iris2, overwrite = T)
