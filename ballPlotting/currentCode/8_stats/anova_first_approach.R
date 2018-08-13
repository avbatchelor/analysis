filename = 'D:/ManuscriptData/processedData/stats/diag_lat_vel.csv'
mydata <- read.table(filename, header=TRUE, sep=",")

latVel.aov <- with(mydata,aov(vel ~ angle + Error(fly) ))

summary(latVel.aov)
