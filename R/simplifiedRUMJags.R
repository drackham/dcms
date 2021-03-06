#' Simplified RUM Simulation in JAGS
#'
#' Fit a simplified RUM model to simulated data and evaluate data-model fit using JAGS.
#'
#' @param data Uses the dcmdata simplifiedRUM function to generate data
#' @param q Q-matrix
#' @param jagsModel The specified model for JAGS to use
#' @param adaptSteps Adapt Steps
#' @param burnInSteps Burn-in Steps
#' @param numSavedSteps Saved Steps
#' @param thinSteps Thin Steps
#' @param dynamicModel Logical that specifies if runJagsSim should look for the model within the package
#' @author Dave Rackham \email{ddrackham@gmail.com}
#' @references \url{http://onlinelibrary.wiley.com/doi/10.1002/j.2333-8504.2008.tb02157.x/abstract}
#' @keywords hartz roussos RUM JAGS
#' @export

runJagsSim <- function(data,
                       q = NULL,
                       jagsModel = "simplifiedRUM.jags",
                       adaptSteps = 10,
                       burnInSteps = 40,
                       numSavedSteps = 10,
                       thinSteps = 1,
                       dynamicModel = TRUE) {

  I <- data$I
  J <- data$J
  K <- data$K
  x <- data$xMat

  dataList = list(
    I = I ,
    K = K ,
    J = J ,
    q = q ,
    x = x)

  if(dynamicModel == FALSE){
      jagsModel <- system.file("Models", jagsModel, package="dcms") # See: https://stat.ethz.ch/pipermail/r-help/2010-August/247748.html
  }

  jags.params = c('alpha', 'rStar', 'pi')

  nChains = min(8, parallel::detectCores()-1) # Multi-core support 1 less than num cores, up to 1

  inits <- vector("list", nChains)

  inits <- lapply(inits, function(x) list(.RNG.name="lecuyer::RngStream", .RNG.seed=sample(1:1e+06,1,replace=F)))

  # ------------------------------------------- MCMC Estimation ------------------------------------------------------------------------
  # Start the timer
  mcmcEstimationTimer <- proc.time()

  # Run the chains
  runJagsOut <- runjags::run.jags( method="rjparallel",
                          model=jagsModel,
                          modules=c('glm on', 'lecuyer on'), # http://andrewgelman.com/2011/07/23/parallel-jags-rngs/ AND https://cran.r-project.org/web/packages/runjags/vignettes/quickjags.html
                          monitor=jags.params,
                          data=dataList,
                          n.chains=nChains,
                          adapt=adaptSteps,
                          burnin=burnInSteps,
                          sample=ceiling(numSavedSteps/nChains),
                          thin=thinSteps,
                          keep.jags.file=TRUE, # see results.jags
                          summarise=FALSE,
                          plots=FALSE,
                          inits=inits # http://andrewgelman.com/2011/07/23/parallel-jags-rngs/
  )
  # End timer
  mcmcDuration <- (proc.time() - mcmcEstimationTimer)
  mcmcDuration

  return(runJagsOut)

}

