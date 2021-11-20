# load Boston dataset
library(MASS)
attach(Boston)
X1 <- Boston$lstat
s1 <- seq(1,50,0.1) #sequence used to find threshold value of attribute1
X2 <- Boston$rm
s2 <- seq(1,10,0.1) #sequence used to find threshold value of attribute2
X <- cbind(X1, X2)
Y <- Boston$medv
# split into training and test set
set.seed(1014)
train <- sample(nrow(Boston),nrow(Boston)/2)
trainX <- X[train,]
trainY <- as.matrix(Y[train])
testX <- X[-train,]
testY <- as.matrix(Y[-train])

# fit DecisionStump on train set
# Implement Decision Stumps
DS <- function(trainX, trainY, s1, s2){
  RSS <- matrix(Inf,ncol(trainX),max(length(s1),length(s2)))
  for (i in 1:ncol(trainX)) {
    if (i == 1)  s <- s1
    else s <- s2
    for (j in 1:length(s)) {
      threshold <- trainX[,i]<s[j]
      split_1 <- trainY[threshold]
      split_2 <- trainY[!threshold]
      RSS[i,j] <- sum((split_1-mean(split_1))^2)+sum((split_2-mean(split_2))^2)
    }
    # get the s with minimum RSS
  }
  mins <- which(RSS==min(RSS),arr.ind=TRUE)
  if (mins[1,1]==1) {
    threshold <- trainX[,1]<s1[mins[1,2]]
    res <- c(as.integer(mins[1,1]),s1[mins[1,2]],mean(trainY[threshold]),mean(trainY[!threshold]))
  }
  if (mins[1,1]==2){
    threshold <- trainX[,2]<s2[mins[1,2]]
    res <- c(as.integer(mins[1,1]),s2[mins[1,2]],mean(trainY[threshold]),mean(trainY[!threshold]))
  }
  # return the threshold with 2 values
  return(res)
}

predDS <- function(fb, testX){
  pred <- matrix(rep(fb[4],nrow(testX)),nrow(testX),1)
  if (fb[1]==1) {
    pred[testX[,1]<fb[2],] <- fb[3]
  }
  if (fb[1]==2) {
    pred[testX[,2]<fb[2],] <- fb[3]
  }
  return(pred)
}

fb <- DS(trainX,trainY,s1,s2)
pred <- predDS(fb,testX)
testMSE <- mean((pred-testY)^2)
testMSE

# fit BoostingDecisionStump on train set
BDS <- function(trainX, trainY, s1, s2, learning_rate, B){
 
  r <- trainY
  fb <- c()
  fbM <- matrix(,B,4)
  for (b in 1:B) {
    fb <- DS(trainX, r, s1, s2)
    fbM[b,] <- fb
    if (fb[1]==1) {
      threshold <- trainX[,1]<fb[2]
    }
    if (fb[1]==2) {
      threshold <- trainX[,2]<fb[2]
    }
    r[threshold] <- r[threshold]-learning_rate*fb[3]
    r[!threshold] <- r[!threshold]-learning_rate*fb[4]
  }
  return(fbM)
}

predBDS <- function(fb, testX, learning_rate, B){
  pred <- matrix(0,nrow(testX),1)
  for (b in 1:B) {
    pred <- pred+learning_rate*predDS(fb[b,],testX)
  }
  return(pred)
}
learning_rate <- 0.01
B <- 1000
fb <- BDS(trainX,trainY,s1,s2,learning_rate,B)
pred <- predBDS(fb,testX,learning_rate,B)
testMSE <- mean((pred-testY)^2)
testMSE

# plot testMSE for a fixed value of learning_rate as a function of B=200:2000 by 200
BDSforFunctionOfB <- function(trainX,trainY,testX,testY,s1,s2,learning_rate,BSequence){
  testMSE <- c()
  for (i in 1:length(BSequence)) {
    B <- BSequence[i]
    fb <- BDS(trainX,trainY,s1,s2,learning_rate,B)
    pred <- predBDS(fb,testX,learning_rate,B)
    testMSE[i] <- mean((pred-testY)^2)
  }
  plot(BSequence,testMSE)
}
BSequence <- seq(200,2000,200)
BDSforFunctionOfB(trainX,trainY,testX,testY,s1,s2,learning_rate,BSequence)