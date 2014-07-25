##import the data
train<-read.table("C://Users//tnt//Documents//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//X_train.txt")
trainlabel<-read.table("C://Users//tnt//Documents//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//y_train.txt")
trainsbj<-read.table("C://Users//tnt//Documents//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//train//subject_train.txt")
test<-read.table("C://Users//tnt//Documents//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//test//X_test.txt")
testlabel<-read.table("C://Users//tnt//Documents//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//test//y_test.txt")
testsbj<-read.table("C://Users//tnt//Documents//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//test//subject_test.txt")

dim(train)
dim(trainlabel)
dim(trainsbj)
dim(test)
dim(testlabel)
dim(testsbj)

 ##Creating the last two column for both train and test dataset to label activity groups and subjects


trainall<- cbind(train,trainlabel[,1],trainsbj[,1])

testall<- cbind(test,testlabel[,1],testsbj[,1])


features<- read.table("C://Users//tnt//Downloads//getdata-projectfiles-UCI HAR Dataset//UCI HAR Dataset//features.txt",stringsAsFactors=FALSE)
varnames<-c(features[,2],"actclass","subjects")

##1.Merges the training and the test sets to create one data set.
dim(trainall)
dim(testall)
alldata<- rbind(as.matrix(trainall),as.matrix(testall))
dim(alldata)
alldata<- as.data.frame(alldata)
names(alldata)<- varnames
names(alldata)


##2. Extracts only the measurements on the mean and standard deviation for each measurement.
actclass=alldata$actclass
subjects=alldata$subjects
alldatasub<-cbind(alldata[,grep("*(M|m)ean\\()*|*std*", colnames(alldata), value=TRUE)],actclass,subjects)
dim(alldatasub)
head(alldatasub$actclass)
alldatasub$actclass<- as.factor(alldatasub$actclass)
levels(alldatasub$actclass)
##3. Uses descriptive activity names to name the activities in the data set
levels(alldatasub$actclass) <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING", "STANDING","LAYING")
str(alldatasub$actclass)
##the activity col now is replaced with descripting texts
alldatasub[1,66:68]

##4.Appropriately labels the data set with descriptive variable names. 
## I've already done this above

##Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

dim(alldatasub)
#Reshape my data
library(reshape)
v=varnames[1:66]
mdata <- melt(alldatasub, id=c("actclass","subjects"))
tidymeans <- cast(mdata, subjects+actclass~variable, mean)
dim(tidymeans)
head(tidymeans,1)
write.table(tidymeans, file = "tidydata.txt", row.names = F)
