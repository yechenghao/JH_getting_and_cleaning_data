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
training_data         | df          | labeled in sequence according to feature_labels
training_activity     | df          | "activity"
training_data         | df          | "subject.id", "activity", ... list of features according to feature feature_labels
