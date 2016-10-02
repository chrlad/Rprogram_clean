#library calls

library(dplyr)

#Step 1: Merges the training and the test sets to create one data set.
# Create folder for data if it doesn't exist

if(!file.exists("./UCI_MLR")){dir.create("./UCI_MLR")}

#Download data

fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "UCI.zip")

#unzip data into the created folder

unzip ("UCI.zip", exdir = "./UCI_MLR")
dirpath <- "./UCI_MLR/UCI HAR Dataset/"

# read files into dataframes

features <- read.table(paste0(dirpath, "features.txt"), stringsAsFactors = FALSE)
x_train <- read.table(paste0(dirpath, "train/X_train.txt"), stringsAsFactors = FALSE)
y_train <- read.table(paste0(dirpath, "train/y_train.txt"), stringsAsFactors = FALSE)
x_test <- read.table(paste0(dirpath, "test/X_test.txt"), stringsAsFactors = FALSE)
y_test <- read.table(paste0(dirpath, "test/y_test.txt"), stringsAsFactors = FALSE)
subject_train <- read.table(paste0(dirpath, "train/subject_train.txt"), stringsAsFactors = FALSE)
subject_test <- read.table(paste0(dirpath, "test/subject_test.txt"), stringsAsFactors = FALSE)
activity <- read.table(paste0(dirpath, "activity_labels.txt"), stringsAsFactors = FALSE)


# Merge training and test datasets into one dataset

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)


# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

# select the columns with mean() or std() in their names
features_w_mean_std <- grep("-(mean|std)\\(\\)", features[, 2])


# select only mean() or std() columns in the x dataset
x_data <- x_data[, features_w_mean_std]


# Step 3: Uses descriptive activity names to name the activities in the data set

# Merge activitynames into the activities
y_data_w_names <- merge(y_data, activity, by.x = "V1", by.y = "V1")

# Step 4: Appropriately labels the data set with descriptive variable names.

# update x_data column names
names(x_data) <- features[features_w_mean_std, 2]

# Update activity column names
names(y_data_w_names) <- c("activity", "activitylabel")

# update subject column name
names(subject_data) <- "subject"

# bind all the data in a single data set
combined_data <- cbind(x_data, y_data_w_names, subject_data)

# Step 5: From the data set in step 4, creates a second, independent tidy data set 
#         with the average of each variable for each activity and each subject.

#Group the data by activity and subject

datagrp <- group_by(combined_data, activitylabel, subject)

#create average over activity and subject

avg_data <- summarise_each(datagrp, funs(mean(., na.rm=TRUE)), -activity) 

#output data to file
write.table(avg_data, "averages.txt", row.name=FALSE)
