# dtables

* The goal of dtables is to quickly and intelligently generate useful and presentable descriptives frequencies and statistics tables with minimal input.
* The purpose of dtables is really just to make my life, and hopefully yours, a little easier.

### Getting Started
``` {r}
devtools::install_github("gitronald/dtables")
library(dtables)
data(iris2)
```

### The data.frame table (dft)
* Essentially a shortcut to `data.frame(table(x))`, but with bells and whistles including optional proportion and percentage columns, and a full range of descriptive statistics for a target variable courtesy a la `describe` function from the `psych` package. 

``` {r}
> dft(iris2$Species, prop = TRUE, perc = TRUE)
       group  n      prop  perc
1     setosa 52 0.3466667 34.7%
2 versicolor 49 0.3266667 32.7%
3  virginica 49 0.3266667 32.7%
```

* To add descriptive statistics to your dft, simply add a `by` argument with the variable to describe: 

``` {r}
> dft(iris2$Species, by = iris2$Sepal.Length)
        group  n      prop  perc     mean        sd median  trimmed     mad min max range ...
11     setosa 52 0.3466667 34.7% 4.955769 0.3460780    5.0 4.945238 0.29652 4.3 5.7   1.4 
12 versicolor 49 0.3266667 32.7% 5.963265 0.4893422    6.0 5.978049 0.59304 4.9 6.9   2.0 
13  virginica 49 0.3266667 32.7% 6.751020 0.6636774    6.8 6.773171 0.74130 4.9 7.7   2.8 
```

### dvariable
* Variable details for an entire data.frame or for individual variables.
* Will flag variables that it can't classify (e.g. an NA or overly complex variable)

``` {r}
> dvariable(iris2)
Note: 'Approval' was not classified.
Note: 'Date' was not classified.
         variable     class      mode      type levels frequencies statistics
1    Sepal.Length   numeric   numeric    double     32           0          1
2     Sepal.Width   numeric   numeric    double     21           0          1
3    Petal.Length   numeric   numeric    double     39           0          1
4     Petal.Width   numeric   numeric    double     21           0          1
5         Species    factor   numeric   integer      3           1          0
6           Color character character character      4           1          0
7  Attractiveness   integer   numeric   integer      5           1          1
8     LikelyToBuy   integer   numeric   integer     11           1          1
9            Sold   logical   logical   logical      2           1          0
10         Review   numeric   numeric    double      5           1          1
11       Approval   logical   logical   logical      0           0          0
12           Date      Date   numeric    double     99           0          0
```
* Classification matters because these feed into `dtable`...

### dtable
* Uses classifications from `dvariable` to sort variables into two categories:
    1. Variables which would make sense in a descriptive frequencies table
    2. Variables which would make sense in a descriptive statistics table


``` {r}
> dtable(iris2)
$Frequencies
   dataset    demographic      group  n  perc
1    iris2        Species     setosa 52 34.7%
2                         versicolor 49 32.7%
3                          virginica 49 32.7%
4    iris2          Color       blue 47 31.3%
5                             orange 30 20.0%
6                                red 40 26.7%
7                             yellow 33 22.0%
8    iris2 Attractiveness          1 27 18.0%
9                                  2 30 20.0%
10                                 3 31 20.7%
11                                 4 32 21.3%
12                                 5 30 20.0%
13   iris2    LikelyToBuy         -5 16 10.7%
14                                -4 13  8.7%
15                                -3 12  8.0%
16                                -2 13  8.7%
17                                -1 21 14.0%
18                                 0 10  6.7%
19                                 1 13  8.7%
20                                 2 14  9.3%
21                                 3 15 10.0%
22                                 4  8  5.3%
23                                 5 15 10.0%
24   iris2           Sold      FALSE 79 52.7%
25                              TRUE 71 47.3%
26   iris2         Review          1 31 20.7%
27                                 2 27 18.0%
28                                 3 34 22.7%
29                                 4 27 18.0%
30                                 5 31 20.7%

$Statistics
  dataset       variable vars   n mean  sd median trimmed mad  min max range skew kurtosis  se
1   iris2   Sepal.Length    1 150  5.9 0.9    5.8     5.8 1.1  4.3 7.7   3.4  0.3     -0.8 0.1
2   iris2    Sepal.Width    1 150  3.1 0.4    3.0     3.1 0.3  2.2 4.4   2.2  0.3      0.0 0.0
3   iris2   Petal.Length    1 150  3.8 1.8    4.4     3.8 2.1  1.0 6.9   5.9 -0.2     -1.4 0.2
4   iris2    Petal.Width    1 150  1.2 0.8    1.3     1.2 1.3  0.1 2.5   2.4 -0.1     -1.5 0.1
5   iris2 Attractiveness    1 150  3.1 1.4    3.0     3.1 1.5  1.0 5.0   4.0 -0.1     -1.3 0.1
6   iris2    LikelyToBuy    1 150 -0.1 3.2   -0.5    -0.2 3.7 -5.0 5.0  10.0  0.1     -1.2 0.3
7   iris2         Review    1 150  3.0 1.4    3.0     3.0 1.5  1.0 5.0   4.0  0.0     -1.3 0.1

```

* Will use all variables by default and a subset of variables can be specified by setting a `vars` argument.

### dtable options

* Select variables: `dtable(iris2, vars = c("Species", "Sold", "Sepal.Length"))`

* Specify frequencies and statistics tables: `dtable(iris2, frequencies = "Species", statistics = "LikelyToBuy")`

* Generate raw output: `dtable(iris2, neat = FALSE)`

* Generate list outputs: `dtable(iris2, as.list = T)`
