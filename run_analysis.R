##  1. Downloading dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip")

## 2. Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## 3. Merging training and test data set into one set of data

      # 3.1. DataRead train tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

      # 3.2. DataRead test tables
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

      # 3.3. DataRead features vector
features <- read.table('./data/UCI HAR Dataset/features.txt')

      # 3.4. DataRead activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

      # 3.5. Column assigning
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

      # 3.6. Merging into one set of data
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

## 4. Extracting the mean and standard deviation for each measuremet

      # 4.1. Read columnNames
colNames <- colnames(setAllInOne)
      # 4.2. Defining ID of mean and standard deviation
mean_and_std <- (grepl("activityId" , colNames) | 
                       grepl("subjectId" , colNames) | 
                       grepl("mean.." , colNames) | 
                       grepl("std.." , colNames) 
)
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

## 5. Activities in Data Set

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

## 6. Creating 2nd independent tidy data set

      # Making the data set
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

      # Writing the 2nd tidy data set as a text file
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)





