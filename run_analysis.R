## load data
folder <- '~/Desktop/Coursera/getdata/project/UCI HAR Dataset/'
X_train <- read.table(paste(folder, 'train/X_train.txt', sep=''))
y_train <- read.table(paste(folder, 'train/y_train.txt', sep=''))
subject_train <- read.table(paste(folder, 'train/subject_train.txt', sep=''))
X_test <- read.table(paste(folder, 'test/X_test.txt', sep=''))
y_test <- read.table(paste(folder, 'test/y_test.txt', sep=''))
subject_test <- read.table(paste(folder, 'test/subject_test.txt', sep=''))
features <- read.table(paste(folder, 'features.txt', sep=''))
activity_labels <- read.table(paste(folder, 'activity_labels.txt', sep=''))

## Merges the training and the test sets to create one data set.
xtt <- rbind(X_train, X_test)

## Extracts only the measurements on the mean and standard deviation
## for each measurement.
fms <- subset(features, grepl('mean',V2)|grepl('std',V2))
ttms <- subset(xtt, select=fms$V1)

## Appropriately labels the data set with descriptive variable names
names(ttms) <- fms$V2

## Appends 'y' and 'subject'
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
names(y) <- 'y'
names(subject) <- 'subject'
tt <- cbind(ttms, y, subject)

## Uses descriptive activity names to name the activities
## in the data set
names(activity_labels) <- c('y', 'activity')
tt <- merge(tt, activity_labels)
tt <- subset(tt, select=-c(y))
tt$activity <- as.character(tt$activity)

## Creates a second, independent tidy data set with the average
## of each variable for each activity and each subject.
dat <- by(tt[,2:80], list(tt$activity,tt$subject), FUN=colMeans)

## Write data set
write.table(dat, file=paste(folder,'../dat.txt',sep=''), row.names=F, col.names=F)
