# Create sample data for dtables
data(iris)

iris2 <- iris[sample(nrow(iris), 150, replace = TRUE), ]                            # Sample iris data
iris2[["Color"]] <- sample(c("orange", "blue", "red", "yellow"), 150, replace = T)  # Add factor
iris2[["Attractiveness"]] <- sample(1:5, 150, replace = T)                          # Add ordered factor
iris2[["LikelyToBuy"]] <- sample(-5:5, 150, replace = T)                            # Add ordered factor
iris2[["Sold"]] <- sample(c(TRUE, FALSE), 150, replace = T)                         # Add logical
row.names(iris2) <- NULL

devtools::use_data(iris2, overwrite = T)
