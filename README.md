# About run_analysis.R

run_analysis.R carries out a series of operations on the "Human Activity Recognition
Using Smartphones Data Set from the UCI Machine Learning Repository. The data set can be
obtained from:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# What run_analysis.R does

run_analysis.R does the following:

1. Reads in "activity_labels.txt" and "features.txt" and stores the information in
separate data frames named "activity_labels" and "feature_labels". The activity label
information will allow us to associate the activity id with a description of the activity.
Likewise, the feature label information will allow the useful naming of the measurement
variables in an intuitive and easy to understand manner.

2. Reads in "subject_train.txt", "X_train.txt", and "Y_train.txt" into 3 seperate
dataframes: "training_subjects", "training_data", and "training_activity". The columns of
the "training_data" dataframe is then renamed with "feature_labels". The seperate data
frames containing subject, training data, and activity information is then column bound
to form a complete training dataset.
[[satisfies assessment point 2: appropriately labels the dataset with descriptive names]]

3. Step 2. is repeated on the test dataset.

4. The data frames generated in step 2. and 3. are then row bound to create one dataset called "combine_data".

5. Only column names of "combined_data" containing information on "subject.id", "activity"
"std", and "mean" are retained by performing a grepl search and retaining columns with
the necessary indexes. The selected information is stored in a data frame called
"data_of_interest".
[[statisfies assessment point 2: extracts only the measurements on the mean and
standard deviation for each measurement]]

6. "data_of_interest" is then merged with the "activity_labels" so that all rows with
an activity.id is now associated with an activity description.
[[statisfies assessment point 3: uses descriptive activity names to name the activities
in the data set]]

7. "data_of_interest" is first grouped by activity, and then by subject.id. Following which, the grouped dataframe is summarized using the mean function.

[[statisfies assessement point 5: from the data set in step4, create a second,
independent tidy data set with the average of each variable for each activity and subject.

8. The output from 7. is then written into a txt file called "tidy_data.txt".







6.  



5.
