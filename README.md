# dtables

* Simplifies the process and reduces the amount of code involved in generating   
  descriptive frequencies and statistics tables with or without formatting.

#### Descriptive frequencies and statistics tables
```
> dtable(iris2)

$Frequencies
   Dataset    Demographic      Group Freq  Perc
1    iris2        Species     setosa   39 26.0%
2                         versicolor   53 35.3%
3                          virginica   58 38.7%
4    iris2          Color       blue   29 19.3%
5                             orange   43 28.7%
6                                red   40 26.7%
7                             yellow   38 25.3%
8    iris2 Attractiveness          1   35 23.3%
9                                  2   31 20.7%
10                                 3   21 14.0%
11                                 4   26 17.3%
12                                 5   37 24.7%
13   iris2    LikelyToBuy         -5   14  9.3%
14                                -4   16 10.7%
15                                -3   18 12.0%
16                                -2   16 10.7%
17                                -1   12  8.0%
18                                 0   10  6.7%
19                                 1   15 10.0%
20                                 2   11  7.3%
21                                 3   12  8.0%
22                                 4   12  8.0%
23                                 5   14  9.3%
24   iris2           Sold      FALSE   81 54.0%
25                              TRUE   69 46.0%
26   iris2          Sold2          0   78 52.0%
27                                 1   72 48.0%

$Statistics
  dataset     variable vars   n mean  sd median trimmed mad min max range skew kurtosis  se
1   iris2 Sepal.Length    1 150  5.9 0.8    5.8     5.9 1.0 4.4 7.9   3.5  0.2     -0.6 0.1
2   iris2  Sepal.Width    1 150  3.0 0.4    3.0     3.0 0.4 2.0 4.1   2.1  0.2     -0.3 0.0
3   iris2 Petal.Length    1 150  4.0 1.7    4.4     4.1 1.3 1.0 6.9   5.9 -0.5     -1.0 0.1
4   iris2  Petal.Width    1 150  1.3 0.8    1.4     1.4 0.9 0.1 2.5   2.4 -0.3     -1.2 0.1
```
  
### Options

* Create Raw Output: `dtable(iris2, neat = FALSE)`

* Create List Outputs: `dtable(iris2, as.list = T)`

* Select variables: `dtable(iris2, variables = c("Species", "Sold", "Sepal.Length"))`

* Specify variable descriptives: `dtable(iris2, frequencies = "Species", statistics = "LikelyToBuy")`
