---
title: "Codebook"
author: "L. Dixon Galler"
date: "August 21, 2015"
output: html_document
---

# Getting & Cleansing Data Programming Assignment

## Introduction  
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.   
The goal is to prepare tidy data that can be used for later analysis The source data is human activity data, built  
from recordings of subjects performing daily activities while carrying samsung smartphones.   
__The script__ *`run_analysis.R`* accomplishes the following tasks:  
1. __Downloads__ the data from:
  [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.html)  
2. __Merges__ the training and test sets to create one data set   
3. __Replaces__ `activity` values in the dataset with descriptive activity names  
4. __Extracts__ only the measurements (features) on the mean and standard deviation
   for each measurement   
5. __Labels__ the columns with descriptive names   
6. __Creates__ a second, independent tidy dataset with an average of each variable
  for each each activity and each subject. In other words, same type of
  measurements for a particular subject and activity are averaged into one value
  and the tidy data set contains these mean values only. The processed tidy data
  set is exported as **csv** file.
  
## run_analysis.R

The script is comprised of 6 functions with each function performing one of the
steps described above. To run entire cleaning process, call the *`clean.data`*
function. The script also utilizes the `plyr` library and requires that it has already 
been installed.

## The original data set

The original dataset is sourced from the Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.  

The original data set is split into training and test sets (70% and 30%,
respectively) where each partition is also split into three files that contain  
- measurements from the accelerometer and gyroscope
- activity label
- identifier of the subject
   
### Dataset Charactoristics: 
- Multivariate, Time Series
- 10299 Instance
- 561 Attributes
- Missing values N/A

### Attribute Information:
- For each record in the dataset it is provided: 
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration. 
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.



###The dataset includes the following files: 
'README.txt' - 'features_info.txt': Shows information about the variables used on the feature vector. 
'features.txt': List of all features. 
'activity_labels.txt': Links the class labels with their activity name. 
'train/X_train.txt': Training set. 
'train/y_train.txt': Training labels. 
'test/X_test.txt': Test set. 
'test/y_test.txt': Test labels. 
The following files are available for the train and test data. Their descriptions are equivalent.  
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.  
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.  
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.  
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians 


## Data Preperation

If the data is not already available in the `data` directory, it is downloaded
from UCI repository.

The first step of the preprocessing is to merge the training and test
sets. Two sets combined, there are 10,299 instances where each
instance contains 561 features (560 measurements and subject identifier). After
the merge operation the resulting data, the table contains 562 columns (560
measurements, subject identifier and activity label).

After the merge operation, mean and standard deviation features are extracted
for further processing. Out of 560 measurement features, 33 mean and 33 standard
deviations features are extracted, yielding a data frame with 68 features
(additional two features are subject identifier and activity label).

Next, the activity labels are replaced with descriptive activity names, defined
in `activity_labels.txt` in the original data folder.

The final step creates a tidy data set with the average of each variable for
each activity and each subject. 10299 instances are split into 180 groups (30 subjects and 6 activities) 
and 66 mean and standard deviation features are averaged for each group. The resulting data table has 180 rows 
and 66 columns. The tidy data set is exported to `UCI_HAR_tidy.csv` where the first row is the header containing 
the names for each column.
