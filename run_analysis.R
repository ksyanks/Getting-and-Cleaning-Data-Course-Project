library(plyr) 

# Step 1 
# Merge the training and test data sets to create one data set
#

# loading test data sets
testData <- read.table("test/X_test.txt") 
testActivity <- read.table("test/y_test.txt") 
testSubject <- read.table("test/subject_test.txt") 

# loading train data sets
trainData <- read.table("train/X_train.txt") 
trainActivity <- read.table("train/y_train.txt") 
trainSubject <- read.table("train/subject_train.txt") 

# merging train and test measurement data into 1 data set 
theData <- rbind(testData, trainData) 
 

# merging test activity and train activity data set 
theActivity <- rbind(testActivity, trainActivity) 


# merging test and train subject data set 
theSubject <- rbind(testSubject, trainSubject) 

#
# Step 2 
# Extract only the measurements on the mean and standard deviation for each measurement 
# 
 

# loading features data
features <- read.table("features.txt") 
 
# grep columns with mean() or std() in their names 
meanAndStdFeatures <- grep("(mean|std)\\(\\)", features[,2], ignore.case = FALSE)
 
# subset the measurement data with mean() or std() only
theData <- theData[, meanAndStdFeatures]

# assign the variable name to the measurement data set
names(theData) <- features[meanAndStdFeatures, 2] 
 
#
# Step 3 
# Use descriptive activity names to name the activities in the data set 
#
 
activities <- read.table("activity_labels.txt") 
 
# update values with correct activity names 
theActivity[, 1] <- activities[theActivity[, 1], 2] 
 

# assign column name to the activity data set 
names(theActivity) <- "activity" 

#
# Step 4 
# Appropriately label the data set with descriptive variable names 
# 

# assign column name the subject data set 
names(theSubject) <- "subject" 

# column bind subject, activity and the measurement data in a single data set 
allData <- cbind(theSubject, theActivity, theData) 

# re-name the variable name with descriptive name
names(allData) <- gsub('-mean', 'Mean', names(allData)) 
names(allData) <- gsub('-std', 'Std', names(allData)) 
names(allData) <- gsub('[()]', '', names(allData)) 

#
# Step 5 
# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject 
# 
 
#split data frame, apply function, and return results in a data frame
#column 1 is subject, column 2 is activity
#apply mean function to column 3 till 68 which are all the measurement data
meanData <- ddply(allData, .(subject, activity), function(x) colMeans(x[, 3:68])) 

#write meanData to tidy.txt file
write.table(meanData, "tidy.txt", row.name=FALSE, quote = FALSE) 
