rm(list=ls())
library(multilevel)

data(package="multilevel")
data(bh1996, package="multilevel")
HRSMEANS<-tapply(bh1996$HRS,bh1996$GRP,mean)
HRSMEANS
data(univbct)
names(univbct)
length(unique(univbct$SUBNUM))

GROWDAT<-univbct[3*(1:495),c(22,8,9,12,15)] 
GROWDAT[1:3,]

UNIV.GROW<-make.univ(GROWDAT,GROWDAT[,3:5])
UNIV.GROW[1:9,]

