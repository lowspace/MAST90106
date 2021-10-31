# FUNCTIONS FOR LOADING DATASETS WITH MAXIMAL OVERLAP PERIOD
## loadData(), loadCfp(), loadTemp(), loadFire()

projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"

# FUNCTIONS

# loadData <- function(cfp = TRUE, temp = TRUE, bushfire = TRUE){
#   # load datasets
# }

loadCfp <- function(){ 
  # get dataset
  file = paste(projectPath, "agriculture.csv", sep="/")
  cfpData = read.csv(file)
  
  # organise dataset
  cfpCols = c("CurrentRatio", "DERatio", "NetMargin", "OperatingMargin", "QuickRatio", 
              "ROA1", "ROC1", "ROE1", "eps")
  basicCols = c("entity.cik", "entity.name", "period.start", "period.end", "period.fiscal.year", "location")
  cfpData = cfpData[, c(basicCols, cfpCols)]
  
  cfpData # return
}

loadCikList <- function(){
  cfpData = loadCfp()
  cikList = na.omit(unique(cfpData[,"entity.cik"]))
  cikList[-15]
}

loadCfpList <- function(){
  cfpData = loadCfp()
  names(cfpData)[7:length(names(cfpData))]
}

loadTemp <- function(start = 2002, end = 2020){
  # get temp data
  file = paste(projectPath, "temperature.csv", sep="/")
  tempData = read.csv(file)
  #tempData

  startDate = which(tempData[,"Date"] == "2002/1") # need to adjust
  endDate = which(tempData[,"Date"] == "2020/12")
  tempData = tempData[startDate:endDate,] 
  
  # convert date to month and year
  Year = substring(tempData[,"Date"], 1, 4)
  Month = substring(tempData[,"Date"], 6, nchar(tempData[,"Date"]))
  tempData = cbind(Year, Month, tempData[,-1])
  
  # rename bad state names
  colnames(tempData)[13] = "Georgia"
  
  tempData
}

loadFire <- function(){
  # load bushfire dataset
  file = paste(projectPath, "bushfire.csv", sep="/")
  fireData = read.csv(file)
  fireData
}



