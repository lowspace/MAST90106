# FUNCTION TO GET DATASET FOR INDIVIDUAL COMPANY

projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
file = paste(funcsPath, "loadData.R", sep = "/")
source(file)

# FUNCTIONS

compCfpData <- function(cik){
  cfpData = loadCfp()
  rowList = which(cfpData[,"entity.cik"]==cik)
  compCfp = cfpData[rowList, ]
  
  # if start date is before 2002 remove it
  numRprtPeriods = dim(compCfp)[1]
  startDates = strsplit(compCfp[,c("period.start")], split = "/")
  endDates = strsplit(compCfp[,c("period.end")], split = "/")
  
  keepList = c()
  for (i in 1:numRprtPeriods){
    startYear = getStartMonthAndYear(startDates, i)[2]
    endYear = getEndMonthAndYear(endDates, i)[2]
    keep = ((startYear >= 2002) & (endYear <= 2020))
    keepList = c(keepList, keep)
  }
  keepRows = which(keepList == TRUE)
  
  compCfp[keepRows, ] # return
}

compTempData <- function(cik){
  state = stateName(cik)
  tempData = loadTemp()
  tempData[ , c("Year", "Month", state)]
}

compFireData <- function(cik){
  state = stateName(cik)
  fireData = loadFire()
  fireData = fireData[ , c("Year", toupper(state))]
  fireData[,2] = as.numeric(gsub(",","",fireData[,2]))
  fireData
}

stateName <- function(cik){
  companyCfpData = compCfpData(cik)
  state = unique(companyCfpData[ ,"location"]) # assumption: only 1
  state.name[match(c(state),state.abb)]
}


