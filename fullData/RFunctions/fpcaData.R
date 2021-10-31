# FUNCTION TO GET DATASET FOR INDIVIDUAL COMPANY

# projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
# funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
# file = paste(funcsPath, "loadData.R", sep = "/")
# source(file)

library(fda)

# FUNCTIONS

getBasisCoefs <- function(compTemp, byRprtPeriod = FALSE){
  tempFuncs = basisExpansion(compTemp, byRprtPeriod)
  tempFuncs$fd$coefs # return basis function expansion coefficients
}

getMeanBasisCoefs <- function(compTemp, byRprtPeriod = FALSE){
  tempFuncs = basisExpansion(compTemp, byRprtPeriod)
  meanFunc = mean.fd(tempFuncs$fd)
  meanFuncBasis = meanFunc$coefs
  rownames(meanFuncBasis) = rownames(tempFuncs$fd$coefs)
  meanFuncBasis # return
}

getMeanBasisCoefsMat <- function(compTemp, basisByRprtPeriod){
  meanBasisCoefs = getMeanBasisCoefs(compTemp)
  meanBasisCoefsMat = matrix(rep(meanBasisCoefs, dim(basisByRprtPeriod)[2]), nrow = 13)
  rownames(meanBasisCoefsMat) = rownames(basisByRprtPeriod)
  colnames(meanBasisCoefsMat) = colnames(basisByRprtPeriod)
  meanBasisCoefsMat # return
}

getFpcTransformMat <- function(compTemp, byRprtPeriod = FALSE){
  tempFuncs = basisExpansion(compTemp, byRprtPeriod)
  tempPca = pca.fd(tempFuncs$fd, nharm = 12, centerfns = TRUE) 
  tempPca$harmonics$coefs # return linear transformation between Fourier basis and fpc basis
}

basisExpansion <- function(compTemp, byRprtPeriod = FALSE){
  if(!byRprtPeriod){
    years = c(min(compTemp[,"Year"]):max(compTemp[,"Year"]))
    tempTimeSeries = data.frame(matrix(compTemp[,3], ncol = length(years), nrow = 12))
    colnames(tempTimeSeries) = years
  }
  
  harmOp = vec2Lfd( c(0,(2*pi/12)^2,0), c(0,12)) # overfit basis expansions
  fourierBasis = create.fourier.basis(rangeval = c(0,12), nbasis = 13, period = 12)
  fdParObj = fdPar(fourierBasis, Lfdobj = harmOp, lambda = 1e-8)
  
  monthOffset = c(1:12) - 0.5
  if(!byRprtPeriod){
    smooth.basis(monthOffset, as.matrix(tempTimeSeries), fdParObj)
  } else {
    smooth.basis(monthOffset, as.matrix(compTemp), fdParObj)
  }
}

# basisExpansion <- function(compTemp){
#   years = c(min(compTemp[,"Year"]):max(compTemp[,"Year"]))
#   tempTimeSeries = data.frame(matrix(compTemp[,3], ncol = length(years), nrow = 12))
#   colnames(tempTimeSeries) = years
#   
#   harmOp = vec2Lfd( c(0,(2*pi/12)^2,0), c(0,12)) # overfit basis expansions
#   fourierBasis = create.fourier.basis(rangeval = c(0,12), nbasis = 13, period = 12)
#   fdParObj = fdPar(fourierBasis, Lfdobj = harmOp, lambda = 1e-8)
#   
#   monthOffset = c(1:12) - 0.5
#   smooth.basis(monthOffset, as.matrix(tempTimeSeries), fdParObj)
# }






