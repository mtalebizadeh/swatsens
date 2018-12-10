#a <- c(1,1,1,3,3,3,5,6)
a <- c("a","a","a","b","b","d","d","d")
b <- c(43,23,11,65,43,21,46,53)
myDF <- data.frame(Name=a, Income=b,stringsAsFactors = F)

aggregate(x = subset(x = myDF,select = c("Income")),
          by = list(fileList=myDF$Name),
          FUN = function(x) sum(x))
