
# load stuff

projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
setwd(funcsPath)
source("loadFullData.R") 
source("loadData.R") 
source("fpcaData.R") 
source("companyData.R") 

cikList = loadCikList()

data = loadFullData("fpcs")

# set up

data[which(data[,"entity.cik"]==cikList[15]),"period.start"]

keepCfpList = c("CurrentRatio", "NetMargin", "OperatingMargin", "ROA1", "ROE1")
keepCikList = cikList[c(1:3,9:12,16:17,19)] # why do I have a keepCikList? bc of degenerate adjusted R square values

permTestTable = matrix(NA, ncol = length(keepCfpList), nrow = length(keepCikList)) # rename 
colnames(permTestTable) = keepCfpList
rownames(permTestTable) = keepCikList

relationshipTable = matrix(NA, ncol = length(keepCfpList), nrow = length(keepCikList)) # rename
colnames(relationshipTable) = keepCfpList
rownames(relationshipTable) = keepCikList

tTestTable = matrix(NA, ncol = length(keepCfpList), nrow = length(keepCikList)) # new
colnames(tTestTable) = keepCfpList
rownames(tTestTable) = keepCikList

keepCikList

# for loop -- construct three tables

industryModel = lm(ROA1 ~ period.fiscal.year, data = data)
industryModel
summary(industryModel)

names(industryModel)
names(summary(industryModel))

summary(industryModel)$coefficients
industryModel$coefficients

f = summary(industryModel)$fstatistic

p <- pf(f[1],f[2],f[3],lower.tail=F)
attributes(p) <- NULL
return(p)

data[,c("period.fiscal.year","ROA1")]

pVal <- function(model){
  f = summary(model)$fstatistic
  p = pf(f[1],f[2],f[3],lower.tail=F)
  attributes(p) = NULL
  round(p,4)
}

set.seed(1)
nPerm = 500
for(a in 1:length(keepCikList)){
  
  cik = keepCikList[a]
  compData = data[which(data[,"entity.cik"] == cik),]
  permCompData = compData
  
  for(b in 1:length(keepCfpList)){
    
    cfp = keepCfpList[b]
    
    nmax = sum(!is.na(compData[,cfp]) & !is.na(compData[,"BurntArea"]))
    
    if(nmax > 3){
      eqnList = loadEqnList(cfp, data, min(6, nmax-3)) # CHANGED 6 TO 4 AS TEST
      
      # find best model
      
      nModels = length(eqnList)
      iBest = 0
      bestAdjR2 = -1
      adjR2 = -1
      
      for(i in 1:nModels){
        adjR2 = summary(lm(eqnList[[i]], compData))$adj.r.squared
        if(adjR2 > bestAdjR2){
          iBest = i # track and update
          bestAdjR2 = adjR2
        }
      }
      
      # if(bestAdjR2 < -0.9){#
      #   print(bestAdjR2)#
      # }#
      
      if(iBest!=0){
        bestModel = lm(eqnList[[iBest]], compData)
        relationshipTable[a,b] = paste(names(bestModel$coefficients)[-1], collapse="+")
        tTestTable[a,b] = pVal(bestModel)
        
        # simulate (adjR2|H0) distribution
        
        temp = 0 # bestAdjR2 placeholder
        #nPerm = 100
        bestAdjR2GivenH0 = c()
        naList = which(is.na(compData[,cfp]) | is.na(compData[,"BurntArea"])) # bushfires na error here not addressed
        for(j in 1:nPerm){
          # permute response vector
          permCompData[-naList,cfp] = sample(compData[-naList,cfp])
          
          # get best adjR2
          temp = -1
          for(k in 1:nModels){
            adjR2 = summary(lm(eqnList[[k]], permCompData))$adj.r.squared
            if(adjR2 > temp){
              temp = adjR2
            }
          }
          
          if(temp < -0.9){#
            print("perm test")#
            print(temp)#
          }#
          
          bestAdjR2GivenH0 = c(bestAdjR2GivenH0, temp) # add to distribution
          #bestR2GivenH0 = c(bestR2GivenH0, temp_r2) #
        }
        
        # compute p value
        if(bestAdjR2 > -0.99){
          # hist(bestAdjR2GivenH0, main = "hypothesis test")
          # abline(v=bestAdjR2, lty = "dashed", col = 2)
          # print(bestAdjR2)
          
          pUpper = 1 - sum(bestAdjR2GivenH0 < bestAdjR2)/nPerm
          pLower = 1 - sum(bestAdjR2GivenH0 <= bestAdjR2)/nPerm
          
          if(pUpper-pLower < 0.9){
            permTestTable[a,b] = (pUpper + pLower)/2
          }
          
        }
        
        
      } # end of iBest != 0 if statements
      
    } # end of nmax>3 if statement
    
  } # end of b loop
  print(a)
  
} # end of a loop

plot(c(1,10,100), c(8, 43, 407), type = "l")
timeData = matrix(c(1,10,100, 8, 43, 407), ncol = 2)
colnames(timeData) = c("nPerm", "time")
timeData = data.frame(timeData)
timeModel = lm(time~nPerm, timeData)
summary(timeModel)
(1800 - timeModel$coefficients[1])/timeModel$coefficients[2]
(timeModel$coefficients[1] + timeModel$coefficients[2]*500)/60

# table summaries

permTestTable

relationshipTable

tTestTable

write.csv(permTestTable, file = paste(projectPath, "permTestTable.csv", sep="/"))
write.csv(relationshipTable, file = paste(projectPath, "relationshipTable.csv", sep="/"))
write.csv(tTestTable, file = paste(projectPath, "tTestTable.csv", sep="/"))

# results analysis

keepCikList[3]
unique(data[which(data[,"entity.cik"] == keepCikList[3]),"location"])
unique(data[which(data[,"entity.cik"] == keepCikList[10]),"location"])

# 0.05 level results
compTemp = compTempData(keepCikList[3])
tempFuncs = basisExpansion(compTemp)
tempFuncs
tempPca = pca.fd(tempFuncs$fd, nharm = 12, centerfns = TRUE) 
plot(tempPca$harmonics[c(3,6)])

plot(tempPca)
plot(c(2002:2020),tempPca$scores[,3], type = "l")
lines(c(2002:2020),tempPca$scores[,6], col=2)

choose(33,2)*(0.05^2) *0.95^31
1-(choose(33,1)*(0.05^1) *0.95^32 + choose(33,0)*(0.05^0) *0.95^33)

# first result

cik = keepCikList[3]
compData = data[which(data[,"entity.cik"] == cik),]

bestModel1 = lm(CurrentRatio~PC3+PC6, compData)
summary(bestModel1)
bestModel1$coefficients["PC6"]

direction = bestModel1$coefficients["PC3"]*tempPca$harmonics[3] + bestModel1$coefficients["PC6"]*tempPca$harmonics[6]
plot(direction)

directionScores = bestModel1$coefficients["PC3"]*tempPca$scores[,3] + bestModel1$coefficients["PC6"]*tempPca$scores[,6]
plot(c(2002:2020), directionScores, type = "l")

summary(lm(directionScores~c(2002:2020)))

# second result

cik2 = keepCikList[10]
compData2 = data[which(data[,"entity.cik"] == cik2),]

compTemp2 = compTempData(cik2)
tempFuncs2 = basisExpansion(compTemp2)
tempPca2 = pca.fd(tempFuncs2$fd, nharm = 12, centerfns = TRUE) 

bestModel2 = lm(ROE1~PC2, compData2)
summary(bestModel2)
bestModel2$coefficients["PC2"]

direction2 = bestModel2$coefficients["PC2"]*tempPca2$harmonics[2]
plot(direction2)

directionScores2 = bestModel2$coefficients["PC2"]*tempPca2$scores[,2] 
plot(c(2002:2020), directionScores2, type = "l")

summary(lm(directionScores2~c(2002:2020)))
