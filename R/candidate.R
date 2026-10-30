#'@title candidate
#'@description Create circular candidate clusters.
#'@param coordinates Spatial distance coordinate system.
#'@param max.dist The maximum radial distance of the candidate cluster. The unit is kilometers.
#'@return The output of the candidate cluster matrix.
#'@export

candidate <- function(coordinates, max.dist){

  dist_mat <- as.matrix(dist(coordinates))
  All_cluster <- NULL
  n <- nrow(coordinates)

  for(i in 1:n){
    tmp_dist <- dist_mat[i, ]
    tmp_cnt <- sum(tmp_dist < max.dist)
    tmp_idx <- order(dist_mat[i, ])[1:tmp_cnt]
    for(j in 1:tmp_cnt){
      tmp_cluster <- rep(0, n)
      tmp_cluster[tmp_idx[1:j]] <- 1
      All_cluster <- cbind(All_cluster, tmp_cluster)
    }
  }

  All_cluster <- unique(All_cluster, MARGIN = 2)
  return(All_cluster)

}

