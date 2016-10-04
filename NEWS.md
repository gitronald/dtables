# dtables 0.2.0

Wrap it up

* Meet `dnum`, a more dynamic version of `dnumeric` (i.e. a nice wrapper for `psych::describe`)
    + Like `dnumeric`, but no `vars` argument
    + Accepts `data$var` format for input
    + Accepts `data[, c('var1', var2')]` format for multivariable input
    + Honestly, just a better wrapper for `psych::describe`
    + May later be merged with `dnumeric`
    + One quirk: `dnum()
    
# dtables 0.1.0

Making life easier

* Removed `data_frame_table`, only `dft` available now. Too bad!
* Added `neat` argument to dft to reduce columns and round numerics when `TRUE`
* Added `cor_test` function as a wrapper to `cor.test` to automate htest list output to data.frame conversion
* Added `overwrite` and `row.names` arguments to write_object
* Added variable name for single variable `dft`s
* Added `digits` argument to `dft` to specify descriptive stats rounding.

# dtables 0.0.1 

* Functions for simplifying descriptive statistics and frequencies
