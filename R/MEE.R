#'@title MEE
#'@description This function is the mixture estimation equation.
#'@param formula an object of class "formula": a symbolic description of the model to be fitted.
#'@param data An optional data frame containing the variables in the model.
#'@param coordinates Spatial distance coordinate system.
#'@param max.iter The maximum number of iterations. The default is 20.
#'@param tol Tolerance for stopping criteria. The default is 10 ^ (-4).
#'@param clust.cnt Number of clusters. The default is 0.
#'@param cutoff The maximum distance used for calculating the variogram is a parameter of the variogram function.
#'@return The estimation results of the mixture estimation equation.
#'@export

MEE <- function(formula, data, coordinates, max.iter = 20, tol = 10^(-4), clust.cnt = 0, cutoff){

  cl <- match.call()
  mf <- match.call(expand.dots = FALSE)
  m <- match(c("formula", "data"), names(mf), 0L)
  mf <- mf[c(1L, m)]
  mf$drop.unused.levels <- TRUE
  mf[[1L]] <- quote(stats::model.frame)
  mf <- eval(mf, parent.frame())
  mt <- attr(mf, "terms")

  Y <- model.response(mf, "numeric")
  n <- length(Y)
  part.plus <- Y > 0
  n.plus <- sum(part.plus)
  Y.plus <- Y[part.plus]

  X <- model.matrix(mt, mf)
  X_0 <- pi * X / sqrt(3)
  X.plus <- X[part.plus, ]
  X.cnt <- ncol(X)

  psi <- 1 - part.plus
  coordinates.plus <- coordinates[part.plus, ]

  fit0 <- summary( glm(Y.plus ~ X.plus[ ,-1], family = gaussian) )
  iter <- 0
  old.Beta <- fit0$coefficients[ ,1]

  repeat
  {
    iter <- iter + 1

    Y.hat.plus <- X.plus %*% old.Beta
    epsilon.plus <- Y.plus - Y.hat.plus
    sigma.hat <- sqrt( ( sum((epsilon.plus) ^ 2) / (n.plus - 1) ) * (n / n.plus) )

    vgm.fit <- est.vgm(epsilon = epsilon.plus, coordinates = coordinates.plus, cutoff = cutoff)

    rho.plus <- vgm.fit$corr #R+
    theta.hat <- c( ( 1+exp( X_0 %*% old.Beta / sigma.hat ) )^(-1) )

    Q <- (sigma.hat)^(-1) * t(X_0) %*% (theta.hat - psi) + (sigma.hat)^(-2) * t(X.plus) %*% solve(rho.plus) %*% (epsilon.plus)
    Big.Theta <- diag(theta.hat * (1 - theta.hat))
    Q.dot <- - sigma.hat^(-2) * (t(X_0) %*% Big.Theta %*% X_0 + t(X.plus) %*% solve(rho.plus) %*% X.plus)
    new.Beta <- old.Beta - solve(Q.dot) %*% Q  #Newton Raphson method

    if( sqrt(sum((new.Beta-old.Beta)^2)) < tol ) break # {cat("convergent.");break}
    if( iter > max.iter ) {warning("Model failed to converge."); break}
    old.Beta <- new.Beta
  }
  Sigma_Matrix <- sigma.hat ^ 2 * solve(t(X_0) %*% Big.Theta %*% X_0 + t(X.plus) %*% solve(rho.plus, X.plus))

  res.coef <- new.Beta[ , 1]
  res.sd <- sqrt(diag(Sigma_Matrix))
  res.zval <- res.coef/res.sd
  res.pval <- 2 * ( 1 - pnorm(abs(res.zval)) )
  clust <- NULL

  if(clust.cnt > 0) {
    res.pval[-c(1:(X.cnt - clust.cnt))] <- 1 - pnorm(res.zval[-c(1:(X.cnt - clust.cnt))])
    clust = X[ , -c(1:(X.cnt - clust.cnt)), drop = F]
    colnames(clust) <- paste0("C", c(1:clust.cnt))
  }

  res.table <- data.frame(
    coefficients = res.coef,
    standard.errors = res.sd,
    z.values = res.zval,
    p.values = res.pval
  )

  list(iter = iter, converge = (iter <= max.iter), table = res.table, clust = clust, sigma = sigma.hat, corr.exist = vgm.fit$exist, vgm.c0 = vgm.fit$c0, vgm.c1 = vgm.fit$c1, vgm.range = vgm.fit$range, vgm.plot = vgm.fit$p)

}

