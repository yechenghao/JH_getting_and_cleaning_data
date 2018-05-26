## Peer review assignment for getting and cleaning data

setwd("~/Coursera/R/Cleaning data/assignment4")
rm(list=ls())

# ---- ingestion of common data ----
# reads in as data frames the activity labels and feature labels from activity_labels.txt 
# and features.txt respectively. Thereafter, assign intutive names to the columns of the 
# activity_labels and feature_labels.  

activity_labels <- read.table("activity_labels.txt", header = FALSE, sep=" ")
feature_labels <- read.table("features.txt", header = FALSE, sep=" ")
names(activity_labels) <- c("activity.id", "activity")
names(feature_labels) <- c("feature.id", "feature")

#---- ingestion of training data ----
# reads in as data frames the subject id, the training data, and the activity id
training_subjects <- read.table("./train/subject_train.txt", header = FALSE, sep = " ")
training_data <- read.table("./train/X_train.txt", header = FALSE)
training_activity <- read.table("./train/Y_train.txt", header = FALSE)

# labeling the ingested data sets with descriptive names
# the training data will be labeled base don the feature names provided in features.txt
names(training_activity) <- "activity"                  # Note [1] (see section 4)
names(training_subjects) <- "subject.id"                # Note [1] (see section 4)
colnames(training_data) <- feature_labels[,2]           # Note [1] (see section 4)

# combining the trainng data, with the subject id, and activity id to form a hollistic training dataset
training_data <- cbind(training_activity, training_data)
training_data <- cbind(training_subjects, training_data)

rm(training_subjects, training_activity)

#---- ingestion of test data ----
# reads in as data frames the subject id, the test data, and the activity id
test_subjects <- read.table("./test/subject_test.txt", header = FALSE, sep = " ")
test_data <- read.table("./test/X_test.txt", header = FALSE)
test_activity <- read.table("./test/Y_test.txt", header = FALSE)

# labeling the ingested data sets with descriptive names
# the test data will be labeled base don the feature names provided in features.txt
names(test_activity) <- "activity"              # Note [1] (see section 4)
names(test_subjects) <- "subject.id"            # Note [1] (see section 4)
colnames(test_data) <- feature_labels[,2]       # Note [1] (see section 4)

# combining the test data, with the subject id, and activity id to form a hollistic test dataset
test_data <- cbind(test_activity, test_data)
test_data <- cbind(test_subjects, test_data)

rm(feature_labels)
rm(test_subjects, test_activity)

##---- combining the data ----
###########################################################
# 1. Merges the training and tet sets to create one data set
###########################################################

combined_data <- rbind(test_data, training_data)
rm(test_data, training_data)

##---- selecting all columns that are mean or std ---
###########################################################
# 2. Extracts only the measurements on the mean and 
# standard deviation for each measurement
###########################################################

a<-grepl("subject.id", names(combined_data))
b<-grepl("activity", names(combined_data))
c<-grepl(".*std", names(combined_data))   
d<-grepl(".*mean", names(combined_data))
col_of_interest <- as.logical(a+b+c+d)
data_of_interest <- combined_data[, col_of_interest]

###########################################################
# 3. Using only descriptive activity names to name the activities
# in the dataset
###########################################################

# merging of the activity_labels data frame with data frame holding
# solely the means and standard deviation of the various features of interest.
# By merging, the activity names will be associated placed aloneside the actividy id the data frame

data_of_interest <- merge(activity_labels, data_of_interest, by.x="activity.id", by.y="activity")
rm(combined_data, a, b, c, d, col_of_interest)

# since the activity id will no longer be used with the activity names being avaiable,
# the activity id column is discarded

library(dplyr)
data_of_interest <- data_of_interest %>% select(-activity.id)

###########################################################
# 4. Appropriately labels the data set with descriptive variable names
###########################################################
# Labeling of the data frame columns had been accomplished during ingestion of the data
# See "Note A" marker
# The names for the various means and standard deviation values had been labeled in 
# accordance to what was given in features.txt

##--- tidying data ---
###########################################################
# 5. From the data set in setep 4, create a second, independent tidy dataset with the 
# average of each variable for each activity and each subject
###########################################################

# each subject may have participated in the same activity multiple times. 
# to collapse the ensemble of values associated with each subject and each activity into
# a mean value, the group_by() technique in dplyr library is used

# group_by first activity, then subject id; thereafter for these groupings
# evaluate the mean for every variable (i.e. columns)

tidy_data<-data_of_interest %>% 
        group_by(activity, subject.id) %>%
        summarise_all(mean)

write.table(tidy_data, "tidy_data.txt", sep = ",", row.names = FALSE)
