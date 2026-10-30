#'@title vgm.plot
#'@description Creates a variogram plot.
#'@param v The sample variogram.
#'@param m The fitted variogram model.
#'@return The ouput of the variogram plot.
#'@import ggplot2
#'@import gstat
#'@export

vgm.plot <- function(v, m = NULL) {
  p <- ggplot() +
    ggplot2::geom_point(data = v, aes(x = dist, y = gamma))

  if(!is.null(m)){
    preds <- gstat::variogramLine(object = m, maxdist = max(v$dist))
    p <- p + ggplot2::geom_line(data = preds, aes(x = dist, y = gamma))
  }

  return(p)
}
