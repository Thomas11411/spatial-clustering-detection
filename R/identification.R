#'@title identification
#'@description A mixture scan statistic that is associated with the two-part and cluster models is developed to identify geographic clusters for spatial data with covariates and excessive zeros.
#'@param response The input data (as a vector).
#'@param covariate The input data (as a vector or a matrix).
#'@param study.region Geospatial distance coordinate system map data file of the study area.
#'@param max.dist The maximum radial distance of the candidate cluster. The unit is kilometers.
#'@param cutoff The maximum distance for variogram calculation is a parameter of the variogram function. The unit is kilometers.
#'@return The output results include cluster locations and model results.
#'@import spdep
#'@import sf
#'@import dplyr
#'@importFrom dplyr %>%
#'@export
#'@examples
#'data(data); data(study.region)
identification <- function(response, covariate = NULL, study.region, max.dist, cutoff = NULL){

  sf::st_agr(study.region) <- "constant"

  coordinates <- study.region %>%
    sf::st_centroid() %>%
    sf::st_geometry() %>%
    sf::st_coordinates()

  coordinates <- data.frame(
    x = coordinates[,1] / 1000,
    y = coordinates[,2] / 1000 )

  Lambda <- candidate(coordinates = coordinates, max.dist = max.dist)
  ( nclust <- ncol(Lambda) )

  ## 單一群聚檢驗
  Lambda.pval <- rep(0, nclust)
  for(i in 1:nclust) {

    Lambda_i <- Lambda[, i]
    if(all(response[Lambda_i == 1] == 0)) {Lambda.pval[i] <- 1; next}
    X.in <- cbind(covariate, clust = Lambda_i)
    fit1 <- suppressWarnings({ MEE(formula = response ~ X.in, coordinates = coordinates, clust.cnt = 1, cutoff = cutoff) })
    Lambda.pval[i] <- ifelse(fit1$converge, fit1$table[ncol(X.in) + 1 , "p.values"], 1)

  }

  ( K0 <- sum(Lambda.pval <= (0.05/nclust)) )
  C.tilde.star <- Lambda[ , order(Lambda.pval)[1:K0], drop = F]

  if(K0 == 0) {
    warning("No single cluster passes the test.")
    final.fit <- MEE(formula = response ~ covariate, coordinates = loc.data, clust.cnt = 0, cutoff = cutoff)
    final.fit$clust.plot <- clusters_plot(result = final.fit, study.region = study.region)
    return(final.fit)
  }

  ## 將所選取之單一群聚進行合併
  nb.mat <- suppressWarnings({ spdep::nb2mat(spdep::poly2nb(study.region, queen=T), style="B") })
  C.hat.star <- regroup(clusters = C.tilde.star, nb.mat = nb.mat, response = response)
  ( K1 <- ncol(C.hat.star) )

  ## 建立多重迴歸模型，並將 p 值大於0.05的群聚排除
  colnames(C.hat.star) <- paste0("C", c(1:K1))
  X.in <- cbind(covariate, C.hat.star)
  fit2 <- MEE(formula = response ~ X.in, coordinates = coordinates, clust.cnt = K1, cutoff = cutoff)
  cluster.pval <- fit2$table[-c(1:(ncol(X.in) - K1 + 1)), "p.values"]
  ( K <- sum(cluster.pval < 0.05) )

  ## 建立最終多重迴歸模型
  C.hat <- C.hat.star[ , cluster.pval < 0.05, drop = F]
  X.in <- cbind(covariate, C.hat)
  final.fit <- MEE(formula = response ~ X.in, coordinates = coordinates, clust.cnt = K, cutoff = cutoff)

  if(K == 0) {
    warning("No cluster is statistically significant in the final multiple model.")
    final.fit <- MEE(formula = response ~ covariate, coordinates = loc.data, clust.cnt = 0, cutoff = cutoff)
    final.fit$clust.plot <- clusters_plot(result = final.fit, study.region = study.region)
    return(final.fit)
  }

  final.fit$clust.plot <- clusters_plot(result = final.fit, study.region = study.region)
  return(final.fit)

}
