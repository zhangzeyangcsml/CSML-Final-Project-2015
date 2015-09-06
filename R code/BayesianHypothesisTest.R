################################################################
############ Build the Bayesian Hypothesis Test Function #######
############ Based on the Equation in our Reprt  ###############

BHTest <- function (Y = NULL, X = NULL){
  
############ First Check if the input data are right ###########
  if (!is.numeric(Y)) {
    stop("Y must be numeric")
  }
  else if (!is.numeric(X)) {
    stop("X must be numeric")
  } 
################# Round up to integer if not####################
  Y <- round(Y)
  X <- round(X)
################# Take size of two data sets ################### 
  N1 <- length(Y)
  N2 <- length(X)
################# Total number of categories (how many unique numebers) these two set data fall into #######
  XY <- unique(c(Y,X))
  m <- length(XY)
  
  tX <- table(X)
  tY <- table(Y)
############# Take log to control the magnitude of the product #############################################  
  lognum <- lgamma(N1 + m) + lgamma(N2 + m) - (lgamma(N1 + N2 +m) + lgamma(m))           
####### Fraction as explained in the report     ############################################################
####### Go through all categories in this loop  ############################################################
  for (i in XY){
    
    dX <- as.numeric(tX[names(tX)== i])
    
    if (identical(dX,numeric(0))){
      dX <- 0
    }
    
    dY <- as.numeric(tY[names(tY)== i])
    
    if (identical(dY,numeric(0))){
      dY <- 0
    }
    
    lognum <- lognum + lgamma(dX + dY + 1) - (lgamma(dX + 1) + lgamma(dY + 1))
  }
  
#################### Inverse the result to make it the same as the equation in our report.   ############## 
  lognum <- -lognum 
 
  num <- exp(lognum)
  
  
  ##################### PRINT THE CONCLUSION of Bayesian Hypothesis Test ##################
  if (num < 1){
    cat("Bayesian Hypothesis Test suggests that the two data sets come from the same distribution.","\n")
  }
  else {cat("Bayesian Hypothesis Test suggests that the two data sets come from two distinct distributions.","\n")}
  
  
  ################# Print The Numeric Results #######################################################
  cat("The ratio is", num, "\n")              
  cat("The log ratio is", lognum, "\n")
}
