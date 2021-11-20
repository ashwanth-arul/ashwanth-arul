nci.data <- read.table('nci.data')
nci.data <- t(nci.data)
nci.label <- read.table('label.txt')
K <- nrow(unique(nci.label))                #here K = 14

distance_calculator <- function(X, CluDistMat, Clu, method){
  # total number of Clu
  CluNum <- length(Clu)
  # value of lasted Clu
  newClu <- Clu[[length(Clu)]]
  # checks method if single
  if(method == 'single'){
    # loop all cluster except lasted one
    for (i in c(1:(CluNum-1))[-newClu]) {
      tmp <- c()
      tmp.c <- 1
      # loop content of cluster
      for (j in Clu[[i]]) {
        # loop content of lasted cluster
        for (k in newClu) {
          tmp[tmp.c] <- CluDistMat[j,k]
          tmp.c <- tmp.c+1
        }
      }
      # find the minimum distance between two cluster
      CluDistMat[CluNum,i] <- min(tmp)
      CluDistMat[i,CluNum] <- min(tmp)
    }
    return(CluDistMat)
  }
  if(method == 'complete'){
    for (i in c(1:(CluNum-1))[-newClu]) {
      tmp <- c()
      tmp.c <- 1
      for (j in Clu[[i]]) {
        for (k in newClu) {
          tmp[tmp.c] <- CluDistMat[j,k]
          tmp.c <- tmp.c+1
        }
      }
      # find the maximum distance between two cluster
      CluDistMat[CluNum,i] <- max(tmp)
      CluDistMat[i,CluNum] <- max(tmp)
    }
    return(CluDistMat)
  }
  if(method == 'average'){
    for (i in c(1:(CluNum-1))[-newClu]) {
      tmp <- c()
      tmp.c <- 1
      for (j in Clu[[i]]) {
        for (k in newClu) {
          tmp[tmp.c] <- CluDistMat[j,k]
          tmp.c <- tmp.c+1
        }
      }
      # find the maximum distance between two cluster
      CluDistMat[CluNum,i] <- sum(tmp)/(length(Clu[[i]])*length(newClu))
      CluDistMat[i,CluNum] <- sum(tmp)/(length(Clu[[i]])*length(newClu))
    }
    return(CluDistMat)
  }
  if(method == 'centroid'){
    for (i in c(1:(CluNum-1))[-newClu]) {
      
      # find the maximum distance between two cluster
      CluDistMat[CluNum,i] <- abs(mean(X[Clu[[i]],])-mean(X[newClu,]))
      CluDistMat[i,CluNum] <- abs(mean(X[Clu[[i]],])-mean(X[newClu,]))
    }
    return(CluDistMat)
  }
}

# applying hierarchical agglomerative clustering from the first principle
hacluster <- function(X, K, method){
  # create clusters distance matrix and making zero to be NA
  XDistMat <- as.matrix(dist(X))
  XDistMat[XDistMat==0] <- NA
  
  # creates a list Clu and store all end-nodes of every cluster
  Clu <- list()
  for (item in 1:nrow(X)) {Clu[[item]] <- item}
  # create vector store the status if the node has been referred by upper node 
  status <- c(rep(1,nrow(X)))
  # create initial cluster distance matrix
  CluDistMat <- matrix(NA,2*nrow(X)-K,2*nrow(X)-K)
  CluDistMat[1:nrow(XDistMat),1:ncol(XDistMat)] <- XDistMat
  fmCluDistMat <- CluDistMat
  for (item in 1:(nrow(X)-K)) {
    # find the subscript of minimum cluster distance
    minClu <- which(fmCluDistMat==min(fmCluDistMat, na.rm=TRUE), arr.ind=T)
   
     # update cluster list
    Clu[[nrow(X)+item]] <- c(Clu[[minClu[nrow(minClu),1]]],Clu[[minClu[nrow(minClu),2]]])  
    
    # update the status
    status[minClu[nrow(minClu),]] <- 0
    status[nrow(X)+item] <- 1
    
    # call distance_calculator function, merge clusters and update ClusterDistanceMatrix
    CluDistMat <- distance_calculator(X, CluDistMat, Clu, method)  
    
    # delete the clusters which has been merged
    fmCluDistMat[minClu[nrow(minClu),],] <- NA
    fmCluDistMat[,minClu[nrow(minClu),]] <- NA
    fmCluDistMat[(nrow(X)+item),1:(nrow(X)+item)] <- CluDistMat[(nrow(X)+item),1:(nrow(X)+item)]
    fmCluDistMat[1:(nrow(X)+item),(nrow(X)+item)] <- CluDistMat[1:(nrow(X)+item),(nrow(X)+item)]
  }
  # the final K clusters which status equal to 1
  final_cluster <- Clu[status==1]
  final_cluster1 <- c()
  for (item in 1:length(final_cluster)) final_cluster1[final_cluster[[item]]] <- item
  cat('The Cluster Number for each observation is:\n',final_cluster1,'\n')
  return(list(final_cluster1, final_cluster))
}

# running HAC with single linkage
Cluster.single <- hacluster(nci.data, K, 'single')
# running HAC with complete linkage
Cluster.complete <- hacluster(nci.data, K, 'complete')
# running HAC with average linkage
Cluster.average <- hacluster(nci.data, K, 'average')
# running HAC with centroid linkage
Cluster.centroid <- hacluster(nci.data, K, 'centroid')

# applying k-means to the NCI-microarray dataset
set.seed(1410)
km.out=kmeans(nci.data,K,nstart=20)
as.vector(km.out$cluster)