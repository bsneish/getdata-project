getdata-project
===============
Course Project for Getting and Cleaning Data for Data Science Specialization on Coursera

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Goals:
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#read in files
features<-read.table("UCI HAR Dataset/features.txt")
actname<-read.table("UCI HAR Dataset/activity_labels.txt")
testsub<-read.table("UCI HAR Dataset/test/subject_test.txt")
trainsub<-read.table("UCI HAR Dataset/train/subject_train.txt")
testact<-read.table("UCI HAR Dataset/test/Y_test.txt")
trainact<-read.table("UCI HAR Dataset/train/Y_train.txt")
test<-read.table("UCI HAR Dataset/test/X_test.txt")
train<-read.table("UCI HAR Dataset/train/X_train.txt")

#add subject and activity to data
test<-cbind(test,testsub,testact)
train<-cbind(train,trainsub,trainact)

#add descriptive column names
colnames(test)<-c(as.character(features$V2),"subject","activity")
colnames(train)<-c(as.character(features$V2),"subject","activity")

#merge training and test datasets
merged<-rbind(test,train)

#set activity and subject factors, use descriptive names for activity
merged$activity<-factor(merged$activity,actname$V1,actname$V2)
merged$subject<-as.factor(merged$subject)

#extract mean, std while keeping activity and subject
subset<-merged[,grepl("mean\\(\\)",names(merged))|grepl("std\\(\\)",names(merged))|grepl("subject",names(merged))|grepl("activity",names(merged))]

#summarize by subject/activity
tidy<-subset %>% group_by(subject,activity) %>% summarise_each(funs(mean))

#write tidy
write.table(tidy,"tidy.txt",row.names=FALSE)

The following features mean and standard deviation were summarized for each subject and activity:
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'
