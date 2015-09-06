rm(list=ls())
setwd("C:/Rcode")
#ExacData <- read.csv("ExacData.csv",header=TRUE)
#ExacData <- as.data.frame(ExacData)



######## Import the raw data ##################################################################
exacdata <- read.csv("C:/Rcode/exacerbation.csv",header=TRUE)
exacdata <- as.data.frame(exacdata)
exacdata <- exacdata[,c(2,3,4,5,6,18,19,20,21,22,23,24)]

######## Highlight the sub-domain and total scores  ###########################################
colnames(exacdata)[c(9,10,11,12)] <- c("Total","Chest","Cough","Breath") 
######## Remove the missing data ############################################################## 
exacdata <- subset(exacdata, !is.na(exacdata$Total))

GroupA <- subset(exacdata, exacdata$Treatment_Group == 'DRUG_A')
GroupB <- subset(exacdata, exacdata$Treatment_Group == 'DRUG_B')

################################################################################################
################### For Total Score ############################################################
################################################################################################

######### Take the day-to-day differences and grouped into A and B groups   ####################

Diff_A <- tapply(GroupA$Total, GroupA$Subject_ID, diff)
All_A <- NULL
for (i in Diff_A){
  All_A <- c(All_A, i)
}

Diff_B <- tapply(GroupB$Total, GroupB$Subject_ID, diff)
All_B <- NULL
for (i in Diff_B){
  All_B <- c(All_B, i)
}

qplot(All_A, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Total Score of Drug A Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("blue"), 
      alpha=I(.85),
      xlim=c(-25,25)) 

qplot(All_B, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Total Score of Drug B Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("red"), 
      alpha=I(.85),
      xlim=c(-25,25)) 


BHTest(All_A,All_B)





################################################################################################
################### For Chest Sub-domain ############################################################
################################################################################################

######### Take the day-to-day differences and grouped into A and B groups   ####################

Diff_A <- tapply(GroupA$Chest, GroupA$Subject_ID, diff)
Chest_A <- NULL
for (i in Diff_A){
  Chest_A <- c(Chest_A, i)
}

Diff_B <- tapply(GroupB$Chest, GroupB$Subject_ID, diff)
Chest_B <- NULL
for (i in Diff_B){
  Chest_B <- c(Chest_B, i)
}

###########################        Plot Histograms      ######################################
qplot(Chest_A, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Chest Score of Drug A Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("blue"), 
      alpha=I(.85),
      xlim=c(-9,9)) 

qplot(Chest_B, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Chest Score of Drug B Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("red"), 
      alpha=I(.85),
      xlim=c(-9,9)) 

###################### Apply Bayesian Hypothesis Test #######################################
BHTest(Chest_A,Chest_B)



################################################################################################
################### For Breath Sub-domain ############################################################
################################################################################################

######### Take the day-to-day differences and grouped into A and B groups   ####################

Diff_A <- tapply(GroupA$Breath, GroupA$Subject_ID, diff)
Breath_A <- NULL
for (i in Diff_A){
  Breath_A <- c(Breath_A, i)
}

Diff_B <- tapply(GroupB$Breath, GroupB$Subject_ID, diff)
Breath_B <- NULL
for (i in Diff_B){
  Breath_B <- c(Breath_B, i)
}

###########################        Plot Histograms      ######################################
qplot(Breath_A, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Breathless Score of Drug A Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("blue"), 
      alpha=I(.85),
      xlim=c(-10,10)) 

qplot(Breath_B, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Breathless Score of Drug B Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("red"), 
      alpha=I(.85),
      xlim=c(-10,10)) 

###################### Apply Bayesian Hypothesis Test #######################################
BHTest(Breath_A,Breath_B)




################################################################################################
################### For Cough Sub-domain ############################################################
################################################################################################

######### Take the day-to-day differences and grouped into A and B groups   ####################

Diff_A <- tapply(GroupA$Cough, GroupA$Subject_ID, diff)
Cough_A <- NULL
for (i in Diff_A){
  Cough_A <- c(Cough_A, i)
}

Diff_B <- tapply(GroupB$Cough, GroupB$Subject_ID, diff)
Cough_B <- NULL
for (i in Diff_B){
  Cough_B <- c(Cough_B, i)
}

###########################        Plot Histograms      ######################################
qplot(Cough_A, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Cough Score of Drug A Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("blue"), 
      alpha=I(.85),
      xlim=c(-8,8)) 

qplot(Cough_B, geom="histogram", binwidth = 1, 
      main = "Day-to-Day Change of Cough Score of Drug B Users",
      ylab = "No. of Occurrence", 
      xlab = "Change in Score ",  
      fill=I("red"), 
      alpha=I(.85),
      xlim=c(-8,8)) 

###################### Apply Bayesian Hypothesis Test #######################################
BHTest(Cough_A,Cough_B)



