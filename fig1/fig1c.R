ikkSim <-  read.csv("./simData/ikk.csv",header = F) # wt
ikkSim[,3] <-  NULL
names(ikkSim) <- c("Time","wt Low","wt High")
ikkExp <-  read.csv("../expdata/ikkExp.csv",header = F)

ikkKoSim <-  read.csv("./simData/ikkKoSim.csv",header = F)
ikkKoExp <-  read.csv("../expdata/ikkKoExp.csv",header = F)

pdf(file='fig1c.pdf', height=6, width=3.4, onefile=T, 
    family='Helvetica', paper='letter', pointsize=8)  


layout(matrix(c(1,2),2,1,byrow=T),respect = F)

ats = seq(0,120,30)

# wt IKK, sim 
plot(ikkSim[,1],ikkSim[,3],type="l",#main="IKK activity",
     lty=1,col="red",lwd=2,ylim=c(0,1),xlim=c(0,120),xlab="",ylab="",axes=T,frame.plot =TRUE)#Time (min)") 

Axis(side=1, labels=F)
Axis(side=2, labels=F)
#     ylab="Level (Normalized to Maximum)",font.lab = 2)
points(ikkExp[,3],ikkExp[,4],col="red",pch=15,cex=2)

# IKK kos
points(ikkKoSim[,1],ikkKoSim[,2],type="l",lty=2,col="red",lwd=2) #mko high
points(ikkKoSim[,7],ikkKoSim[,8],type="l",lty=4,col="red",lwd=2)  #tko high

points(ikkKoExp[,1],ikkKoExp[,2],col="red",pch=17,cex=2) #mko High
points(ikkKoExp[,7],ikkKoExp[,8],col="red",pch=16,cex=2) #tko high

# legend
#legend("topright", legend = c("wtExp","mkoExp","tkoExp","wtSim","mkoSim","tkoSim"),
#       pch =c(15,17,16,NA,NA,NA),lty=c(0,0,0,1,4,2),col=rep("black",6))


# wt IKK, sim 
plot(ikkSim[,1],ikkSim[,2],type="l",#main="IKK activity",
     lty=1,col="blue",lwd=2,ylim=c(0,.6),xlim=c(0,120),xlab="",ylab="",
     axes=T,frame.plot =TRUE,xat = ats)#Time (min)")
Axis(side=1, labels=FALSE)
Axis(side=2, labels=FALSE)
#     ylab="Level (Normalized to Maximum)",font.lab = 2)
points(ikkExp[,1],ikkExp[,2],col="blue",pch=15,cex=2)

# IKK kos
points(ikkKoSim[,3],ikkKoSim[,4],type="l",lty=2,col="blue",lwd=2) #mko
points(ikkKoSim[,5],ikkKoSim[,6],type="l",lty=4,col="blue",lwd=2) #tko

points(ikkKoExp[,3],ikkKoExp[,4],col="blue",pch=17,cex=2)
points(ikkKoExp[,5],ikkKoExp[,6],col="blue",pch=16,cex=2)

# legend
#legend("topright", legend = c("wtExp","mkoExp","tkoExp","wtSim","mkoSim","tkoSim"),
#       pch =c(15,17,16,NA,NA,NA),lty=c(0,0,0,1,4,2),col=rep("black",6))
dev.off()

system("open fig1c.pdf")
