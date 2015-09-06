BestPara <- read.csv("BestPara.csv",header=TRUE)  ###### read the predicted results for the optimum parameters at pi=0.8 
BestPara <- read.csv("BestPara2.csv",header=TRUE)  ###### read the predicted results for the optimum parameters at pi=0.85 
# BestParaA <- subset(BestPara, Treatment_Group == "DRUG_A")
# BestParaB <- subset(BestPara, Treatment_Group == "DRUG_B")


# Extract the starting day data of each patient 
Infosum <- subset(BestPara, Studyday == 1)
Infosum <- Infosum[,c(2,3,4,5)]

#Infosum <- cbind(Infosum,rep(0,nrow(Infosum))
#colnames(Infosum)[5] <- "numExa"




#################################################################################################
########### Count the number of exacerbations for each patient###################################
#################################################################################################

freqExac <- NULL
for (i in Infosum$Subject_ID){
  aa <- 0
  Individual <- subset(BestPara, Subject_ID == i)
  for (j in 1:(nrow(Individual)-1)){
    if (Individual$Exacerbation_Status_pred[j] == 2 & Individual$Exacerbation_Status_pred[j+1] == 3)
    aa <- aa + 1  
  }
  freqExac <- c(freqExac,aa)
}

freqExac <- t(freqExac)
freqExac <- t(freqExac)

##### Combined counted number of exacerbations with the previously extracted first day data 
Infosum <- cbind(Infosum,freqExac)
##Infosum$Treatment_Group <- c(rep(0,83),rep(1,94))   ############### Change Treatment Group A to 1, B to 0########



######### Now calculate the average Exacerbation Frequency for each number historical exacerbation ###################
table(freqExac)
table(Infosum$Historical_Exacerbations)

# Create a vector of number of historical exacerbation up to 5
NumHis <- c(2,3,4,5)        
# Count the averages exacerbations for patients of 1,2,3,4 and 5 historical exacerbations respectively
AvgfreqExac <- NULL     
avg <- Null
for (m in NumHis){
  HisExac <- subset(Infosum, Historical_Exacerbations==m)
  avg <- mean(HisExac$freqExac)
  AvgfreqExac <- c(AvgfreqExac,avg)
}
# Compute the averages for patients with equal or more than 6 historical exacerbations, and combine the data
HisExac <- subset(Infosum, Historical_Exacerbations > 5)
avg <- mean(HisExac$freqExac)
AvgfreqExac <- c(AvgfreqExac,avg)
AvgfreqExac

######### Plot the bar plots of Average Exacerbation VS Historical Exacerbation      ##########################
NumHis <- c(2,3,4,5,6)
hisexac <- as.data.frame(cbind(NumHis,AvgfreqExac))

ehplot <-ggplot(hisexac, aes(x=NumHis, y=AvgfreqExac)) +geom_bar(fill="blue", stat="identity")
#ehplot <- ehplot + xlab(expression("Number of Historical Exacerbation "))
ehplot <- ehplot + ylab(expression("New Frequency of Exacerbation"))  
ehplot <- ehplot + scale_x_discrete("Number of Historical Exacerbation ", breaks=c(2,3,4,5,6),labels=c("2","3","4","5","6 or more"))
ehplot <- ehplot + ggtitle("Average Number of Exacerbations (" ~pi~ "=0.85)")
ehplot <- ehplot + expand_limits(y=c(0,9))
#ehplot <- ehplot + expand_limits(y=c(0,10))
ehplot



plot <- ggplot(data=Infosum, aes(x=freqExac, group=Treatment_Group)) +geom_density( aes( colour=Treatment_Group, fill=Treatment_Group), alpha=0.4) + scale_fill_manual(values=c("red", "blue"))+ scale_colour_manual(values=c("red", "blue"))
plot <- plot + expand_limits(x=c(0,20))
plot






#################################################################################################################
#################################################################################################################
################ Create a column whether the patient is a frequent exacerbator ##################################
#################################################################################################################
################################################################################################################

for (i in 1:177){
  if (Infosum$Historical_Exacerbations[i]==2){
    Infosum$Historical_Exacerbations[i] <- "Non-Freq Exacerbator"
  }
  else {Infosum$Historical_Exacerbations[i] <- "Freq Exacerbator"}
}



################################################################################################################
################################################################################################################
###################################### GLM --- POISSON REGRESSION ##############################################
################################################################################################################
################################################################################################################

Infosum$Historical_Exacerbations <- factor(Infosum$Historical_Exacerbations)
Infosum$Treatment_Group <- factor(Infosum$Treatment_Group)


cohort_1 <- glm(freqExac ~ Historical_Exacerbations*Treatment_Group + Historical_Exacerbations + Treatment_Group + offset(log(SubjectTotalDaysData)), family=poisson(link="log"), data=Infosum)
summary(cohort_1)


cohort_2 <- glm(freqExac ~ Historical_Exacerbations + Treatment_Group + offset(log(SubjectTotalDaysData)), family=poisson(link="log"), data=Infosum)
summary(cohort_2)
anova(cohort_1, cohort_2, test="Chisq")

cohort_3 <- glm(freqExac ~ Treatment_Group + offset(log(SubjectTotalDaysData)), family=poisson(link="log"), data=Infosum)
summary(cohort_3)
anova(cohort_1, cohort_3, test="Chisq")

cohort_4 <- glm(freqExac ~ Historical_Exacerbations + offset(log(SubjectTotalDaysData)), family=poisson(link="log"), data=Infosum)
summary(cohort_4)
anova(cohort_1, cohort_4, test="Chisq")

#########################################################################################################
#########################################################################################################
############################  Method X   ################################################################
#########################################################################################################
#########################################################################################################
############### We now compute the Recall/Precision and F-measure of Method X############################
#########################################################################################################

EXACTPRO <- read.table("EXACT-PRO Exacerbation.tab", sep="\t", header = TRUE)
# check <- subset(EXACTPRO, EXACTPRO$exact_event==1)
# check <- check[,c(1,2,3,4,5,6,29,30,31,32,33,34)]

write.csv(EXACTPRO,file = "C:/Rcode/EXACTPRO.csv")

####### Sort in Excel , and import again 
ExacPro <- read.csv("EXACTPRO.csv", header=TRUE)


############Read the ExacData produced by the code in the page "Pre-Process"#############################

ExacData <- read.csv("ExacData.csv", header=TRUE)
ExacPro <- ExacPro[,c(29:34)]
ExacDataPro <- cbind(ExacData,ExacPro)

recovery1 <- c(which(ExacDataPro$recovery==1))
recovery23 <- c(which(ExacDataPro$recovery== 2 | ExacDataPro$recovery== 3 ))

ExacDataPro <- as.data.frame(ExacDataPro)

for (b in recovery1){
  d <- b 
  ExacDataPro$exact_event[d:(d+ExacDataPro$duration[b])] <- 1 
  }


for (c in recovery23){
  f <- c
  ExacDataPro$exact_event[f:(f+ExacDataPro$duration[c] + 1)] <- 1 
}

counta <- c(which(ExacDataPro$exact_event==1 & ExacDataPro$Exacerbation_Status_by_doctor==1))
countc <- c(which(ExacDataPro$Exacerbation_Status_by_doctor==1))
countb <- c(which(ExacDataPro$exact_event==1))

Recall <- length(counta)/length(countc)
Precision <- length(counta)/length(countb)
Fscore <- 1/(0.8*(1/Recall)+0.2*(1/Precision)) 



