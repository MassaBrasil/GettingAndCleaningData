


# 1. bind training and test datasets into single one dataset
###############################################################################
# 1a. load train data  - measurements (x_train), the correspondent activity type per row (y_train), and the correspondent subject ID that generated the measurement of the activity (subject_train)
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

# 1a. load test data  - measurements (x_test), the correspondent activity type per row (y_test), and the correspondent subject ID that generated the measurement of the activity (subject_test)
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# here we bind  the measurements of train and test by row, one beneath other, into x_data 
x_data <- rbind(x_train, x_test)

# here we bind  the activity types of train and test by row, one beneath other, into y_data 
y_data <- rbind(y_train, y_test)

# here we bind  the subject IDs correspondet to train and test activities, by row, one beneath other, into subject_data 
subject_data <- rbind(subject_train, subject_test)

# 2. we have more than 500 columns, we need only those having strings either '-mean()' or '-std()' in the name
###############################################################################
# 2a. load whole list of column names (features.txt)
features <- read.table("features.txt")

# 2b. generate new list of columns names that have either  '-mean()' or '-std()'
# get only columns with mean() or std() in their names

# i was doing the way below 
# mean_and_std_features1 <- grep("-mean\\(\\)", features[, 2])
# mean_and_std_features2 <- grep("-std\\(\\)", features[, 2])
# mean_and_std_features <- rbind(mean_and_std_features1, mean_and_std_features2) 
# why i don´t think it is not good idea: i would be changing the column orders in 'mean()' and  'std()' , loosing the orginal column orders the feature.txt has.
#
# checking about how to work with regular expression expressing 'string1' or 'string2', i found this below
# in : http://stackoverflow.com/questions/24176448/subset-data-based-on-partial-match-of-column-names
# i have found 
# "you can specify multiple patterns using, grep("pattern1 | pattern2 ", colnames(data))"
# applying this, in a single line i can create selection list of targeted columns 
mean_and_std_features <- grep("-mean\\(\\)|(-std\\(\\))", features[, 2])

# and below i use the selection list to subset x_data with targeted columns
x_data <- x_data[, mean_and_std_features]

# from the original list of columns, i have seleted the columns that have '-mean()' and '-std()' 
names(x_data) <- features[mean_and_std_features, 2]


# 3. replace activity IDs in y_data by activity names contained in 'activity_labels.txt'
###############################################################################
# I decided to use the names as they are originally in features.txt
# 3a. load the name of activities
activ <- read.table("activity_labels.txt")

# 3b. using activity ID in y_data, lookup for correspondent name of this activity and replace in the y_data
y_data[, 1] <- activ[y_data[, 1], 2]

# 3c. and set the variable name of y_data to 'activity'
names(y_data) <- "activityName"


# 4. Appropriately label the data set with descriptive variable names
###############################################################################

# for the subject_data, set column name for subject ID as 'subject'
names(subject_data) <- "subjectID"

# now we can bind by column the subject (subject_data), activity name (y_data) and measurements (x_data) into one dataset
one_data <- cbind(subject_data, y_data, x_data)


# 5. now the last step: group measurements in one_data by subject and activity name, calculating the average of each measurement columns.
###############################################################################
# columns 1 and 2 are respectively 'subjectID' and 'activityName')
avg_one_data <- ddply(one_data, .(subjectID, activityName), function(x) colMeans(x[, 3:68]))

write.table(avg_one_data, "avg_one_data.txt", row.name=FALSE)