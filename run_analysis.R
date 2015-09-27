" 1) a tidy data set as described below, 
  2) a link to a Github repository with your script for performing the analysis, and 
  3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. 
  4) You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 
"
"You should create one R script called run_analysis.R that does the following. 

1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 

From the data set in step 4, creates a second, independent tidy data set with the average
#of each variable for each activity and each subject."
 
# The Tidy Data Set
# 1.Each variable you should measure be in one column
# 2.Each different observation should be in a different row
# 3.There should be one table for each "kind" of variable
# 4.If you have multiple tables you should have a common key in each table

require(dplyr)

#Functions 
# returns string w/o leading whitespace
trim.leading <- function (x)  sub("^\\s+", "", x)

# returns string w/o trailing whitespace
trim.trailing <- function (x) sub("\\s+$", "", x)

# returns string w/o leading or trailing whitespace
trim <- function (x) gsub("^\\s+|\\s+$", "", x)

setwd("C:\\RWork\\GetCleanData\\courseproj\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\train\\")

# Read in the Data
train_data<-read.table("subject_train.txt")
names(train_data)<-"subjects"
names(ytrain_data)<-"y_label_id"
xtrain_data<-read.table("x_train.txt")
ytrain_data<-read.table("y_train.txt")

setwd("C:\\RWork\\GetCleanData\\courseproj\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\test\\")
xtest_data <-read.table("x_test.txt")
ytest_data <-read.table("y_test.txt")
names(ytest_data)<- "y_label_id"
test_subjects<-read.table("subject_test.txt")

#get activity labels
activity_labels<-read.table("C:\\RWork\\GetCleanData\\courseproj\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\activity_labels.txt")
names(activity_labels)<- c("y_label_id", "activity_label")

names(test_subjects)<-"subjects"
names(ytest_data)<-"y_label"


features<- read.delim("C:\\RWork\\GetCleanData\\courseproj\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset\\features.txt", sep=" ", header=FALSE, strip.white=TRUE)
features2<-trim.leading(features$V2)
features2

summary(train_data)

# Merge in the Data
y_train_actv_labels<-merge(ytrain_data, activity_labels, by= "y_label_id")
merged_training<-cbind(train_data[1], xtrain_data, y_train_actv_labels)

head(merged_training[561:564])
#verify merge occured properly for activity labels
table(merged_training[563:564])

#repeat merge for test data
y_test_actv_labels<-merge(ytest_data, activity_labels, by= "y_label_id")
merged_testing<-cbind(test_subjects, xtest_data, y_test_actv_labels)

#verify merge occured properly for activity labels
table(merged_testing[563:564])


#clean feature names
#get rid of punctuations
features<- cbind(features,gsub( "[[:punct:]]", "", features$V2))
names(features)<- c("featureid","featurename", "featurenameclean")
sortfeatures <-arrange(features, featurename)

j<-""

for(i in 1:nrow(features)){
  
  if(sortfeatures[i,2] == previous){
    item_cnt<- item_cnt + 1
    j[i] <- item_cnt 
    rbind(j, j[i])
    
  }
  else{
    item_cnt <- 1
    j[i]<-item_cnt
    rbind(j,j[i])
  }
  
  previous<- sortfeatures[i,2]
  print(paste(sortfeatures[i,2], "---" , j[i]) )
  
}
#merges the count of features with the same name with sort features
sortfeatures<- cbind(sortfeatures, j, paste0(sortfeatures$featurenameclean, "_", j))
head(sortfeatures)
names(sortfeatures)<- c("featureid", "featurename", "featurenameclean","featurecnt", "featurenamenew")
head(sortfeatures)

features<- arrange(sortfeatures, featureid) 


#apply the new feature names to the data set
t<-features$featurenamenew
names(xtrain_data)<- t
merged_testing<-cbind(test_subjects, xtest_data, y_test_actv_labels)
names(xtest_data)<-t
merged_testing<-cbind(test_subjects, xtest_data, y_test_actv_labels)

# Extracts only the measurements on the mean and standard deviation for each measurement. 



 #obtains all of the features that have std in the column name and obtains their positions
stdlist<-grep("std",features$V2)
meanlist<-grep("mean", features$V2)
#extract these std() standard deviations and means into their own table
 

std_training<-(select(xtrain_data,  stdlist))

std_testing<-(select(xtest_data, stdlist))

mean_training<-(select(xtrain_data,  meanlist))

mean_testing<-(select(xtest_data, meanlist))
head(std_testing)
head(std_training)
head(mean_testing)
head(mean_training)

#merge each data sets to create 4 tidy data sets

std_training<-cbind(train_data[1], std_training, y_train_actv_labels)
std_testing<-cbind(test_subjects, std_testing, y_test_actv_labels)
mean_training<-cbind(train_data[1], mean_training, y_train_actv_labels)
mean_testing<-cbind(test_subjects, mean_testing, y_test_actv_labels)

#Build Summarized data sets

std_train_means<-std_training %>% group_by(subjects, activity_label) %>% summarise_each(funs(mean))
std_test_means<-std_testing  %>% group_by(subjects, activity_label) %>% summarise_each(funs(mean))
mean_train_means<-mean_training %>% group_by(subjects, activity_label) %>% summarise_each(funs(mean))
mean_test_means<- mean_testing %>% group_by(subjects, activity_label) %>% summarise_each(funs(mean))


# convert to data frames
std_train_averages<-as.data.frame(std_train_means)
std_test_averages<-as.data.frame(std_test_means)
mean_train_averages<- as.data.frame(mean_train_means)
mean_test_averages<- as.data.frame(mean_test_means)
#write data to directory
write.table(std_train_averages, "C:\\RWork\\GetCleanData\\std_train_averages.csv", row.name=FALSE, sep=",")
write.table(std_test_averages, "C:\\RWork\\GetCleanData\\std_test_averages.csv", row.name=FALSE, sep=",")
write.table(mean_train_averages, "C:\\RWork\\GetCleanData\\mean_train_averages.csv", row.name=FALSE, sep=",")
write.table(mean_train_averages, "C:\\RWork\\GetCleanData\\mean_test_averages.csv", row.name=FALSE, sep=",")
