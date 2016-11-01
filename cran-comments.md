## Test environments
* windows >= 8 x64 build 9200 x86-64 (64-bit), R 3.3.1
* win-builder(devel and release)

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs. 

## Downstream dependencies
There is one downstream dependency for `dtables`. A `devtools::revdep_check` returns one error saying failed to install the package `IPtoCountry`, but using `install.packages('IPtoCountry')` does not return any problems and the `dtables::dft` function used in `IPtoCountry` has not changed in a way that affects its operation in that package.
