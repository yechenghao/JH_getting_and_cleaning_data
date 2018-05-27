#Codebook for run_analysis.R

This codebook describes the variables, data, and work done to clean up the
dataset from the "Human Activity Recognition Using Smartphones" UCI Machine
Learning Repository

The objective of the script run_analysis.R is to ingest the data from the
UCI dataset and provide a summarised output showing the ensemble average
of the mean and standard deviation of the measurement variables for each
subject for each activity.

## Step 1: Data ingestion of information common to both training and test datasets

```
activity_labels <- read.table("activity_labels.txt", header = FALSE, sep=" ")
feature_labels <- read.table("features.txt", header = FALSE, sep=" ")
names(activity_labels) <- c("activity.id", "activity")
names(feature_labels) <- c("feature.id", "feature")
```

Data source           | Remarks
----                  | ----
activity_labels.txt   | txt file associating activity id with activity description
----                  | ----
features.txt          | txt file listing measurement descriptions of the columns in X_train.txt or X_test.txt

 
