if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
require("data.table")
require("reshape2")

# set the working directory to the location where the dataset is extracted
# load the data sets

testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_act <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_act <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# Use descriptive activity names for the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)

# Label the data set with descriptive activity names
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")

# Merge test and training sets into one data set
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
allData<-rbind(testData,trainData)

# Extract only the measurements on the mean and standard deviation for each measurement
allData_mean<-sapply(allData,mean,na.rm=TRUE)
allData_sd<-sapply(allData,sd,na.rm=TRUE)

# Create an independent tidy data set with the average of each variable for each activity and each subject.
dataTable <- data.table(allData)
tidy<-dataTable[,lapply(.SD,mean),by="Activity,Subject"]

# Write tidy data into a file
write.table(tidy,file="tidy_csv.txt",sep=",",row.names = FALSE)