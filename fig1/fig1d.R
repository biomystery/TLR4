#library("grDevices")
NFSim <-  read.csv("./simData/nfIRF.csv",header= F) # wt
NFSim <-  t(NFSim)
head(NFSim)
NFExp <-  read.csv("../expdata/NFIRFExp.csv",header= F)
head(NFExp)
dim(NFSim)

pdf(file="fig1d.pdf", height=6, width=6, onefile=TRUE, family="Helvetica", paper="letter", pointsize=12)  

# wt IKK, sim
par(mfrow=c(2,1))
par(mar=c(2,4,4,2)+0.1)
#nfkb high
plot(0:240,NFSim[,4],type="l",#main=expression(bold(paste("NF-",kappa,"Bn activity"))),
     lty=1,col="red",lwd=2,ylim=c(0,1.1),xlab="",ylab="",
     axes=FALSE,frame.plot =TRUE)#"Time (min)",
     #ylab="Level (Normalized to Maximum)",font.lab = 2,xaxp=c(0,240,8))
Axis(side=1,at=seq(0,240,30),labels=FALSE)
Axis(side=2, labels=FALSE)
points(0:240,NFSim[,2],type="l",lty=1,col="blue",lwd=2) #nkfb low 
points(NFExp[,3],NFExp[,4],col="blue",pch=15,cex=2) 
points(NFExp[,7],NFExp[,8],col="red",pch=15,cex=2)
#legend("topright", legend = c("wt Exp","wt Sim"),
#       pch =c(15,NA),lty=c(0,1),col=rep("black",6))
par(mar=c(5,4,2,2)+0.1)
plot(0:240,NFSim[,3],type="l",#main="IRF3np activity",
     lty=1,col="red",lwd=2,ylim=c(0,1.1),xlab="",#"Time (min)",
     ylab="",axes=FALSE,frame.plot =TRUE)#"Level (Normalized to Maximum)",font.lab = 2,xaxp=c(0,240,8))
Axis(side=1,at=seq(0,240,30),labels=FALSE)
Axis(side=2, labels=FALSE)

points(0:240,NFSim[,1],type="l",lty=1,col="blue",lwd=2)
points(NFExp[,1],NFExp[,2],col="blue",pch=15,cex=2)
points(NFExp[,5],NFExp[,6],col="red",pch=15,cex=2)
#legend("topright", legend = c("wt Exp","wt Sim"),
#       pch =c(15,NA),lty=c(0,1),col=rep("black",6))

# legend
dev.off()

system("open fig1d.pdf")
