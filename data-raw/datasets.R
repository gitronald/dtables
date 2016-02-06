# Collect all common R datasets

Rdatasets <- data.frame(data()[["results"]])

packages <- paste(Rdatasets[, "Item"])
data(packages[1]) # Why doesn't this work?

