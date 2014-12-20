run_analysis.R executes steps required to achieve results required for each of the 5 steps described in the course project requirements list.

First step:
===========
archives for 'train' are loaded - x_train (measurements), y_train (activity type of the measurement ), subject_train (subject that preformed the activity), and archives for 'test' also are loaded same way.

having data of 'train' and 'test' being loaded, measurement of 'train' and 'test' are bound by row (one beneath the other), x_train and x_test, generating result into x_data.

in the same way it is done with activity types correspondent for x_data, binding by row y_train and y_text, generating result into y_data.

and for subject_train and subject_test are also bound by row generating subject_data, containing subject that generated measurements in x_data.

binding is done by using functino rbind().


Second step:
=============
features.txt has the list of variables of x_data.
and the course project specified that those columns containing strings either '-mean()' or '-str()' must be selected.
identification of these columns is achieved using grep() with these string specified as OR condition (i.e. "|" regular expression character, without quotes).

we re-generate x_data with columns required by course project. (i.e. "x_data <- x_data[,<columns list>]" ), and name columns with the names from this column list (i.e. names(x_data <- features[<column_list>, 2] )


Third step:
=============
for replacing activity ID by activity names (labels), we load 'activity_labels.txt' (into activity_labels), and do this:

for each activity ID in y_data, we lookup into activity_labels by activity ID, gets its correspondent activity name and replaces the activity ID in y_data.

and also name column of y_data as 'activityName'

Fourth step
============

the column of subject_data is named 'subjectID'.

and finally, subject_data is bound to y_data, and the result is bound to x_data, by column (i.e. function cbound), in that order, generating te variable one_data.


Fifth step:
===============

one_data contains the result of all bindings and ready to execution of fifth step.
this step consist on grouping (like 'squeezing') one_data rows by subjectID and activityName, and applying ColMeans function for all other columns (i.e., those '-mean()' and '-std()' measure columns ), and result is generated into avg_one_data. 
all columns names remain the same.

the function to achieve this grouping feature is ddply() .
it takes one_data, group rows by subjectID and activityName variables, and applies function colMeans for one_data columns from 3rd to 68th. 

avg_one_data <- ddply(one_data, .(subjectID, activityName), function(x) colMeans(x[, 3:68]))

and finally, the avg_one_data is written into archive named 'avg_one_data.txt'.
it is also uploaded in the repo.
