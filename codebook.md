# Codebook for run_analysis.R

This codebook describes the variables, data, and work done to clean up the
dataset from the "Human Activity Recognition Using Smartphones" UCI Machine
Learning Repository

The objective of the script run_analysis.R is to ingest the data from the
UCI dataset and provide a summarised output showing the ensemble average
of the mean and standard deviation of the measurement variables for each
subject for each activity.

## Step 1: Data ingestion of information common to both training and test datasets

The activity labels and feature labels are being read in as data frames.
The names of the columns of the respective data frames are then updated with
meaningful labels.

**Code:**
```
activity_labels <- read.table("activity_labels.txt", header = FALSE, sep=" ")
feature_labels <- read.table("features.txt", header = FALSE, sep=" ")
names(activity_labels) <- c("activity.id", "activity")
names(feature_labels) <- c("feature.id", "feature")
```

**Data sources**

Data source           | Remarks
---                   | ---
activity_labels.txt   | txt file associating activity id with activity description
features.txt          | txt file listing measurement descriptions of the columns in X_train.txt or X_test.txt

**R variables**

R variables           | data type   | names()
---                   | ---         | ---
activity_labels       | df          | "activity id"; "activity"
feature_labels        | df          | "feature.id"; "feature"

## Step 2: Ingestion of training data

Training data comes in 3 different text files - subject_train.txt;
X_train.txt; and Y_train.txt. Information from these 3 text files are read in
first as separate data frames, labeled, and subsequently combined to form a
holistic dataset.

**Code:**
```
training_subjects <- read.table("./train/subject_train.txt", header = FALSE, sep = " ")
training_data <- read.table("./train/X_train.txt", header = FALSE)
training_activity <- read.table("./train/Y_train.txt", header = FALSE)

names(training_activity) <- "activity"                  
names(training_subjects) <- "subject.id"                
colnames(training_data) <- feature_labels[,2]

training_data <- cbind(training_activity, training_data)
training_data <- cbind(training_subjects, training_data)

rm(training_subjects, training_activity)           
```

**Data sources**

Data source           | Remarks
---                   | ---
subject_train.txt     | each row represents the subject.id associated with the observation
X_train.txt           | each row represents the measurement results associated with each observation
Y_train.txt           | each row represents the activity the subject carried out for the observation


**R variables**

R variables           | data type   | names()
---                   | ---         | ---
training_subjects     | df          | "subject.id"
training_activity     | df          | "activity"
training_data         | df          | "subject.id", "activity", ... list of features according to feature feature_labels

## Step 3: Ingestion of test data

Test data comes in 3 different text files - subject_test.txt;
X_test.txt; and Y_test.txt. Information from these 3 text files are read in
first as separate data frames, labeled, and subsequently combined to form a
holistic dataset.

**Code:**
```
test_subjects <- read.table("./test/subject_test.txt", header = FALSE, sep = " ")
test_data <- read.table("./test/X_test.txt", header = FALSE)
test_activity <- read.table("./test/Y_test.txt", header = FALSE)

names(test_activity) <- "activity"              # Note [1] (see section 4)
names(test_subjects) <- "subject.id"            # Note [1] (see section 4)
colnames(test_data) <- feature_labels[,2]       # Note [1] (see section 4)

test_data <- cbind(test_activity, test_data)
test_data <- cbind(test_subjects, test_data)

rm(feature_labels)
rm(test_subjects, test_activity)          
```

**Data sources**

Data source           | Remarks
---                   | ---
subject_test.txt      | each row represents the subject.id associated with the observation
X_test.txt            | each row represents the measurement results associated with each observation
Y_test.txt            | each row represents the activity the subject carried out for the observation


**R variables**

R variables           | data type   | names()
---                   | ---         | ---
test_subjects         | df          | "subject.id"
test_activity         | df          | "activity"
test_data             | df          | "subject.id", "activity", ... list of features according to feature feature_labels


## Step 4: Combining the training and test datasets

The training_data and test_data generated from step 2 and 3 is then combined
by binding the rows together.

```
combined_data <- rbind(test_data, training_data)
rm(test_data, training_data)
```

**Data sources**

nil

**R variables**

R variables           | data type   | names()
---                   | ---         | ---
training_data         | df          | "subject.id", "activity", ... list of features according to feature feature_labels
test_data             | df          | "subject.id", "activity", ... list of features according to feature feature_labels
combined_data         | df          | "subject.id", "activity", ... list of features according to feature feature_labels

## Step 5: Selecting all columns that are mean or standard

The exercise requires the script to extract only the measurements on mean and standard deviation for each measurement.
The R function grepl is used to search for relevant column names - "subject.id", "activity", "std", "mean".
The combined_data dataframe is then subsetted according to the consolidated logical vector to extract leaving only the
columns containing sbuject.id, activity, mean and std deviation information.

```
a<-grepl("subject.id", names(combined_data))
b<-grepl("activity", names(combined_data))
c<-grepl(".*std", names(combined_data))   
d<-grepl(".*mean", names(combined_data))
col_of_interest <- as.logical(a+b+c+d)
data_of_interest <- combined_data[, col_of_interest]
```

**Data sources**

nil

**R variables**

R variables           | data type   | names() | Remarks
---                   | ---         | ---     | ---
a                     | logical     | -       | logical vector identifying subject.id column
b                     | logical     | -       | logical vector identifying activity column
c                     | logical     | -       | logical vector identifying standard deviation columns
d                     | logical     | -       | logical vector identifying mean columns
col_of_interest       | logical     | -       | summed logical vector a to d
data_of_interest      | df          | -       | subsetted df of data_of_interest containing only columns of mean and std dev

## Step 6: Merging activity_labels and data_of_interest

The data_of_interest data frame contain activity information according to integer numbers to identify activity type.
By merging the activity_labels data frame with the data_of_interest, descriptive activity names are introduced
into the data_of_interest data frame.

```
data_of_interest <- merge(activity_labels, data_of_interest, by.x="activity.id", by.y="activity")
rm(combined_data, a, b, c, d, col_of_interest)
```

**Data sources**

nil

**R variables**

R variables           | data type   | names() | Remarks
---                   | ---         | ---     | ---
data_of_interest      | df          | "activity", "subject.id", ... mean and std dev parameters from feature list | df updated with activity description from activity_labels

## Step 7: Creating the tidy dataset of interest

The assignment requires the creation of a second, independent tidy dataset with the average of each variable
for each activity and each subject.

In data_of_interest, each subject may have participated in the same activity multiple times. As such, there
are multiple rows associated with the same subject performing the same activity. To achieve an ensemble
average, the group_by() function in the R package dplyr is used.

As activity.id is no longer required, it is also removed from the column of data_of_interest data frame.

The data_of_interest is first grouped by activity, then subject id. To compute the
ensemble mean for each subject, mean() function is applied to all mean and std deviation columns through the
summarised_all() function of the dplyr package.

```
library(dplyr)
data_of_interest <- data_of_interest %>% select(-activity.id)

tidy_data<-data_of_interest %>%
        group_by(activity, subject.id) %>%
        summarise_all(mean)
```

**Data sources**

nil

**R variables**

R variables           | data type   | names() | Remarks
---                   | ---         | ---     | ---
data_of_interest      | df          | "activity", "subject.id", ... mean and std dev parameters from feature list | updated to remove activity.id
tidy_data             | df          | "activity", "subject".id" ... ensemble avg of mean and std dev parameters from feature list | -
-
