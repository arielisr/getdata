# run_analysis.R: parses input files from the UCI HAR Dataset, and prepares tidy data set

# set working directory, modify according to your configuration
setwd('d:/courses/getdata/UCI HAR Dataset')
# load the train and test datasets
train=read.table('train/X_train.txt',header=FALSE)
test=read.table('test/X_test.txt',header=FALSE)
# load their activity labels
train_activity=read.table('train/y_train.txt',header=FALSE)[[1]]
test_activity=read.table('test/y_test.txt',header=FALSE)[[1]]
# load the subject assignments
train_subject=read.table('train/subject_train.txt',header=FALSE)[[1]]
test_subject=read.table('test/subject_test.txt',header=FALSE)[[1]]
# add 100000 to the row.names of test, to distinguish them easily
row.names(test)=as.numeric(rownames(test))+100000
# merge train and test dataframes into the 'merged' data.frame
merged=rbind(train,test)
# read feature names
feature_names=read.csv('features.txt',sep=' ',header=FALSE)
# set the column names of the 'merged' dataframe to be the (R friendly 'make.names') of the features
colnames(merged)=make.names(feature_names[[2]])
# filter the feature names that have .mean. or .std. in their name
kept_columns=grep('[.](mean|std)[.]',colnames(merged),value=T)
# keep only these columns in the 'merged' data.frame
merged=merged[,kept_columns]
# use the merged activity as a factor
merged$activity=as.factor(c(train_activity,test_activity))
# use the descriptive labels, and add the activity column to the dataset
levels(merged$activity)=read.csv('activity_labels.txt',sep=' ',header=F)[[2]]
# add the merged subject as a factor
merged$subject=as.factor(c(train_subject,test_subject))
# use the data.table library, for easy 'groupby' operations
library(data.table)
DT=data.table(merged)
# create the second tidy dataset
tidy=DT[,lapply(.SD,mean),by=c('activity','subject')]
# write the file to disk
	
