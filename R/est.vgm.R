#'@title est.vgm
#'@description This function is used to compute an estimate of spatial correlation.
#'@param epsilon Residuals obtained from the estimated model.
#'@param coordinates Spatial distance coordinate system.
#'@param cutoff The spatial separation distance up to which point pairs are included in semivariance estimates. By default (NULL), it is set to one-third of the length of the diagonal of the bounding box spanning the data.
#'@return The output of the spatial correlation matrix.
#'@import gstat
#'@export

est.vgm <- function(epsilon, coordinates, cutoff) {

  data <- data.frame(e = epsilon, x = coordinates[, 1], y = coordinates[, 2])
  gamma.vgm <- gstat::variogram(e ~ x + y, locations = ~ x + y,
                      cutoff = cutoff, data = data)

  fit.vgm <-
    tryCatch(
      {gstat::fit.variogram( gamma.vgm, model=vgm(model="Exp",
                                           nugget=mean(gamma.vgm[, "gamma"])/10),fit.method=2)},
      warning = function(w) { rho.key = 1 }
    )

  if(inherits(fit.vgm, "variogramModel")){

    L2 <- as.matrix(dist(coordinates))
    corr <- ( (fit.vgm[2, "psill"] + 1e-10) / (sum(fit.vgm[ , "psill"]) + 1e-10) ) *
      exp( - L2 / abs(fit.vgm[2, "range"] + 1e-10) )
    diag(corr) <- 1
    c0 <- fit.vgm[1, "psill"]
    c1 <- fit.vgm[2, "psill"]
    range <- fit.vgm[2, "range"]
    sigma2 <- fit.vgm[1, "psill"] + fit.vgm[2, "psill"]
    p <- vgm.plot(v = gamma.vgm, m = fit.vgm)

  } else {

    corr <- diag( 1,length(epsilon))
    c0 <- NA
    c1 <- NA
    range <- NA
    sigma2 <- var(epsilon)
    p <- vgm.plot(v = gamma.vgm)

  }

  list(exist = inherits(fit.vgm, "variogramModel"), corr = corr, c0 = c0, c1 = c1, range = range, plot = p)
}

