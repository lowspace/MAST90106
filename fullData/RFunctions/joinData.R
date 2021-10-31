# FUNCTION TO GET DATASET FOR INDIVIDUAL COMPANY

# projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
# funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
# file = paste(funcsPath, "loadData.R", sep = "/")
# source(file)

# FUNCTIONS

getTempByRprtPeriod <- function(compCfp, compTemp){
  
  # works
  numRprtPeriods = dim(compCfp)[1]
  emptyMatrix = matrix(NA, ncol = numRprtPeriods, nrow = 12)
  rownames(emptyMatrix) = c(1:12) # don't want to identify by fiscal year
  colnames(emptyMatrix) = c(1:numRprtPeriods)
  
  startDates = strsplit(compCfp[,c("period.start")], split = "/")
  endDates = strsplit(compCfp[,c("period.end")], split = "/")
  
  for (i in 1:numRprtPeriods){
    startMonthAndYear = getStartMonthAndYear(startDates, i)
    startMonth = startMonthAndYear[1]
    startYear = startMonthAndYear[2]
    
    endMonthAndYear = getEndMonthAndYear(endDates, i)
    endMonth = endMonthAndYear[1]
    endYear = endMonthAndYear[2]
    
    tempStartRow = which((compTemp[,"Year"] == startYear) & (compTemp[,"Month"] == startMonth))
    tempEndRow = which((compTemp[,"Year"] == endYear) & (compTemp[,"Month"] == endMonth))
    
    for (j in tempStartRow:tempEndRow){
      temp = compTemp[j,3] # temp to impute into ith col (rprtPeriod); one state assumed
      month = compTemp[j,"Month"]
      emptyMatrix[month, i] = temp
    }
  }
  emptyMatrix = emptyMatrix[ , colSums(is.na(emptyMatrix)) == 0] # remove incomplete time periods
  emptyMatrix
}

getStartMonthAndYear <- function(dates, i){
  nextYear = 0
  if(as.numeric(dates[[i]][1]) > 15){
    month = as.numeric(dates[[i]][2]) + 1
    if (month == 13){
      month = 1 
      nextYear = 1 # iterate year
    }
  }
  else {
    month = as.numeric(dates[[i]][2])
  }
  year = as.numeric(dates[[i]][3]) + 2000 + nextYear
  c(month, year) # return
}

getEndMonthAndYear <- function(dates, i){
  prevYear = 0
  if(as.numeric(dates[[i]][1]) < 15){
    month = as.numeric(dates[[i]][2]) - 1
    if (month == 0){
      month = 12
      prevYear = 1 # iterate year
    }
  }
  else {
    month = as.numeric(dates[[i]][2])
  }
  year = as.numeric(dates[[i]][3]) + 2000 - prevYear
  c(month, year) # return
}

joinCfpTempByRprtPeriod <- function(compCfp, tempDataByRprtPeriod){
  keptList = as.numeric(colnames(tempDataByRprtPeriod))
  fullList = as.numeric(rownames(compCfp))
  culledRprtPeriods = setdiff(fullList, keptList)
  
  compCfpNoNas = compCfp[keptList, ]
  data.frame(cbind(compCfpNoNas, t(tempDataByRprtPeriod)))
}

joinDatasetWithFires <- function(compCfpTempPcs, compFire){
  compFull = cbind(compCfpTempPcs, c(NA))
  colnames(compFull)[ncol(compFull)] = "BurntArea"
  
  # get start and end months and years
  numRprtPeriods = dim(compCfpTempPcs)[1]
  startDates = strsplit(compCfpTempPcs[,c("period.start")], split = "/")
  endDates = strsplit(compCfpTempPcs[,c("period.end")], split = "/")
  
  for (i in 1:numRprtPeriods){
    startMonthAndYear = getStartMonthAndYear(startDates, i)
    startMonth = startMonthAndYear[1]
    startYear = startMonthAndYear[2]
    
    endMonthAndYear = getEndMonthAndYear(endDates, i) # don't need these
    endMonth = endMonthAndYear[1]
    endYear = endMonthAndYear[2]
    
    if(startMonth >=1 & startMonth <= 10){
      row = which(compFire[,"Year"] == startYear) # impute directly
      compFull[i,"BurntArea"] = compFire[row, 2]
    }
    
    if(startMonth == 11){
      row1 = which(compFire[,"Year"] == startYear)
      row2 = which(compFire[,"Year"] == (startYear+1))
      interpolatedValue = compFire[row1, 2]*2/3 + compFire[row2, 2]*1/3 # linear interpolation
      compFull[i,"BurntArea"] = interpolatedValue
    }
    
    if(startMonth == 12){
      row1 = which(compFire[,"Year"] == startYear)
      row2 = which(compFire[,"Year"] == (startYear+1))
      interpolatedValue = compFire[row1, 2]*1/3 + compFire[row2, 2]*2/3 # linear interpolation
      compFull[i,"BurntArea"] = interpolatedValue
    }
    
  }
  
  # return joined dataset
  compFull
}







# joinDatasetWithFires <- function(compCfpTempPcs, compFire){
#   compFull = cbind(compCfpTempPcs, c(NA))
#   colnames(compFull)[ncol(compFull)] = "BurntArea"
#   
#   # get start and end months and years
#   numRprtPeriods = dim(compCfp)[1]
#   startDates = strsplit(compCfpTempPcs[,c("period.start")], split = "/")
#   endDates = strsplit(compCfpTempPcs[,c("period.end")], split = "/")
#   
#   for (i in 1:numRprtPeriods){
#     startMonthAndYear = getStartMonthAndYear(startDates, i)
#     startMonth = startMonthAndYear[1]
#     startYear = startMonthAndYear[2]
#     
#     endMonthAndYear = getEndMonthAndYear(endDates, i)
#     endMonth = endMonthAndYear[1]
#     endYear = endMonthAndYear[2]
#     
#     # impute bushfire data for ith rprtPeriod
#     if(startMonth == 1 & endMonth == 12){
#       row = which(compFire[,"Year"] == startYear)
#       compFull[i,"BurntArea"] = compFire[row, 2]
#     }
#     # extend for nonstandard rprtPeriods here
#   }
#   
#   # return joined dataset
#   compFull
# }

# cfpFull <- function(compFull, cfp){ # probs won't be using this
#   # sort by year for ease of join -- yet to change
# 
#   cfpFull = cbind(compFull, c(NA), c(NA))
#   startYear = min(compFull[,"period.fiscal.year"])
#   endYear = max(compFull[,"period.fiscal.year"])
# 
#   n = ncol(cfpFull)
#   colnames(cfpFull)[(n-1):n] = c(paste(cfp, "Change", sep = ""), paste(cfp, "PrevYear", sep = ""))
# 
#   for (year in (startYear+1):endYear){
#     prevYear = year - 1
#     rowCurYear = which(compFull[,"period.fiscal.year"] == year)
#     rowPrevYear = which(compFull[,"period.fiscal.year"] == prevYear)
# 
#     cfpFull[rowCurYear,(n-1)] = compFull[rowCurYear, cfp] - compFull[rowPrevYear, cfp]
#     cfpFull[rowCurYear, n] = cfpFull[rowPrevYear, cfp]
#   }
# 
#   cfpFull # return dataset
# }









