# FUNCTION TO GET FULL DATASETS FOR GIVEN COMPANY

projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
setwd(funcsPath)
source("companyData.R") # file runs loadData.R too
source("fpcaData.R")
source("joinData.R") # adjust for bushfire join

# FOR LOOPS

# get company full datasets x3
cikList = loadCikList()

for(i in 1:length(cikList)){
  cik = cikList[i]
    
  # get data
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
  
  # merge with fires dataset with nonstandard rprtPeriod handling
  compFullTempRaw = joinDatasetWithFires(compCfpTempRaw, compFire)
  compFullTempBasis = joinDatasetWithFires(compCfpTempBasis, compFire)
  compFullTempPcs = joinDatasetWithFires(compCfpTempPcs, compFire)
  
  # rbind() relevant datasets together
  if(i == 1){
    fullTempRaw = compFullTempRaw
    fullTempBasis = compFullTempBasis
    fullTempPcs = compFullTempPcs
  } else {
    fullTempRaw = rbind(fullTempRaw, compFullTempRaw)
    fullTempBasis = rbind(fullTempBasis, compFullTempBasis)
    fullTempPcs = rbind(fullTempPcs, compFullTempPcs)
  }
  
  print(i)
}

# reason for NAs message
sum(is.na(fullTempRaw[,"BurntArea"]))

View(fullTempRaw)
View(fullTempBasis)
View(fullTempPcs) # these 3 datasets are what I save

# save datasets
fullDataPath = paste(projectPath, "fullData", sep = "/")
setwd(fullDataPath)

?write.csv
write.csv(fullTempRaw, 
          "fullData_rawTemp.csv")
write.csv(fullTempBasis, 
          "fullData_basisTemp.csv")
write.csv(fullTempPcs, 
          "fullData_fpcsTemp.csv")

dim(fullTempRaw)

colnames(fullTempRaw)









