
# Load the necessary libraries
library(plyr)
library(reshape2)


## Download and unzip the dataset:
if (!file.exists("dataset.zip")){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
      download.file(fileURL, "dataset.zip")
}  
if (!file.exists("UCI HAR Dataset")) { 
      unzip("dataset.zip") 
}


# Load the files and merge them
xtemp1 <- read.table("test/X_test.txt", header = F)
xtemp2 <- read.table("train/X_train.txt", header = F)
X <- rbind(xtemp1, xtemp2)

ytemp1 <- read.table("test/y_test.txt", header = F)
ytemp2 <- read.table("train/y_train.txt", header = F)
Y <- rbind(ytemp1, ytemp2)

stemp1 <- read.table("test/subject_test.txt", header = F)
stemp2 <- read.table("train/subject_train.txt", header = F)
S <- rbind(stemp1, stemp2)


# Extract the mean and standev variables from the data
feat <- read.table("features.txt", header = F)
index <- grep("-mean\\(\\)|-std\\(\\)", feat[,2])
finX <- X[,index]                               # Store the final X's
names(finX) <- feat[index, 2]                   # Edit the names of the data
names(finX) <- gsub("\\(|\\)", "", names(finX)) # Erase the () of the names


# Substitute the Y values with the activity labels
act <- read.table("activity_labels.txt", header = F)
act[,2] <- as.character(act[,2])          # Change from factors to characters
finY <- Y
finY[,1] <- act[Y[,1], 2]                 # Store the final Y's 


# Change the last names and merge the final data frames obtained
names(finY) <- "activities"
names(S) <- "subjects"
data <- cbind(S, finY, finX)
write.table(data, file = "Clean_data.txt")


# Create the new tidy data frame with the mean for each activity and subject
data2 <- aggregate(. ~ activities + subjects, data, FUN = mean)
data2 <- data2[order(data2$activities, data2$subjects),]
write.table(data2, file = "Mean_clean_data.txt")



