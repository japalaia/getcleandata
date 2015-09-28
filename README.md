# getcleandata
project assignment for getting and cleaning data cours

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
of each variable for each activity and each subject."
 
The Tidy Data Set
1.Each variable you should measure be in one column
2.Each different observation should be in a different row
3.There should be one table for each "kind" of variable
4.If you have multiple tables you should have a common key in each table



This project includes four output files 
mean_test_averages.csv
mean_train_averages.csv
std_test_averages.csv
std_train_averages.csv

The files are 4 files for each kind of variables and data sets
In each file is a list of the averages for the set of means or standard deviations from the Samsung accelorometer experiment.

Each file contain the activity_label, the subject identifier, each corresponding variable and the y_label_id.
The Y-Label id is the corresponding id for each activity.

There are 26 rows of data in each. 
The headers have been cleaned to remove punctuations and also to account for duplicated variable names.
The duplicated variable names were assigned a value of 1 to 3 depending upon their order in the original 
xtrain and ytrain data.

Finally, this repo will include the run_analysis.r script.
The script takes the input from the Samsung files for training and testing and merges
the subject, the features (x data), and the activity (y data) for each training and testing folders
The program merges the data sets then extracts the standard deviations and average features from the xtrain and xtest data sets.

Then the field names are cleaned and properly named and then the aggregation in step 5 of the instructions is performed.
