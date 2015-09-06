rm(list=ls())
setwd("C:/Rcode")

ListB <- read.csv("finalB.csv",header=TRUE)
ListA <- read.csv("finalA.csv",header=TRUE)

ListA <- ListA[,2:7]
ListB <- ListB[,2:7]

DataA <- NULL
DataB <- NULL

for (i in 1:83){
  aa <- ListA[(9*i-8):(9*i),1]
  bb <- ListA[(9*i-8):(9*i),2]
  cc <- ListA[(9*i-8):(9*i),3]
  dd <- ListA[(9*i-8):(9*i),4]
  ee <- ListA[(9*i-8):(9*i),5]
  ff <- ListA[(9*i-8):(9*i),6]
  line <- c(aa,bb,cc,dd,ee,ff)
  DataA <- rbind(DataA,line)
}


for (i in 1:94){
  aa <- ListB[(9*i-8):(9*i),1]
  bb <- ListB[(9*i-8):(9*i),2]
  cc <- ListB[(9*i-8):(9*i),3]
  dd <- ListB[(9*i-8):(9*i),4]
  ee <- ListB[(9*i-8):(9*i),5]
  ff <- ListB[(9*i-8):(9*i),6]
  line <- c(aa,bb,cc,dd,ee,ff)
  DataB <- rbind(DataB,line)
}