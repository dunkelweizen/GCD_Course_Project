# download and unzip data if required:
if (!file.exists('getdata_projectfiles_UCI HAR Dataset.zip')){
  url<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url, 'getdata_projectfiles_UCI HAR Dataset.zip', mode='wb')
}

if (!file.exists('UCI HAR Dataset')){
  unzip('getdata_projectfiles_UCI HAR Dataset.zip')
}

## Step 1. Merge the training and test sets to create one data set:

# Read in all data
X_train<-read.table('UCI HAR Dataset/train/X_train.txt')
y_train<-read.table('UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('UCI HAR Dataset//train/subject_train.txt')

X_test<-read.table('UCI HAR Dataset/test/X_test.txt')
y_test<-read.table('UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('UCI HAR Dataset//test/subject_test.txt')

# Note the first column of these next two files is just the row number:
measurement_names <- read.table('UCI HAR Dataset/features.txt')[,2]
activity_labels <- read.table('UCI HAR Dataset//activity_labels.txt')[,2]

# combine the training and test data so that the first column is the
# subject ID, the 2nd column is the activity code (in y_train, y_test)
# and the following columns are variables from X_train, X_test.
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)

# combine test and training data:
alldat <- rbind(test, train)

## End Step 1.

## Step 2. Extract only the measurements on the mean and standard deviation 
##         for each measurement. 

# names of measurements are given in the file measurement_names, so just
# grep for mean() and std(). Note that grepping 'mean' or 'mean()' as a
# regexp will return meanFreq() as well, which I assume we do not want.
# (These are most likely means of a transformed variable.)
mean_idxes <- grep('mean()',measurement_names,fixed=T)
std_idxes <- grep('std()',measurement_names,fixed=T)

# combine all indices, and this gives a vector of columns of X_train,
# X_test and measurement_names that are means or standard deviations of 
# measurements.
all_idxes <- sort(c(mean_idxes, std_idxes))

# Here we select only the 1st, 2nd and the previously identified columns
smalldat <- alldat[,c(1,2,all_idxes+2)]

## End Step 2.

## Step 3. Use descriptive activity names to name the activities in the 
##         data set

smalldat[,2] <- activity_labels[smalldat[,2]]

## End Step 3.

## Step 4. Appropriately label the data set with descriptive variable names

# A function to tidy up variable names:
tidy_name <- function(a_string){
  # remove parentheses
  a_string <- gsub('(','',a_string,fixed=T)
  a_string <- gsub(')','',a_string,fixed=T)
  # replace hyphens with underscore
  a_string <- gsub('-','_',a_string,fixed=T)
  # prefix by "Average_of_"
  a_string <- paste0('Average_of_',a_string)
  a_string
}
# use sapply and the tidy_name function to clean up the variable names
tidy_measurement_names <- as.character(measurement_names[all_idxes])
tidy_measurement_names <- sapply(tidy_measurement_names,tidy_name,
                                 USE.NAMES=F)
# and label the data frame appropriately.
colnames(smalldat) <- c('Subject','Activity',tidy_measurement_names)

## End Step 4.

## Step 5. From the data set in step 4, create a second, independent tidy
##         data set with the average of each variable for each activity and
##         each subject.

# Here I use melt and cast from the reshape library

library(reshape)

# This command makes a new data frame with columns "Subject", "Activity" as
# in the smalldat data frame, "Activity" which contains the variable names
# in the other columns of smalldat (essentially 
# measurement_names[all_idxes]) and "Value" which contains the relevant
# numeric value of the variable

melted <- melt.data.frame(smalldat, id.vars=c('Subject','Activity'))

# The cast command that follows reshapes the data frame as before the melt
# command but with averaged values for each Subject and Activity combination

tidydata <- cast(melted,Subject+Activity~variable,mean)
write.table(tidydata,file='tidydata.txt',row.name=FALSE)

# The tidy data is retrievable within R by the command
# read.table('tidydata.txt', header=T)