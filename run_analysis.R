# load the packages

library(dplyr)
library(tidyr)
library(data.table)

## getting our data

# read in our data
features <- read.table("./UCI HAR Dataset/features.txt")
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
train_id <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
test_id <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

## cleaning our data

# merge the training and the test sets to create one data table called totalData
subject <- rbind(train_id, test_id)
featureVector <- rbind(train_data, test_data)
activities <- rbind(train_labels, test_labels)
colnames(featureVector) <- t(features[2])
colnames(activities) <- "activityType"
colnames(subject) <- "subjectID"
totalData <- cbind(subject, activities, featureVector)

# extract only mean and std measurements data
chosenCol <- grep(".*Mean.*|.*Std.*", names(totalData), ignore.case=TRUE)
neededCol <- c(1, 2, chosenCol) # adding our labels and ID
newData <- totalData[, neededCol]

# renaming activity labels (1-6) to descriptive activity names
newData$activityType <- as.character(newData$activityType)
for (i in 1:6) { newData$activityType[newData$activityType == i] <- as.character(activity_labels[i,2]) }
newData$activityType <- as.factor(newData$activityType)

# label the data with descriptive variable names
names(newData) <- gsub("Acc", "Accelerometer", names(newData))
names(newData) <- gsub("Gyro", "Gyroscope", names(newData))
names(newData) <- gsub("BodyBody", "Body", names(newData))
names(newData) <- gsub("Mag", "Magnitude", names(newData))
names(newData) <- gsub("^t", "Time", names(newData))
names(newData) <- gsub("^f", "Frequency", names(newData))
names(newData) <- gsub("tBody", "TimeBody", names(newData))
names(newData) <- gsub("-mean()", "Mean", names(newData), ignore.case = TRUE)
names(newData) <- gsub("-std()", "STD", names(newData), ignore.case = TRUE)
names(newData) <- gsub("-freq()", "Frequency", names(newData), ignore.case = TRUE)
names(newData) <- gsub("angle", "Angle", names(newData))
names(newData) <- gsub("gravity", "Gravity", names(newData))

# create an independent tidy data set with the average of each variable 
# for each activity and each subject
newData$subjectID <- as.factor(newData$subjectID)
newData <- data.table(newData)
newTidyData <- aggregate(. ~subjectID + activityType, newData, mean)
newTidyData <- newTidyData[order(newTidyData$subjectID,newTidyData$activityType),]
write.table(newTidyData, file = "tidydata.txt", row.names = FALSE)