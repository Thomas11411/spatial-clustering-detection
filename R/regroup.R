#'@title regroup
#'@description A regroup procedure for multiple clusters.
#'@param clusters The cluster matrix.
#'@param nb.mat The first-order neighboring matrix.
#'@param response The input data (as a vector).
#'@return The output of the cluster matrix after regrouping.
#'@export

regroup <- function(clusters, nb.mat, response){

  ## 進行地區重疊的群聚合併
  tmp <- clusters[ ,1]
  nclust <- ncol(clusters)

  for(j in 2:nclust) {
    tmp <- tmp + clusters[ ,j]
    replicate <- which( tmp >= 2 )
    if( length(replicate) > 0 ) clusters[ ,j][replicate] <- 0
  }

  ## 移除被挖空成空集合的群聚
  clusters <- clusters[ , colSums(clusters * ( response > 0 )) > 0, drop = F]

  ## 將有相同邊界線的群聚合併(即彼此為鄰居的群聚)
  nclust <- ncol(clusters)
  i <- 1
  while ( i < nclust ) {
    is.intersect <- apply( clusters[ , -(1:i), drop=FALSE], 2, function(x, y){any(x * y > 0)}, y = nb.mat[ , clusters[,i] > 0])
    if ( any(is.intersect) ) {
      clusters <- cbind (clusters[ , 0:(i-1)],
                         ifelse( rowSums(clusters[ , c( i, ((i + 1):nclust)[is.intersect] ) ]) > 0, 1, 0), clusters[ , ((i+1):nclust)[!is.intersect] ] )
      nclust <- ncol(clusters) } else
        i <- i + 1 }

  return(clusters)

}

