
# get data

projectPath = "/Users/andrew/Documents/DataScienceProjectPt2"
funcsPath = paste(projectPath, "Data analysis", "Data processing functions", sep = "/")
setwd(funcsPath)
source("loadFullData.R") 
source("loadData.R") 
source("fpcaData.R") 
source("companyData.R") 

cfpList = loadCfpList()
cikList = loadCikList()
data = loadFullData("raw")

dataRaw = loadFullData("raw")
dataBasis = loadFullData("basis")

# temp data for relevant states

states = unique(data[,"location"])
stateNames = state.name[match(c(states),state.abb)]
tempData = loadTemp()

tempData = tempData[,c("Year", "Month", stateNames)] # only relevant temp data

# basis expansions for year 2002

i = 1

screeplotTable = matrix(NA, ncol = 12, nrow = length(stateNames))
colnames(screeplotTable) = c("PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "PC11", "PC12")
rownames(screeplotTable) = stateNames

basisExpansionPath = paste(projectPath, "fpcaPlots", "basisExpansion", sep = "/")
screeplotPath = paste(projectPath, "fpcaPlots", "screeplots", sep = "/")
for(i in 1:11){
  stateName = stateNames[i]

  stateTempData = tempData[,c("Year","Month",stateName)]
  stateTempBasis = basisExpansion(stateTempData)
  stateTempPca = pca.fd(stateTempBasis$fd, nharm = 12, centerfns = TRUE) 
  
  pdf(file = paste(basisExpansionPath, paste(stateName, ".pdf", sep = ""), sep = "/"), 
      width = 4,
      height = 4)
  plot(NA, xlim = c(0,12), ylim = c(-8, 29), 
       xlab = "Month", ylab = "Temperature (Celsius)",
       main = paste(stateName, " 2002"))
  points(c(0.5:11.5), stateTempData[c(1:12),stateName], col = 2, cex = 0.8, pch = 20)
  lines(stateTempBasis$fd[1])
  dev.off()
  
  pdf(file = paste(screeplotPath, paste(stateName, ".pdf", sep = ""), sep = "/"), 
      width = 4,
      height = 4)
  plot(stateTempPca$varprop, type = "l",
       xlab = "PC", ylab = "Variance explained",
       main = stateName)
  dev.off()
  
  # construct screeplot table
  screeplotTable[stateName, ] = cumsum(stateTempPca$varprop)
}

temp = rbind(screeplotTable,c(NA))
rownames(temp)[dim(temp)[1]] = "Average"
temp["Average", ] = colMeans(screeplotTable)
colMeans(screeplotTable)
temp
round(temp,4)

# save data as csv
filename = paste(screeplotPath, "cumulativeVariance.csv", sep = "/")
write.csv(round(temp,4), filename)


plot(stateTempPca$varprop, type = "l",
     xlab = "PC", ylab = "Variance explained",
     main = stateName)

names(stateTempPca)
cumsum(stateTempPca$varprop)

thisYear = which(tempData[,"Year"]=="2020")

min(stateTempData[c(1:12),stateName])
max(stateTempData[c(1:12),stateName])

min(tempData[c(1:12),stateNames])
max(tempData[c(1:12),stateNames])

# temporal trend of fPC's

i=1
stateName = stateNames[i]

stateTempData = tempData[,c("Year","Month",stateName)]
stateTempBasis = basisExpansion(stateTempData)
stateTempPca = pca.fd(stateTempBasis$fd, nharm = 12, centerfns = TRUE) 

years = c(2002:2020)
names(stateTempPca)
temporalTrend = stateTempPca$scores
colnames(temporalTrend) = c("PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "PC11", "PC12")
rownames(temporalTrend) = years

plot(years, temporalTrend[,6], type = "l")

temporalTrend = cbind(temporalTrend, years)
temporalTrend = data.frame(temporalTrend)

model1 = lm(PC1~years, data = temporalTrend)
summary(model1)
model2 = lm(PC2~years, data = temporalTrend)
summary(model2)
model3 = lm(PC3~years, data = temporalTrend)
summary(model3)
model4 = lm(PC4~years, data = temporalTrend)
summary(model4)
model5 = lm(PC5~years, data = temporalTrend)
summary(model5)
model6 = lm(PC6~years, data = temporalTrend)
summary(model6)

cikList[1]
data[which(data[,"entity.cik"] == cikList[1]),"ROC1"]
acf(data[which(data[,"entity.cik"] == cikList[1]),"ROC1"][-10])




