#installs required libraries
packages <- c("dplyr", "readxl", "devtools")
for(pkg in packages){
  if(!require(pkg, character.only = TRUE)){
    install.packages(pkg)
  }
}
if(!require(ggradar)){
  devtools::install_github("ricardo-bion/ggradar")
}

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

#assign names to numeric score columns
score_cols <- 3:ncol(ClassData)  # first 2 cols MUST be ID + ParticipantCode
names(ClassData)[score_cols] <- c(
  paste0("Inter", 1:3),
  paste0("Div", 1:4),
  paste0("Sys", 1:4),
  paste0("Stra", 1:8),
  paste0("Norm", 1:4),
  paste0("Fores", 1:4)
)


#sets the ID to count from just in case you started from a row ID =/= 1
CurrentIndividual <- ClassData[1,1]
CurrentIndividual <- strtoi(CurrentIndividual) # needs to be an intager
NumberOfIndividuals <- nrow(ClassData)
FinalIndividual <- NumberOfIndividuals+CurrentIndividual

#calculates averages for each category and adds to ClassData sheet
ClassData$IntAv   <- rowMeans(ClassData[, grep("^Inter", names(ClassData))], na.rm=TRUE)
ClassData$DivAv   <- rowMeans(ClassData[, grep("^Div", names(ClassData))], na.rm=TRUE)
ClassData$SysAv   <- rowMeans(ClassData[, grep("^Sys", names(ClassData))], na.rm=TRUE)
ClassData$StraAv  <- rowMeans(ClassData[, grep("^Stra", names(ClassData))], na.rm=TRUE)
ClassData$NormAv  <- rowMeans(ClassData[, grep("^Norm", names(ClassData))], na.rm=TRUE)
ClassData$ForesAv <- rowMeans(ClassData[, grep("^Fores", names(ClassData))], na.rm=TRUE)

#stores class averages as values for later
IntAv   <- mean(ClassData$IntAv)
DivAv   <- mean(ClassData$DivAv)
SysAv   <- mean(ClassData$SysAv)
StraAv  <- mean(ClassData$StraAv)
NormAv  <- mean(ClassData$NormAv)
ForesAv <- mean(ClassData$ForesAv)

#loop the following code until all individuals are processed
for(i in 1:nrow(ClassData)) {
  SelectedIndividual <- ClassData[i, ]
  
  InterpersonalMean <- round(SelectedIndividual$IntAv, 1)
  DiversityMean     <- round(SelectedIndividual$DivAv, 1)
  SysThinkMean      <- round(SelectedIndividual$SysAv, 1)
  StratActionMean   <- round(SelectedIndividual$StraAv, 1)
  NormCompMean      <- round(SelectedIndividual$NormAv, 1)
  ForesThinkMean    <- round(SelectedIndividual$ForesAv, 1)
  
  idName <- SelectedIndividual$ParticipantCode  # adjust if needed

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
  Plottabledata[nrow(Plottabledata) + 1, ] <- data.frame(
    idName = "Class Average",
    InterpersonalMean = round(IntAv, 1),
    DiversityMean     = round(DivAv, 1),
    SysThinkMean      = round(SysAv, 1),
    StratActionMean   = round(StraAv, 1),
    NormCompMean      = round(NormAv, 1),
    ForesThinkMean    = round(ForesAv, 1)
  )
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


