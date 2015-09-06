setwd("C:/Rcode")
emission <- read.csv("emission.csv",header=TRUE)
###################################################################################################
###################################################################################################
###################################################################################################
############## Code to plot emission distributions ################################################
###################################################################################################
op = par(mar = c(4, 4, 4, 0))
col1 = hsv(h = 0.65, s = 0.7, v = 0.7, alpha = 0.5)
plot.new()
plot.window(xlim = c(1, 52), ylim = c(0, 0.3),)
axis(side = 1, pos = 0, at = seq(from = 1, to = 52, by = 2), col = "gray20", lwd.ticks = 0.25, cex.axis = 1, col.axis = "gray20", lwd = 1.5)
axis(side = 2, pos = 1, at = seq(from = 0, to = 0.3, by = 0.05), col = "gray20", las = 2, lwd.ticks = 0.5, cex.axis = 1, col.axis = "gray20", lwd = 1.5)
#plot   (emission$pre_value, emission$sta15, type = "n", xlab = "Time", ylab = "Distance")
polygon(emission$pre_value, emission$sta15, col = col1, border = col1)
title("Conditioning on"~italic(h)[t]~"=2", xlab=expression(italic(v)[t-1]),ylab=expression(italic(p)~(italic(v)[t])))
par(op)

op = par(mar = c(4, 4, 4, 0))
col1 = hsv(h = 0.65, s = 0.7, v = 0.7, alpha = 0.6)

plot.new()
plot.window(xlim = c(1, 52), ylim = c(0, 0.3),)
axis(side = 1, pos = 0, at = seq(from = 1, to = 52, by = 2), col = "gray20", lwd.ticks = 0.25, cex.axis = 1, col.axis = "gray20", lwd = 1.5)
axis(side = 2, pos = 1, at = seq(from = 0, to = 0.3, by = 0.05), col = "gray20", las = 2, lwd.ticks = 0.5, cex.axis = 1, col.axis = "gray20", lwd = 1.5)
plot   (emission$pre_value, emission$sta15, type = "h", xlab = "Time", ylab = "Distance")
#polygon(emission$pre_value, emission$inc10, col = col1, border = col1)
title("Conditioning on"~italic(h)[t]~"=2", xlab=expression(italic(v)[t-1]),ylab=expression(italic(p)~(italic(v)[t])))
par(op)

#distribs = data.frame(values = c(emission$sta15),type = gl(n = 1, k = 52))
#ggplot(data = distribs, aes(x = values, group = type)) + geom_density(aes(fill = type, color = type), alpha = 0.5)

#qplot(pre_value, sta15, data=emission,color= col1,geom="line",xlim = c(1, 52), ylim = c(0, 0.5))

barplot(emission$sta15)

bp <- ggplot(data=emission, aes(x=pre_value, y=sta15)) +geom_bar(fill=col2, stat="identity")
#title("Conditioning on"~italic(h)[t]~"=2", xlab=expression("Value of "~italic(v)[t-1]),ylab=expression("Probability of"italic(v)[t]))
bp <- bp + expand_limits(y=c(0,0.2))
bp <- bp + ggtitle("Conditioning on"~italic(h)[t]~"=2,"~italic(v)[t-1]~"=15")
bp <- bp + xlab(expression("Value of "~italic(v)[t]))
bp <- bp + ylab(expression("Probability of"~italic(v)[t]))
bp

col2 = hsv(h = 0.01, s = 0.8, v = 0.7, alpha = 0.6)
bp <- ggplot(data=emission, aes(x=pre_value, y=inc10)) +geom_bar(fill=col2, stat="identity")
#title("Conditioning on"~italic(h)[t]~"=2", xlab=expression("Value of "~italic(v)[t-1]),ylab=expression("Probability of"italic(v)[t]))
bp <- bp + expand_limits(y=c(0,0.2))
bp <- bp + ggtitle("Conditioning on"~italic(h)[t]~"=3,"~italic(v)[t-1]~"=10")
bp <- bp + xlab(expression("Value of "~italic(v)[t]))
bp <- bp + ylab(expression("Probability of"~italic(v)[t]))
bp



col3 = hsv(h = 0.34, s = 0.8, v = 0.7, alpha = 0.6)
bp <- ggplot(data=emission, aes(x=pre_value, y=dec_35)) +geom_density(fill=c(col3), stat="identity")
#title("Conditioning on"~italic(h)[t]~"=2", xlab=expression("Value of "~italic(v)[t-1]),ylab=expression("Probability of"italic(v)[t]))
bp <- bp + expand_limits(y=c(0,0.2))
bp <- bp + ggtitle("Conditioning on"~italic(h)[t]~"=1,"~italic(v)[t-1]~"=35")
bp <- bp + xlab(expression("Value of "~italic(v)[t]))
bp <- bp + ylab(expression("Probability of"~italic(v)[t]))
bp

bp <- ggplot(data=emission, aes(x=pre_value, y=c(dec_35,inc10))) +geom_density(fill=col3, stat="identity")
bp <- bp + expand_limits(y=c(0,0.2))
bp <- bp + ggtitle("Conditioning on"~italic(h)[t]~"=1,"~italic(v)[t-1]~"=35")
bp <- bp + xlab(expression("Value of "~italic(v)[t]))
bp <- bp + ylab(expression("Probability of"~italic(v)[t]))
bp






###########################################################################################################
########################## The stacked bar plots of the emission distributions ############################
###########################################################################################################

distribs <- data.frame(values = c(emission$sta20, emission$inc20, emission$dec_20),type = gl(n = 3, k = 52))

# plot
# ggplot(data = distribs, aes(x = values, group = type)) + geom_bar(aes(fill = type, color = type), alpha = 0.5)
bp <- ggplot(data=emission, aes(x=pre_value, y=dec_35)) +geom_bar(fill=col3, stat="identity") 
bp

togt <- emission[,c(1,5,6,7)]

sta <- cbind(togt[,c(1,2)],rep("stable (h=2)",52))
inc <- cbind(togt[,c(1,3)],rep("increase (h=3)",52))
dec <- cbind(togt[,c(1,4)],rep("decrease (h=1)",52))

colnames(sta)[2] <- "prob"
colnames(sta)[3] <- "state"
colnames(inc)[2] <- "prob"
colnames(inc)[3] <- "state"
colnames(dec)[2] <- "prob"
colnames(dec)[3] <- "state"


newnew <- rbind(sta,inc,dec)

# The palette with black:
cbbPalette <- c(col1,col2,col3)

# To use for fills, add
scale_fill_manual(values=cbPalette)

bp <- ggplot(data=newnew, aes(x=pre_value, y=prob,fill=state)) +geom_bar(stat="identity")+scale_fill_manual(values=cbbPalette) #+ theme_bw()
bp <- bp + expand_limits(y=c(0,0.2))
bp <- bp + ggtitle("Conditioning on"~italic(v)[t-1]~"=20")
bp <- bp + xlab(expression("Value of "~italic(v)[t]))
bp <- bp + ylab(expression("Probability of"~italic(v)[t]))
bp

pb <- ggplot(data = newnew, aes(x=pre_value, y=prob,fill=state)) + geom_bar(stat="identity", position = "fill") +scale_fill_manual(values=cbbPalette)+ scale_y_continuous(labels = percent_format())
pb <- pb + expand_limits(y=c(0,0.2))
pb <- pb + ggtitle("Conditioning on"~italic(v)[t-1]~"=20")
pb <- pb + xlab(expression("Value of "~italic(v)[t]))
pb <- pb + ylab(expression("Relative Probability of"~italic(v)[t]))
pb



sub144 <- read.csv("sub144.csv",header=TRUE)
for (i in 1:196){
  if (sub144[i,2] == 2)
    sub144[i,2] <- "Stable"
  else if (sub144[i,2] == 1)
    sub144[i,2] <- "Decrease"
  else
    sub144[i,2] <- "Increase"
}


colnames(sub144)[2] <- "State"
sub144[,2] <- factor(sub144[,2])

bb <- ggplot(data=sub144, aes(x=Studyday, y=State, group=1)) + geom_line() 
bb <- bb + ggtitle("Basic Model: Subject 144")
bb

sub144$State <- factor(sub144$State, levels = c("Decrease", "Stable", "Increase"))




#################################################################################################
#################################################################################################
#########   Plot Health Scores and the exacerbations detected by clinicians and HMM    ##########
#################################################################################################
#################################################################################################


doctor_144 <- read.csv("doctor_144.csv",header=TRUE)


col1 = hsv(h = 0.68, s = 0.9, v = 0.8, alpha = 1)
col1_minus = hsv(h = 0.7, s = 0.5, v = 0.7, alpha = 1)
col2 = hsv(h = 0.01, s = 0.8, v = 0.7, alpha = 0.6)
col3 = hsv(h = 0.34, s = 0.8, v = 0.7, alpha = 0.6)

# The palette with black:
cbPalette <- c(col3,col2)

# To use for fills, add
scale_fill_manual(values=cbPalette)


colnames(doctor_144)[3] <- "Nature"
cc <- ggplot(data= doctor_144, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("red", col1))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid"))  + theme(axis.title.x = element_blank())
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Clinical Exacerbations of Subject 144")
cc <- cc + ylab("Score")
cc

colgreen = hsv(h = 0.38, s = 1, v = 0.9, alpha = 1)

model3_144 <- read.csv("model3_144.csv",header=TRUE)
cc <- ggplot(data= model3_144, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("black", col1))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid"))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Detected Exacerbations of Subject 144 by Model 3")
cc <- cc + ylab("Score")
cc


model4_144 <- read.csv("model4_144.csv",header=TRUE)
cc <- ggplot(data= model4_144, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("black", col1))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid")) + theme(axis.title.x = element_blank())
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Detected Exacerbations of Subject 144 by Model 4")
cc <- cc + ylab("Score")
cc


model5_144 <- read.csv("model5_144.csv",header=TRUE)
cc <- ggplot(data= model5_144, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("black", col1))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid"))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Detected Exacerbations of Subject 144 by Model 5")
cc <- cc + ylab("Score")
cc



doctor_98 <- read.csv("doctor_98.csv",header=TRUE)
cc <- ggplot(data= doctor_98, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("red", "blue"))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid"))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Clinical Exacerbation of Subject 98")
cc <- cc + ylab("Score")
cc

model4_98 <- read.csv("model4_98.csv",header=TRUE)
cc <- ggplot(data= model4_98, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("black", "blue"))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid"))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Detected Exacerbation of Subject 98 by Model 4")
cc <- cc + ylab("Score")
cc


model5_98 <- read.csv("model5_98.csv",header=TRUE)
cc <- ggplot(data= model5_98, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype=Nature)) + geom_line() +scale_color_manual(name="Line Nature", values=c("black", "blue"))+ scale_linetype_manual(name="Line Nature", values = c("longdash","solid"))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Detected Exacerbation of Subject 98 by Model 5")
cc <- cc + ylab("Score")
cc

######################################################################################################
############################## PLOT FOR INTRODUCTION PART ############################################
######################################################################################################


subject_11 <- read.csv("subject11.csv",header=TRUE)
cc <- ggplot(data= subject_11, aes(x=Studyday, y=Value, group=Nature, colour=Nature, linetype= Nature)) +  geom_line(aes(linetype= Nature),size = 0.9) +scale_color_manual(name="Line Representation", values=c("green", "red", "black","blue"))+ scale_linetype_manual(name="Line Representation", values = c("solid","solid","solid","solid"))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Health Scores of Subject 11")
cc <- cc + ylab("Score")
cc <- cc + xlab("Days in Clinical Trails")
cc


df<-data.frame(xmin=140,
               xmax=155,
               ymin=-Inf,
               ymax=Inf)

subject27 <- read.csv("subject27.csv",header=TRUE)
cc <- ggplot(data = subject27, aes(x= Studyday, y=Score, group=1)) + geom_line(colour = "blue", size=1) + geom_rect(data=df,aes(xmin=xmin,ymin=ymin,xmax=xmax,ymax=ymax, fill="red"),alpha=0.35,inherit.aes=FALSE) + scale_fill_discrete(labels = "Suspected \n Exacerbation",guide = guide_legend(title = NULL, direction = "horizontal",
                                                                                                                                                                                                                                                              label.position="bottom", label.hjust = 0.5, label.vjust = 0.5,
                                                                                                                                                                                                                                                              label.theme = element_text(angle = 0))) 
cc <- cc + expand_limits(y=c(0,25))
cc <- cc + scale_x_continuous(breaks = seq(0, 200, by = 10))
cc <- cc + ggtitle("Total Health Score of Subject 27")
cc <- cc + ylab("Score")
cc <- cc + xlab("Days in Clinical Trails")
cc



######################################################################################################
######################################################################################################
###############################   Precision Recall Curve Plot    #####################################
######################################################################################################
######################################################################################################



Point <- c(0.10,0.12,0.14,0.16,0.18,0.20)
Recall <- c(0.4932,0.5092, 0.5287, 0.5387, 0.5512, 0.5742)
Precision <- c(0.0906, 0.0884, 0.0866, 0.0830, 0.0808, 0.0804)
plot.new()



col1 = hsv(h = 0.68, s = 0.9, v = 0.8, alpha = 1)
col1_minus = hsv(h = 0.7, s = 0.5, v = 0.7, alpha = 1)
prcurve <- data.frame(Recall, Precision)

prerecurve <- ggplot(prcurve, aes(x=Recall, y=Precision,label=expression(beta)) + geom_line(aes(group=1), colour=col1) + geom_point(size=2.5, colour=col1_minus)  + geom_text(hjust=-0.25, vjust=0)
prerecurve <- prerecurve + expand_limits(y=c(0.079,0.092))
prerecurve <- prerecurve + expand_limits(x=c(0.48,0.6))
prerecurve <- prerecurve + ggtitle("Precision-Recall Curve on various values of"~alpha)
prerecurve
