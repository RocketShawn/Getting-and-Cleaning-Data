setwd("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset")
getwd()
list.files("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset")

##reading in the activity files
dActivityTest  <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/test/y_test.txt",header = FALSE)
str(dActivityTest)
dActivityTrain <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/train/y_train.txt",header = FALSE)
str(dActivityTrain)

##reading in the subject files
dSubjectTrain <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/train/subject_train.txt",header = FALSE)
dSubjectTest  <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/test/subject_test.txt",header = FALSE)
str(dSubjectTrain)
str(dSubjectTest)

##lastly,read in the features files
dFeaturesTest  <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/test/X_test.txt",header = FALSE)
dFeaturesTrain <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/train/X_train.txt",header = FALSE)
str(dFeaturesTest)
str(dFeaturesTrain)

##merge everything together, by rows using rbind command 

dSubject <- rbind(dSubjectTrain, dSubjectTest)
dActivity<- rbind(dActivityTrain, dActivityTest)
dFeatures<- rbind(dFeaturesTrain, dFeaturesTest)

##name the variables

names(dSubject)<-c("subject")
names(dActivity)<- c("activity")
dFeaturesNames <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/features.txt",head=FALSE)
names(dFeatures)<- dFeaturesNames$V2

##time to create a data.frame!!

dCombine <- cbind(dSubject, dActivity)
Data <- cbind(dFeatures, dCombine)

str(Data)


##come up with a way to extract the mean and SD of each measurement...

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

str(Data)


##Read descriptive activity names from "activity_labels.txt"

activityLabels <- read.table("C:/Users/stang/Desktop/R Directory/Getting and Cleaning Data/Week 4/UCI HAR Dataset/activity_labels.txt",head=FALSE)


head(Data$activity,30)


##label the data set

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

names(Data)

##create a second independent data set

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)


##produce codebook
library(knitr)
knit2html("codebook.Rmd");
