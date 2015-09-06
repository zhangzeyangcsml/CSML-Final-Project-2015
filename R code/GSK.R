## rm(list=ls())
## setwd("C:/Rcode")

DataA <- as.matrix(DataA)
DataB <- as.matrix(DataB)

"""
DataA <- t(DataA)
DataB <- t(DataB)
DataA <- DataA[,1:54]
DataB <- DataB[,1:54]
"""

library(LiblineaR)
Data <- rbind(DataA, DataB) 

numTrain <- 120
x <- Data
y=factor(c(rep("Drug_A",nrow(DataA)),rep("Drug_B",nrow(DataB))))
train=sample(1:dim(Data)[1],numTrain)
xTrain=x[train,]
xTest=x[-train,]
yTrain=y[train]
yTest=y[-train]
# Center and scale data
#s=scale(xTrain,center=TRUE,scale=TRUE)

## Finding the best regularization constant
tryCost=c(1000,100,10,1,0.1,0.01,0.001)
bestCost=NA
bestAcc=0

for (co in tryCost){
  acc= LiblineaR(data = xTrain,target= yTrain, type = 6, cost = co, epsilon =0.01, bias=TRUE,cross=5,verbose=FALSE)
  cat("Results for C=",co," : ",acc," accuracy.\n",sep="")
  if(acc>bestAcc){
    bestCost=co
    bestAcc=acc
  }
}

cat("Best cost is:",bestCost,"\n")
cat("Best accuracy is:",bestAcc,"\n")


# Re-train best model with best cost value.
m=LiblineaR(data = xTrain,target= yTrain, type = 6, cost = bestCost, bias=TRUE, verbose=FALSE)
# Scale the test data
#s2=scale(xTest,attr(s,"scaled:center"),attr(s,"scaled:scale"))
# Make Prediction
pr = FALSE
p=predict(m,xTest,proba=pr,decisionValues=TRUE)
res=table(p$predictions,yTest)
print(res)

Testacc <- sum(diag(res))/(nrow(Data)-numTrain)
cat("Test accuracy is:",Testacc,"\n")
