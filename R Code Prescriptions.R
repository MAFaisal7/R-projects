#loading data
library(readr)
install.packages("dplyr")
install.packages("caret")
install.packages("tidyverse")
library(caret)
library(tidyverse)
library(dplyr)
#Install data.table- allows working with large dataset
install.packages("data.table")
library(data.table)
#Loading data
July<- read_csv("C:/Users/blasii/Desktop/Data/July 20190805_1564992117356_Detailed_Prescribing_Information.csv")
August <- read_csv("C:/Users/blasii/Desktop/Data/Aug 20190805_1564992471122_Detailed_Prescribing_Information.csv")
September <- read_csv("C:/Users/blasii/Desktop/Data/Sep 20190805_1564992493298_Detailed_Prescribing_Information.csv")
October <- read_csv("C:/Users/blasii/Desktop/Data/Oct 20190805_1564992548458_Detailed_Prescribing_Information.csv")
November <- read_csv("C:/Users/blasii/Desktop/Data/Nov 20190805_1564992680505_Detailed_Prescribing_Information.csv")
December<- read_csv("C:/Users/blasii/Desktop/Data/Dec 20190805_1564992709561_Detailed_Prescribing_Information.csv")
#Adding column to each data set with Month
July$Month=c("July")
August$Month=c("August")
September$Month=c("September")
October$Month=c("October")
November$Month=c("November")
December$Month=c("December")
August

#Merging 6 files together
Data1<-rbind(July,August,September,October,November,December)
Data1
summary(Data)
#after data is merged I extracted  two needed columns
reordered1<-Data[,c(15,16)]
reordered1
plot(`Actual Cost`~`Month`)
lm(reordered1$`Actual Cost`~reordered1$`Month`)

#Saving dataframe to csv file
write.csv(July,"July.csv")

#TO DELETE columns from dataframe
July[[17]]<-NULL
July[[17]]<-NULL
July
