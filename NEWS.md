# dtables 0.0.2 

* Removed `data_frame_table`, only `dft` available now
* Added `neat` argument to dft to reduce columns and round numerics when `TRUE`
* Added `cor_test` function as a wrapper to `cor.test` to automate htest list output to data.frame conversion
* Added `lf` function as a wrapper to `list.files` to make file navigation in the console easier
* Added `ef` function as a wrapper to `edit.file` to make opening files in the console easier
* Added `overwrite` argument to write_object
* Added variable name for single variable `dft`s
```
> dft(iris2$Species)
         Species  n      prop  perc
1     setosa 52 0.3466667 34.7%
2 versicolor 49 0.3266667 32.7%
3  virginica 49 0.3266667 32.7%
```
* Added `digits` argument to `dft` to specify descriptive stats rounding.

# dtables 0.0.1 

* Functions for simplifying descriptive statistics and frequencies
