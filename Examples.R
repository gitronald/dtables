# Example of dtable

mydata <- read.table("demoData.tsv", sep = "\t", header = T)
y <- c("Gender", "Employed", "Age")
dtable(mydata, y)

# OUTPUT:
#
# $factor
# data Demographic  Group Freq Prop
# 1 mydata      Gender Female   84 0.42
# 2 mydata      Gender   Male  116 0.58
# 3 mydata    Employed     No   46 0.23
# 4 mydata    Employed    Yes  154 0.77
# 
# $numeric
# data   variable vars   n  mean       sd median trimmed    mad min max range     skew kurtosis       se
# mydata      Age    1 200 32.52 10.54684     30  30.925 8.8956  18  69    51 1.309903 1.292516 0.745774


# Using the neat argument
dtable(mydata, y, neat = T)

# OUTPUT:
#
# $factor
#   data  Demographic  Group Freq  Perc
# mydata       Gender Female   84 42.0%
#                       Male  116 58.0%
#            Employed     No   46 23.0%
#                        Yes  154 77.0%
# 
# $numeric
#    data variable vars   n  mean       sd median trimmed    mad min max range     skew kurtosis       se
#  mydata      Age    1 200 32.52 10.54684     30  30.925 8.8956  18  69    51 1.309903 1.292516 0.745774