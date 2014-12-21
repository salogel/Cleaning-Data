#Load Data
Activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
Features <- read.table("./data/UCI HAR Dataset/features.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Extracts only the measurements on the mean and standard deviation for each measurement.
#And load activity data
Extract_features <- grepl("mean|std", Features$V2)
names(x_test) = Features$V2
x_test = x_test[,Extract_features]
y_test$V2 = Activitylabels$V2[y_test$V1]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "Subject"

names(x_train) = Features$V2
x_train = x_train[,Extract_features]
y_train$V2 = Activitylabels$V2[y_train$V1]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "Subject"

#Merges the training and test data
Testdata <- cbind(subject_test, y_test, x_test)
Traindata <- cbind(subject_train, y_train, x_train)
Newdata = rbind(Testdata, Traindata)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
Newdata<-data.table(Newdata)
Tidydata<-Newdata[,lapply(.SD,mean),by=list(Subject, Activity_ID, Activity_Label)]

write.table(Tidydata, file = "./tidy_data.txt")