#loads the required libraries
library(readxl)
library(dplyr)
library(ggradar)

#sets working directory to wherever this file was opened from & creates output folder
path <- dirname(rstudioapi::getSourceEditorContext()$path)
file_path = dir(path, pattern = '\\.xlsx', full.names = TRUE)
mainDir <- path
subDir <- paste("Charts", format(Sys.time(), "%d-%m-%y %H%M"))
dir.create(file.path(mainDir, subDir))
setwd(file.path(mainDir, subDir))
dir.exists(file.path(mainDir, subDir))

#reads the data of the .xls file to a dataframe
ClassData = data.frame(read_excel(file_path))

#trims off useless form data
ClassData <- ClassData[ -c(2:6) ]

#sets the ID to count from just in case you started from a row ID =/= 1
CurrentIndividual <- ClassData[1,1]
CurrentIndividual <- strtoi(CurrentIndividual) # needs to be an intager
NumberOfIndividuals <- nrow(ClassData)
FinalIndividual <- NumberOfIndividuals+CurrentIndividual

#calculates averages for each category and adds to ClassData sheet
ClassData$IntAv <- rowMeans(ClassData[ , c(3:5)], na.rm=TRUE)
ClassData$DivAv <- rowMeans(ClassData[ , c(6:9)], na.rm=TRUE)
ClassData$SysAv <- rowMeans(ClassData[ , c(10:13)], na.rm=TRUE)
ClassData$StraAv <- rowMeans(ClassData[ , c(14:21)], na.rm=TRUE)
ClassData$NormAv <- rowMeans(ClassData[ , c(22:25)], na.rm=TRUE)
ClassData$ForesAv <- rowMeans(ClassData[ , c(26:29)], na.rm=TRUE)

#stores class averages as values for later
IntAv <- mean(ClassData[,30])
DivAv <- mean(ClassData[,31])
SysAv <- mean(ClassData[,32])
StraAv <- mean(ClassData[,33])
NormAv <- mean(ClassData[,34])
ForesAv <- mean(ClassData[,35])

#loop the following code until all individuals are processed
while(CurrentIndividual < FinalIndividual) { 

#select the (current) top row
  SelectedIndividual <- ClassData %>% filter(ID==CurrentIndividual)

#get the personal averages
  InterpersonalMean <- round(SelectedIndividual[1,30], digits = 1)
  DiversityMean <- round(SelectedIndividual[1,31], digits = 1)
  SysThinkMean <- round(SelectedIndividual[1,32], digits = 1)
  StratActionMean <- round(SelectedIndividual[1,33], digits = 1)
  NormCompMean <- round(SelectedIndividual[1,34], digits = 1)
  ForesThinkMean <- round(SelectedIndividual[1,35], digits = 1)
  
#make the axis titles for each person include their scores
  InterpersonalTitle = toString(paste("Interpersonal -", InterpersonalMean))
  DiversityTitle = toString(paste("Diversity -", DiversityMean))
  SysThinkTitle = toString(paste("Systems Thinking -", SysThinkMean))
  StratActionTitle = toString(paste("Strategic Action -", StratActionMean))
  NormCompTitle = toString(paste("Normative -", NormCompMean))
  ForesThinkTitle = toString(paste("Foresighted Thinking -", ForesThinkMean))
  
#set up the data to plot for the individual
  idName <- SelectedIndividual[2]
  fileName <- paste(idName,".jpg")
  ReferenceData <- idName
  Plottabledata <- data.frame(idName, InterpersonalMean, DiversityMean, SysThinkMean, StratActionMean, NormCompMean, ForesThinkMean)
  #reformat the labels to look nice
  Plottabledata <- rename(Plottabledata, !!InterpersonalTitle := InterpersonalMean, !!DiversityTitle := DiversityMean, !!SysThinkTitle := SysThinkMean, !!StratActionTitle := StratActionMean, !!NormCompTitle := NormCompMean, !!ForesThinkTitle := ForesThinkMean,)
  ReferenceData <- replace(ReferenceData, 1, "Class Average")
  Plottabledata[nrow(Plottabledata) + 1,] <- c(ReferenceData, IntAv, DivAv, SysAv, StraAv, NormAv, ForesAv)
  Plottabledata <- as.data.frame(Plottabledata)
  
#make a jpeg file container
  jpeg(fileName, width=1920,height=1080)
#plot the data
  lcols <- c("#5CB85C", "#46B8DA")
  lfills <- c(0.6, 0.5)
  print(ggradar(Plottabledata, fill = TRUE ,fill.alpha = 0.2,  axis.label.size = 5, legend.position = "bottom" ,legend.text.size =14,background.circle.colour = "white", group.colours = lcols, grid.min = 1, grid.mid = 5, grid.max = 10, values.radar = c("1", "5", "10"),plot.title = idName))
#save & close the file
  dev.off()
  
#move to the next individual
  CurrentIndividual <- CurrentIndividual+1

#loop
}


