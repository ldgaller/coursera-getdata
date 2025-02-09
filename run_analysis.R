########################################################################################
# This R script gets and downloads, merges and cleanses the human activity data, built #
# from recordings of 30 subjects performing daily activities while carrying            #
# smartphone. The full description of the data set is available at:                    #
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  #
# This code was designed to run on a windows PC add the method="curl" to the download  #
# file if running an a MAC                                                             #
########################################################################################

##########################################################
# plyr: Tools for Splitting, Applying and Combining Data #
##########################################################
library(plyr)
##########################################################
# download the datasets                                  #
##########################################################
download.data = function() {
    message("Checking for the data directory...")
    if (!file.exists("data")) {
        message("Creating data directory")
        dir.create("data")
    }
    if (!file.exists("data/UCI HAR Dataset")) {
        # download the data
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        zipfile="data/UCI_HAR_data.zip"
        message("Downloading data")
        #Windows
        download.file(fileURL, destfile=zipfile)
        #mac
        #download.file(fileURL, destfile=zipfile, method="curl")
        unzip(zipfile, exdir="data")
    }
}
##########################################################
# Read and combine (merge) the datasets                  #
##########################################################
merge.datasets = function() {
    message("Merging the training and test datasets")
    # Read the training data
    message("reading X_train.txt")
    training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
    message("reading y_train.txt")
    training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
    message("reading subject_train.txt")
    training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
    # Read the testing data
    message("reading X_test.txt")
    test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
    message("reading y_test.txt")
    test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
    message("reading subject_test.txt")
    test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
    # Merge
    merged.x <- rbind(training.x, test.x)
    merged.y <- rbind(training.y, test.y)
    merged.subject <- rbind(training.subject, test.subject)
    # merge train and test datasets and return
    list(x=merged.x, y=merged.y, subject=merged.subject)
}
##########################################################
# Extract measures for mean and std deviations           #
##########################################################
extract.attributes = function(df) {
    # Given the dataset (x values), extract only the measurements on the mean
    # and standard deviation for each measurement.
    
    # Read the feature list file
    features <- read.table("data/UCI HAR Dataset/features.txt")
    # Find the mean and std columns
    mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
    std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
    # Extract them from the data
    edf <- df[, (mean.col | std.col)]
    colnames(edf) <- features[(mean.col | std.col), 2]
    edf
}
##########################################################
# Assign descriptive names                               #
##########################################################
name.activities = function(df) {
    # Use descriptive activity names to name the activities in the dataset
    colnames(df) <- "activity"
    df$activity[df$activity == 1] = "WALKING"
    df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
    df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
    df$activity[df$activity == 4] = "SITTING"
    df$activity[df$activity == 5] = "STANDING"
    df$activity[df$activity == 6] = "LAYING"
    df
}
##########################################################
# Combine data frames                                    #
##########################################################
bind.data <- function(x, y, subjects) {
    # Combine mean-std values (x), activities (y) and subjects into one data
    # frame.
    cbind(x, y, subjects)
}
##########################################################
# Create tidy dataset                                    #
##########################################################
create.tidy.dataset = function(df) {
    # Given X values, y values and subjects, create an independent tidy dataset
    # with the average of each variable for each activity and each subject.
    tidy <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
    tidy
}
##########################################################
# Create the clean dataset                               #
##########################################################
clean.data = function() {
    # Download data
    download.data()
    # merge training and test datasets. merge.datasets function returns a list
    # of three dataframes: X, y, and subject
    merged <- merge.datasets()
    # Extract only the measurements of the mean and standard deviation for each
    # measurement
    cx <- extract.attributes(merged$x)
    # Name activities
    cy <- name.activities(merged$y)
    # Use descriptive column name for subjects
    colnames(merged$subject) <- c("subject")
    # Combine data frames into one
    combined <- bind.data(cx, cy, merged$subject)
    # Create tidy dataset
    tidy <- create.tidy.dataset(combined)
    # Write tidy dataset as csv
    write.csv(tidy, "UCI_HAR_tidy.csv", row.names=FALSE)
}
