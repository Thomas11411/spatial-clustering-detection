#'@title clusters_plot
#'@description This function is used to plot the selected cluster locations on the map.
#'@param result The estimated output of the function "MEE".
#'@param study.region Geospatial distance coordinate system map data file of the study area.
#'@return The output of the selected cluster map plot.
#'@import ggplot2
#'@export
clusters_plot <- function(result, study.region){

  if(is.null(result$clust)) {

    p <- ggplot2::ggplot()
    p <- p + ggplot2::geom_sf(data = study.region) + ggplot2::coord_sf() + ggplot2::theme_void()
    return(p)

  }

  clust <- result$clust
  K <- ncol(clust)

  col.vec <- c(clust %*% c(1:K))
  col.vec <- factor(col.vec)

  col.seq <- c("white", gray(seq(from = 0, to = 1, length.out = (K + 2))[-c(1, K + 2)]))
  names(col.seq) <- c(0:K)

  p <- ggplot2::ggplot()
  p <- p + ggplot2::geom_sf(data = study.region, aes(fill = col.vec),size = 0.25,color = grey(0.3))
  p <- p + ggplot2::scale_fill_manual("", values = col.seq, breaks = c(1:K), labels = paste0("C",c(1:K)))
  p <- p + ggplot2::coord_sf() + ggplot2::theme_void()

  return(p)

}

