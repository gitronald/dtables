# demotables

* Simplifies the process and reduces the amount of code involved in generating   
  descriptive frequencies and statistics tables with or without formatting.

#### Descriptive frequencies and statistics tables
```
> dtable(iris2)

$Freq
   Dataset    Demographic      Group Freq  Perc
1    data1          Color       blue   47 31.3%
2                                red   38 25.3%
3                             orange   34 22.7%
4                             yellow   31 20.7%
5    data1        Species  virginica   52 34.7%
6                             setosa   51 34.0%
7                         versicolor   47 31.3%
8    data1 Attractiveness          2   34 22.7%
9                                  1   33 22.0%
10                                 4   33 22.0%
11                                 3   27 18.0%
12                                 5   23 15.3%
13   data1    LikelyToBuy         -2   22 14.7%
14                                 4   17 11.3%
15                                -3   15 10.0%
16                                 2   15 10.0%
17                                -5   14  9.3%
18                                 5   14  9.3%
19                                 1   13  8.7%
20                                -4   12  8.0%
21                                -1   10  6.7%
22                                 0   10  6.7%
23                                 3    8  5.3%
24   data1           Sold      FALSE   84 56.0%
25                              TRUE   66 44.0%

$Desc
  dataset       variable vars   n mean  sd median trimmed mad  min max range skew kurtosis  se
1   data1   Sepal.Length    1 150  5.8 0.8    5.8     5.8 0.9  4.4 7.9   3.5  0.3     -0.6 0.1
2   data1    Sepal.Width    1 150  3.1 0.5    3.0     3.1 0.4  2.0 4.2   2.2  0.1     -0.3 0.0
3   data1   Petal.Length    1 150  3.7 1.8    4.2     3.7 2.0  1.0 6.7   5.7 -0.3     -1.5 0.1
4   data1    Petal.Width    1 150  1.2 0.8    1.3     1.2 1.0  0.1 2.4   2.3 -0.1     -1.4 0.1
5   data1 Attractiveness    1 150  2.9 1.4    3.0     2.8 1.5  1.0 5.0   4.0  0.1     -1.3 0.1
6   data1    LikelyToBuy    1 150 -0.1 3.2    0.0    -0.1 4.4 -5.0 5.0  10.0  0.1     -1.3 0.3
```
  
    
#### Create Raw Output

```
> dtable(iris2, neat = FALSE)

$Freq
   Dataset    Demographic      Group Freq       Prop
1    data1          Color       blue   47 0.31333333
2    data1          Color        red   38 0.25333333
3    data1          Color     orange   34 0.22666667
4    data1          Color     yellow   31 0.20666667
5    data1        Species  virginica   52 0.34666667
6    data1        Species     setosa   51 0.34000000
7    data1        Species versicolor   47 0.31333333
8    data1 Attractiveness          2   34 0.22666667
9    data1 Attractiveness          1   33 0.22000000
10   data1 Attractiveness          4   33 0.22000000
11   data1 Attractiveness          3   27 0.18000000
12   data1 Attractiveness          5   23 0.15333333
13   data1    LikelyToBuy         -2   22 0.14666667
14   data1    LikelyToBuy          4   17 0.11333333
15   data1    LikelyToBuy         -3   15 0.10000000
16   data1    LikelyToBuy          2   15 0.10000000
17   data1    LikelyToBuy         -5   14 0.09333333
18   data1    LikelyToBuy          5   14 0.09333333
19   data1    LikelyToBuy          1   13 0.08666667
20   data1    LikelyToBuy         -4   12 0.08000000
21   data1    LikelyToBuy         -1   10 0.06666667
22   data1    LikelyToBuy          0   10 0.06666667
23   data1    LikelyToBuy          3    8 0.05333333
24   data1           Sold      FALSE   84 0.56000000
25   data1           Sold       TRUE   66 0.44000000

$Desc
  dataset       variable vars   n      mean        sd median   trimmed     mad  min max range        skew   kurtosis         se
1   data1   Sepal.Length    1 150  5.821333 0.8316384   5.80  5.791667 0.88956  4.4 7.9   3.5  0.29617680 -0.5971863 0.06790299
2   data1    Sepal.Width    1 150  3.078000 0.4708795   3.00  3.070833 0.44478  2.0 4.2   2.2  0.13300939 -0.2897237 0.03844715
3   data1   Petal.Length    1 150  3.711333 1.7596727   4.25  3.718333 2.00151  1.0 6.7   5.7 -0.26074778 -1.4861990 0.14367667
4   data1    Petal.Width    1 150  1.174667 0.7531755   1.30  1.159167 1.03782  0.1 2.4   2.3 -0.08662647 -1.4141391 0.06149652
5   data1 Attractiveness    1 150  2.860000 1.3904275   3.00  2.825000 1.48260  1.0 5.0   4.0  0.10018684 -1.3024980 0.11352793
6   data1    LikelyToBuy    1 150 -0.080000 3.2159836   0.00 -0.100000 4.44780 -5.0 5.0  10.0  0.08977883 -1.2869603 0.26258396
```
#### Create List Output
```
> dtable(iris2, as.list = T)
$Freq
$Freq[[1]]
  Dataset Demographic  Group Freq  Perc
1   data1       Color   blue   47 31.3%
2                        red   38 25.3%
3                     orange   34 22.7%
4                     yellow   31 20.7%

$Freq[[2]]
  Dataset Demographic      Group Freq  Perc
1   data1     Species  virginica   52 34.7%
2                         setosa   51 34.0%
3                     versicolor   47 31.3%

$Freq[[3]]
  Dataset    Demographic Group Freq  Perc
1   data1 Attractiveness     2   34 22.7%
2                            1   33 22.0%
3                            4   33 22.0%
4                            3   27 18.0%
5                            5   23 15.3%

$Freq[[4]]
   Dataset Demographic Group Freq  Perc
1    data1 LikelyToBuy    -2   22 14.7%
2                          4   17 11.3%
3                         -3   15 10.0%
4                          2   15 10.0%
5                         -5   14  9.3%
6                          5   14  9.3%
7                          1   13  8.7%
8                         -4   12  8.0%
9                         -1   10  6.7%
10                         0   10  6.7%
11                         3    8  5.3%

$Freq[[5]]
  Dataset Demographic Group Freq  Perc
1   data1        Sold FALSE   84 56.0%
2                      TRUE   66 44.0%


$Desc
$Desc[[1]]
  dataset     variable vars   n mean  sd median trimmed mad min max range skew kurtosis  se
1   data1 Sepal.Length    1 150  5.8 0.8    5.8     5.8 0.9 4.4 7.9   3.5  0.3     -0.6 0.1

$Desc[[2]]
  dataset    variable vars   n mean  sd median trimmed mad min max range skew kurtosis se
1   data1 Sepal.Width    1 150  3.1 0.5      3     3.1 0.4   2 4.2   2.2  0.1     -0.3  0

$Desc[[3]]
  dataset     variable vars   n mean  sd median trimmed mad min max range skew kurtosis  se
1   data1 Petal.Length    1 150  3.7 1.8    4.2     3.7   2   1 6.7   5.7 -0.3     -1.5 0.1

$Desc[[4]]
  dataset    variable vars   n mean  sd median trimmed mad min max range skew kurtosis  se
1   data1 Petal.Width    1 150  1.2 0.8    1.3     1.2   1 0.1 2.4   2.3 -0.1     -1.4 0.1

$Desc[[5]]
  dataset       variable vars   n mean  sd median trimmed mad min max range skew kurtosis  se
1   data1 Attractiveness    1 150  2.9 1.4      3     2.8 1.5   1   5     4  0.1     -1.3 0.1

$Desc[[6]]
  dataset    variable vars   n mean  sd median trimmed mad min max range skew kurtosis  se
1   data1 LikelyToBuy    1 150 -0.1 3.2      0    -0.1 4.4  -5   5    10  0.1     -1.3 0.3
```

#### Define a Variable
* Used to help predict whether to create a descriptive frequencies table,  
descriptive statistics table, or both for each variable

```
> dvariable(iris2)

        variable     class      mode      type
1   Sepal.Length   numeric   numeric    double
2    Sepal.Width   numeric   numeric    double
3   Petal.Length   numeric   numeric    double
4    Petal.Width   numeric   numeric    double
5        Species    factor   numeric   integer
6          Color character character character
7 Attractiveness   integer   numeric   integer
8    LikelyToBuy   integer   numeric   integer
9           Sold   logical   logical   logical
```


