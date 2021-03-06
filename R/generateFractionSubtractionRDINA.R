#' Generate the RDINA JAGS Non-Hierachical model for the Fraction Subtraction Data
#'
#' Generates the RDINA JAGS Non-Hierachical model for a simple data set
#'
#' @author Dave Rackham \email{ddrackham@gmail.com}
#' @references \url{http://onlinelibrary.wiley.com/doi/10.1002/j.2333-8504.2008.tb02157.x/abstract}
#' @keywords RDINA JAGS
#' @export
#'
generateFractionSubtractionRDINA <- function(){
  modelString <- paste(
    "model
    {
    for (i in 1:I) { # examinee
    for (j in 1:J) { # items
    y[i,j] ~ dbern(p[i,j])
    }
    }

    for (i in 1:I) {
    alpha1[i] ~ dbern(p1)
    alpha2[i] ~ dbern(p2)
    alpha3[i] ~ dbern(p3)
    alpha4[i] ~ dbern(p4)
    alpha5[i] ~ dbern(p5)
    alpha6[i] ~ dbern(p6)
    alpha7[i] ~ dbern(p7)
    alpha8[i] ~ dbern(p8)


    p[i,1] <- 1 / (1 + exp(-fHat[1] - dHat[1] * (alpha4[i] * alpha6[i]* alpha7[i])))
    p[i,2] <- 1 / (1 + exp(-fHat[2] - dHat[2] * (alpha4[i] * alpha7[i])))
    p[i,3] <- 1 / (1 + exp(-fHat[3] - dHat[3] * (alpha4[i] * alpha7[i])))
    p[i,4] <- 1 / (1 + exp(-fHat[4] - dHat[4] * (alpha2[i] * alpha3[i] * alpha5[i] * alpha7[i])))
    p[i,5] <- 1 / (1 + exp(-fHat[5] - dHat[5] * (alpha2[i] * alpha4[i] * alpha7[i] * alpha8[i])))
    p[i,6] <- 1 / (1 + exp(-fHat[6] - dHat[6] * (alpha7[i])))
    p[i,7] <- 1 / (1 + exp(-fHat[7] - dHat[7] * (alpha1[i] * alpha2[i] * alpha7[i])))
    p[i,8] <- 1 / (1 + exp(-fHat[8] - dHat[8] * (alpha7[i])))
    p[i,9] <- 1 / (1 + exp(-fHat[9] - dHat[9] * (alpha2[i])))
    p[i,10] <- 1 / (1 + exp(-fHat[10] - dHat[10] * (alpha2[i] * alpha5[i] * alpha7[i] * alpha8[i])))

    p[i,11] <- 1 / (1 + exp(-fHat[11] - dHat[11] * (alpha2[i] * alpha5[i] * alpha7[i])))
    p[i,12] <- 1 / (1 + exp(-fHat[12] - dHat[12] * (alpha7[i] * alpha8[i])))
    p[i,13] <- 1 / (1 + exp(-fHat[13] - dHat[13] * (alpha2[i] * alpha4[i] * alpha5[i] * alpha7[i])))
    p[i,14] <- 1 / (1 + exp(-fHat[14] - dHat[14] * (alpha2[i] * alpha7[i])))
    p[i,15] <- 1 / (1 + exp(-fHat[15] - dHat[15] * (alpha1[i] * alpha7[i])))
    p[i,16] <- 1 / (1 + exp(-fHat[16] - dHat[16] * (alpha2[i] * alpha7[i])))
    p[i,17] <- 1 / (1 + exp(-fHat[17] - dHat[17] * (alpha2[i] * alpha5[i] * alpha7[i])))
    p[i,18] <- 1 / (1 + exp(-fHat[18] - dHat[18] * (alpha2[i] * alpha5[i] * alpha6[i] * alpha7[i])))
    p[i,19] <- 1 / (1 + exp(-fHat[19] - dHat[19] * (alpha1[i] * alpha2[i] * alpha3[i] * alpha5[i] * alpha7[i])))
    p[i,20] <- 1 / (1 + exp(-fHat[20] - dHat[20] * (alpha2[i] * alpha3[i] * alpha5[i] * alpha7[i])))


    }
    # hyperpriors for alpha1 and alpha2

    p1 ~ dbeta(1,1)
    p2 ~ dbeta(1,1)
    p3 ~ dbeta(1,1)
    p4 ~ dbeta(1,1)
    p5 ~ dbeta(1,1)
    p6 ~ dbeta(1,1)
    p7 ~ dbeta(1,1)
    p8 ~ dbeta(1,1)

    # priors for RDINA parameters d and f
    for (j in 1:J) {
    dHat[j] ~ dgamma(1,.03)
    fHat[j] ~ dnorm(0,.05)
    }

    }"
  )

  # Write the string
  writeLines (modelString, con="Fraction-Subtraction-RDINA.jags")
}
