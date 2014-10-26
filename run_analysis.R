#library
library(dplyr)
library(plyr)
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
