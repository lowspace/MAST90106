#  CREATE JOINED DATASETS
## note for bushfires: start month jan - oct use same year's data
##                     start month nov/dec use linear interpolation (1/3, 2/3 splits)

# get functions
projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
setwd(funcsPath)
source("companyData.R") # file runs loadData.R too
source("fpcaData.R")
source("joinData.R") # adjust for bushfire join

# get data for ith company
cikList = loadCikList()
cfpList = loadCfpList()

i = 1;
cik = cikList[i]
compCfp = compCfpData(cik)
compTemp = compTempData(cik)
compFire = compFireData(cik)

# fPCA on compTemp dataset
yearBasisCoefs = getBasisCoefs(compTemp)
fourierFpcTransform = getFpcTransformMat(compTemp) # save these in dataframe accessed by cik

# temperature data by company reporting periods
tempByRprtPeriod = getTempByRprtPeriod(compCfp, compTemp) # removed incomplete time periods
basisByRprtPeriod = getBasisCoefs(tempByRprtPeriod, byRprtPeriod = TRUE) # fourier basis coefs in each rprtPeriod

meanBasisCoefsMat = getMeanBasisCoefsMat(compTemp, basisByRprtPeriod)
fpcByRprtPeriod = t(fourierFpcTransform)%*%(basisByRprtPeriod - meanBasisCoefsMat)

# merge rprtPeriod dataset with compCfp dataset
compCfpTempRaw   = joinCfpTempByRprtPeriod(compCfp, tempByRprtPeriod)
compCfpTempBasis = joinCfpTempByRprtPeriod(compCfp, basisByRprtPeriod)
compCfpTempPcs   = joinCfpTempByRprtPeriod(compCfp, fpcByRprtPeriod)

# joinDatasetWithFires -- need to handle nonstandard rprtPeriods
compFull = joinDatasetWithFires(compCfpTempPcs, compFire)

View(compFull)





