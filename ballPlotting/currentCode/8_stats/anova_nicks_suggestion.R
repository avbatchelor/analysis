install.packages('nlme')
install.packages('multcomp')

###################
# ANOVA 
library(nlme)

# Load the data 
#filename = 'D:/ManuscriptData/processedData/stats/diag_lat_vel.csv'
#filename = 'D:/ManuscriptData/processedData/stats/diag_forward_vel.csv'
filename = 'D:/ManuscriptData/processedData/stats/cardinal_forward_vel.csv'

mydata <- read.table(filename, header=TRUE, sep=",")

# Make angle a factor (N.B. doing this reduced the p value for the ANOVA - either way, still significant)
mydata$angle = as.factor(mydata$angle)

# Compact Model
baseline <- lme(vel ~ 1, random = ~1 | fly, data = mydata, method = "ML")

# Augmented Model
# ML is used rather than REML - have to do this for the likelihood ratio test
# The following two are equivalent 
# angleModel <- lme(vel ~ angle, random = ~1 | fly, data = mydata, method = "ML")
angleModel <- lme(vel ~ angle + (1 | fly), data = mydata, method = "ML")


# Compare the models 
anova(baseline, angleModel)

####################
# Multiple comparisons
library(multcomp)

posthoc <- glht(angleModel, linfct = mcp(angle = "Tukey"))
summary(posthoc)
