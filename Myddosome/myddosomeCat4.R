# Correct directory and clear 
#setwd("~/Dropbox/R/ODE/")
rm(list=ls(all=T))

# library 
library(rootSolve)
library(deSolve)

# model ODE 
mdModel <- function (Time, State, Pars) {
  with(as.list(c(State, Pars)),{
    dM    <- -2*k1*C*M + 2*k_1*M2C + 6*kd*M6
    dC    <-  k_1*M2C-k1*C*M + 3*k4*M6C3 
    dM2C  <-  k1*C*M - k_1*M2C- 2*k2*M2C^2- k3*M2C*M4C2
    dM4C2 <-  k2*M2C^2- k3*M2C*M4C2
    dM6C3 <-  k3*M4C2*M2C  - k4*M6C3
    dM6   <-  k4*M6C3 - kd*M6
    return(list(c(dM,dC,dM2C,dM4C2,dM6C3,dM6)))
  })
}

# prameters 
getPar <- function(kf=1,kb=0.1){ # bind and unbind
  return(data.frame(k1=kf,k_1=kb,k2=kf,k3=kf,k4=kf,kd=kb))
}

# init values
getInit <-function(m0=1,c0=1){
  c(M=m0,C=c0,M2C=0,M4C2=0,M6C3=0,M6=0)
}

# solve the steady state when fix concentration of TL 
runSteady<-function(kf=1,m0=1,c0=1){
  yinit <- getInit(m0=m0,c0=c0)
  pars=getPar(kf=kf)
  ssRun <- runsteady(y = yinit, func = mdModel, parms = pars,
                     stol=1e-10,rtol=1e-10,atol=1e-10)
  if(attr(ssRun,'steady')== T){
    return(ssRun$y[['M6']])
  }else{
    print(yinit[['M']])
    return()
    }
}

# run model 
runModel <- function(m0=1,c0=1){
  ##generated Pars & init
  yinit <- getInit(m0=m0,c0=c0)
  pars=getPar()
  times <- seq(0, 180, by = .1)
  out   <- ode(yinit, times, mdModel, pars)
  return(out)
}



# sample the c0 from 0.1 to 10 
#C0seq <- seq(-4,log10(4),length.out=50)
C0seq <- c(seq(0.2,10,by=0.2))
C0seq2 <- c(seq(0.02,0.2,by=0.02))
C0seq <- c(C0seq2,C0seq)

SSs <- C0seq*0
m0 <- 10

for(i in 1:length(C0seq)){
    SSs[i] = runSteady(m0=m0,c0=C0seq[i])
} 
par(mfrow=c(1,1))
plot(C0seq/m0,6*SSs/m0,xlab='C0/M0',ylab='M6/M0',pch=21,cex=1.5)

####
dose <- matrix(rep(C0seq,50),50)
for(j in 1:50){
  print(j)
  kf = 0.02*j
  for(i in 1:length(C0seq)){
    SSs[i] = runSteady(kf=kf,m0=m0,c0=C0seq[i])
  } 
  dose[j,]=SSs
}
dose <-dose*6/m0
dose <-t(dose)
library(lattice)
pdf(file='contour.pdf', height=6, width=6, onefile=TRUE, family='Helvetica', paper='letter', pointsize=12)  
par(mfrow=c(1,1))
contourplot(dose,region=T,cut=100,aspect="fill",
            #at=seq(0,0.8,length.out=100),
            column.values = (1:50)*0.2,
            row.values= C0seq/m0,
            pretty=T,xlim=c(0.02,1),ylim=c(0.2,10),
            labels=T,contour=F,
            ylab='kf/kb',xlab='C0/M0',log='y')
dev.off()
system("open contour.pdf")
#############Hill fitting 
# log transformation
# log(ym/(1-ym)) = n log(x) - n log(km)
# ym = y/vm

logHill <- function(vm=1,x,y){
  xLog  <- log10(x)
  ym    <- y/vm
  yLog  <- log10(ym/(1-ym)) 
  data.frame(xLog=xLog,yLog=yLog)
}


# hill function 
hill <- function(x,vm,km,n){
  vm*(x^n/(x^n+km))
}

obj <- function(par){
  vm <- par[1]
  km <- par[2]
  n <-  par[3]
  sim <- hill(ds$x,vm,km,n)
  sum((sim-ds$y)^2)
}

ds <-data.frame(x=C0seq,y=SSs)
#fit.2 <- nlm(y ~ hill(x,vm,km,n),data =ds,
#             start =list(vm =1.5,km=0.1,n=3),trac = T)

fit.2 <- nlminb(c(1.5,0.1,3),obj, lower=0,upper =Inf)

par <- fit.2$par
vm <- par[1]
km <- par[2]
n <-  par[3]
sim <- hill(ds$x,vm,km,n)

lines(ds$x/m0,6*sim/m0,col='red',lwd=4)
names(par)<-c('vm','km','n')

###

n <- (1:50)*0
rmsd <- n
for(i in 1:50){
  print(i)
  ds <-data.frame(x=C0seq,y=dose[,i])
  # sort ds
  #ds <-data.frame(x=ds$x[order(ds$x)],y=ds$y[order(ds$x)])
  fit.2 <- nlminb(c(1.5,0.1,3),obj, lower=0,upper =Inf)
  par <- fit.2$par
  rmsd[i]<-fit.2$objective
  vm <- par[1]
  km <- par[2]
  n[i] <-  par[3]
  sim <- hill(ds$x,vm,km,n[i])
  #plot(ds$x/m0,ds$y,xlim=c(0.02,0.95))
  #points(ds$x/m0,ds$y)
  #lines(ds$x/m0,sim,col='red')
}
plot((1:50)*0.2,rmsd,type='o',xlab='kf/kb')
plot((1:50)*0.2,n,type='l',xlab='kf/kb',log='x')

x<-(1:50)*0.2
x[7]<-NA
n[7]<-NA
rmsd[7]<-NA
x<-na.omit(x)
n<-na.omit(n)


pdf(file='hill_n.pdf', height=6, width=6, onefile=TRUE, family='Helvetica', paper='letter', pointsize=12)  
plot(x,n,type='l',lwd=2,log='x',xlab='kf/kb',ylab='Hill Coefficient')
dev.off()
system("open hill_n.pdf")
write.csv(dose,file='dose.csv')
write.csv(data.frame(x=x,n=n),file='fit.csv')
