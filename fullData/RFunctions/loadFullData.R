# FUNCTIONS FOR LOADING DATASETS WITH MAXIMAL OVERLAP PERIOD
## loadFullData()

projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
fullDataPath = paste(projectPath, "fullData", sep = "/")

# FUNCTIONS

loadFullData <- function(temp = "raw"){ 
  if (temp == "raw" | temp == "basis" | temp == "fpcs"){
    filename = paste("fullData_", temp, "Temp.csv", sep = "")
    file = paste(fullDataPath, filename, sep = "/")
    data = read.csv(file)
    data = data[,-1]
  } else {
    data = "valid temp inputs are raw, basis, or fpcs"
  }
  data # return data or error message
}

##### CHANGE TO GET FPC TRANS MATRIX

loadFullData <- function(temp = "raw"){  #####
  if (temp == "raw" | temp == "basis" | temp == "fpcs"){
    filename = paste("fullData_", temp, "Temp.csv", sep = "")
    file = paste(fullDataPath, filename, sep = "/")
    data = read.csv(file)
    data = data[,-1]
  } else {
    data = "valid temp inputs are raw, basis, or fpcs"
  }
  data # return data or error message
}

loadTempPredList <- function(data){ 
  colnames(data)[16:27] # or if statement breakdown
}

loadCfpList <- function(){ # note double up
  c("CurrentRatio", "DERatio", "NetMargin", "OperatingMargin", "QuickRatio", 
    "ROA1", "ROC1", "ROE1", "eps")
}

loadStateCodeList <- function(){
  c("CA", "OH", "GA", "FL", "CO", "MN", "KS", "PA", "TX", "MA", "MS")
}

loadStateNameList <- function(){
  stateCodes = loadStateCodeList()
  state.name[match(c(stateCodes),state.abb)]
}

loadEqnList <- function(cfp, data, nFpcs = 6){
  eqnList = c()
  #cfpList = loadCfpList()
  
  tempPredList = loadTempPredList(data)[1:nFpcs]
  climatePredList = c(tempPredList, "BurntArea")
  
  n = length(climatePredList)
  subsets = as.matrix(do.call(expand.grid,replicate(n,0:1,simplify=FALSE)))[-1,]
  colnames(subsets) = climatePredList
  
  nModels = nrow(subsets) # number models per cfp
  for(i in 1:nModels){
    # get predictors list into eqn
    preds = climatePredList[which(subsets[i,] == 1)]
    eqn = as.formula(paste(cfp, " ~ ",paste(preds, collapse="+"),sep = ""))
    eqnList = c(eqnList, eqn)
  }
  
  eqnList
}

eqnList = loadEqnList(data)

lm(eqnList[[10]],data)


colnames(subsets)[which(subsets[7,] == 1)]

subsets = as.matrix(do.call(expand.grid,replicate(length(s),0:1,simplify=FALSE)))
n=3
subsets = as.matrix(do.call(expand.grid,replicate(n,0:1,simplify=FALSE)))
colnames(subsets) = c("PC1","PC2","PC3")
subsets

as.formula(paste(cfp, " ~ ",paste(climatePredList, collapse="+"),sep = ""))

tempPredList = loadTempPredList(data)
rows = which(data[,"entity.cik"] == cik)
dataset <<- data[rows,]
# add column for change in cfp -- later
nTempPreds = length(fpcList)

if(nTempPreds != 0 & bushfires == TRUE){
  climatePredList = c(tempPredList[fpcList], "BurntArea")
  eqn = as.formula(paste(cfp, " ~ ",paste(climatePredList, collapse="+"),sep = ""))
} else if (nTempPreds != 0 & bushfires == FALSE){
  climatePredList = tempPredList[fpcList]
  eqn = as.formula(paste(cfp, " ~ ",paste(climatePredList, collapse="+"),sep = ""))
} else if (nTempPreds == 0 & bushfires == TRUE){
  climatePredList = c("BurntArea")
  eqn = as.formula(paste(cfp, " ~ ",paste(climatePredList, collapse="+"),sep = ""))
} else {
  eqn = as.formula(paste(cfp, " ~ ","1",sep = ""))
}












