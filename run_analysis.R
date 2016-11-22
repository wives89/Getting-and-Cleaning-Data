#Call relevant packages
library(plyr)
library(dplyr)

## Read in test data
xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
subjecttest <- read.table("test/subject_test.txt")

## Combine the test data into 1 table
test <- cbind(ytest,subjecttest,xtest)

## Read in train data
xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
subjecttrain <- read.table("train/subject_train.txt")

## Combine the train data into 1 table
train <- cbind(ytrain,subjecttrain,xtrain)

## Comine train and test data into full data set
full <- rbind(train, test)

## pull in column headers and activity headers
headers <- read.table("features.txt")
activitylabels <- read.table("activity_labels.txt")

## Rename activitylabels columns and change headers to strings
names(activitylabels) <- c("ActivityNumber", "Activity")
headers$V2 <- as.character(headers$V2)

## Rename columns based on headers
pracheaders <- c("ActivityNumber","SubjectNumber", headers$V2)
names(full) <- pracheaders

##Find and select mean/std columns
mstd <- grep("[Mm]ean\\(|[Ss][Tt][Dd]\\(",headers$V2)+2
mstd <- c(1,2,mstd)

## Pull out and re-order only relevent columns
trimmed <- full[,mstd]
final <- merge(trimmed,activitylabels)
final <- select(final, SubjectNumber, Activity,contains("mean"), contains("std"))
final <- arrange(final, SubjectNumber, Activity)

## write clean data to csv
write.table(x = final, file = "activitydata.txt")

summary <- final %>% 
group_by(Activity, SubjectNumber) %>%
summarise_each(funs(mean))

write.table(x = final, file = "datasummary.txt")

