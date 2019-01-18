#a <- c(1,1,1,3,3,3,5,6)
a <- c("a","a","a","b","b","d","d","d")
b <- c(43,23,11,65,43,21,46,53)
myDF <- data.frame(Name=a, Income=b,stringsAsFactors = F)

aggregate(x = subset(x = myDF,select = c("Income")),
          by = list(fileList=myDF$Name),
          FUN = function(x) sum(x))


names1 = list("hru"=c("f1","f2","f3"), "gw"=c("g1","g2","g3","g4"))

x_list = list()
parmList = list()

for (catg in names(names1)) {
  x_list[[catg]] = 5
}









