
install.packages('userfriendlyscience')

# Load the data 
#filename = 'D:/ManuscriptData/processedData/stats/bilat_gluing_lat_vel.csv'
filename = 'D:/ManuscriptData/processedData/stats/bilat_gluing_forward_vel.csv'
mydata <- read.table(filename, header=TRUE, sep=",")

# Run Welch's ANOVA 
oneway.test(vel ~ glueStatus, data=mydata, var.equal=FALSE)

# Multiple comparisons
library(userfriendlyscience)

one.way <- oneway(mydata$glueStatus, y = mydata$vel, posthoc = 'games-howell')
one.way

