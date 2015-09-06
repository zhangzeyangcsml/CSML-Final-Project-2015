rm(list=ls())



##Step 1: Examine the DV
## Construct Null Model
Alldata <- read.csv("Alldata.csv",header=TRUE)
Alldata <- as.data.frame(Alldata)
null.model<-lme(sum~1,random=~1|Subject_ID,data=Alldata,
                na.action=na.omit, control=list(opt="optim"))
ss <- VarCorr(null.model)
## Calculate Interclass Correlation 
ss <- as.numeric(ss) 
ICC <- ss[1]/(ss[1]+ss[2])
cat("The Intercalss coefficient under Null Model is", ICC,"\n")



##Step 2: Model Time
model.2<-lme(sum~Studyday,random=~1|Subject_ID,data=Alldata,
             na.action=na.omit,control=list(opt="optim"))
summary(model.2)$tTable
## 1st Variation of Model 2
model.2b<-lme(sum~Studyday+I(Studyday^2),random=~1|Subject_ID,
              data=Alldata,na.action=na.omit,control=list(opt="optim"))
summary(model.2b)$tTable
## 2nd Variation of Model 2
model.2c<-lme(sum~poly(Studyday,2),random=~1|Subject_ID,
              data=Alldata,na.action=na.omit,control=list(opt="optim"))
summary(model.2c)$tTable



##Step 3: Model Slope Variability 
model.3<-update(model.2,random=~Studyday|Subject_ID)
anova(model.2,model.3)



##Step 4: Modelling Error Structures 

##Adding 1 lag autocorrelation term.
model.4a<-update(model.3,correlation=corAR1())
anova(model.3,model.4a)
summary(model.4a)

##Testing the change of Variance 
tapply(Alldata$sum,Alldata$Studyday,var,na.rm=T)
model.4b<-update(model.4a, weights=varExp(form=~Alldata$Studyday))
anova(model.4a,model.4b)



##Step 5:

##Turn Drug_A feature into 0 and Drug_B feature into 1
mm <- Alldata$Treatment_Group
aa <- as.numeric(summary(mm)[1]) ##Number of Drug_A data
bb <- as.numeric(summary(mm)[2]) ##Number of Drug_B data
col <- as.numeric(c(rep("0",aa),rep("1",bb)))
Alldata$Treatment_Group <- col

##
model.5<-lme(sum~Studyday+Treatment_Group,random=~Studyday|Subject_ID,
             correlation=corAR1(),na.action=na.omit,data=Alldata,
             control=list(opt="optim"))
round(summary(model.5)$tTable,dig=3)




## Step 6:
model.6<-lme(sum~Studyday*Treatment_Group,random=~Studyday|Subject_ID,
             correlation=corAR1(),na.action=na.omit,data=Alldata,
             control=list(opt="optim"))
round(summary(model.6)$tTable,dig=3)




























