#############################################################
############ PRE PROCESSING  ################################
#############################################################

rm(list=ls())
setwd("C:/Rcode")
exacdata <- read.csv("C:/Rcode/exacerbation.csv",header=TRUE)
exacdata <- as.data.frame(exacdata)
exacdata <- exacdata[,c(2,3,4,5,6,18,19,20,21,22,23,24,27,28)]

colnames(exacdata)[c(9,10,11,12)] <- c("Total","Chest","Cough","Breath")

# Replace all missing values with its previous value 
missing <- c(which(is.na(exacdata$V12)))
for (a in missing){
exacdata$V12[a]<-exacdata$V12[a-1]
}

missing <- c(which(is.na(exacdata$V13)))
for (a in missing){
  exacdata$V13[a]<-exacdata$V13[a-1]
}

missing <- c(which(is.na(exacdata$V14)))
for (a in missing){
  exacdata$V14[a]<-exacdata$V14[a-1]
}

missing <- c(which(is.na(exacdata$Total)))
for (a in missing){
  exacdata$Total[a]<-exacdata$Total[a-1]
}

missing <- c(which(is.na(exacdata$Chest)))
for (a in missing){
  exacdata$Chest[a]<-exacdata$Chest[a-1]
}

missing <- c(which(is.na(exacdata$Cough)))
for (a in missing){
  exacdata$Cough[a]<-exacdata$Cough[a-1]
}

missing <- c(which(is.na(exacdata$Breath)))
for (a in missing){
  exacdata$Breath[a]<-exacdata$Breath[a-1]
}


###### CAUTION      #########################
exacdata[13377,14] <- 5
exacdata[13724,14] <- 1


############################################
# Now we set let all days that are classified by the clinicians as exacerbation labelled bi 1
# based on the given information of the start of the exacerbation and the duration of that exacerbation.  

exacday <- c(which(!is.na(exacdata$First.Day.of.Clinical.Exacerbation)))
for (b in exacday){
  d <- b 
  c <- exacdata$Studyday[b]
##  cat("Exacerbation day is", d, "\n")
##  print(c)
##  print(min(exacdata$SubjectTotalDaysData[b] + 1, c + exacdata$Clincial.Exacerbation_Duration_Days[b]))
  while (exacdata$Studyday[d] < c + exacdata$Clincial.Exacerbation_Duration_Days[b]) {
    exacdata$First.Day.of.Clinical.Exacerbation[d] <- 1 
    if (exacdata$Studyday[d] == exacdata$SubjectTotalDaysData[b]) break
##    print(exacdata$Studyday[d])
    d <- d + 1
  }
}


#######################################
# Rename it as "Exacerbation_Status_by_doctor", which will be used as a benchmark later on in the project for evaluation. 

colnames(exacdata)[13] <- "Exacerbation_Status_by_doctor"
count <- table(exacdata$Exacerbation_Status_by_doctor)
num_exacdays <- as.numeric(count)
exacdata <- exacdata[,-14]

write.csv(exacdata,file = "C:/Rcode/ExacData.csv")
