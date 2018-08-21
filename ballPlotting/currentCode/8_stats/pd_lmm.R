pd_lmm <- function(filename, type) {
  
  # Import nlme library
  library(nlme)
    
  # Read in data                                         
  mydata <- read.table(filename, header=TRUE, sep=",")
  
  # Make angle a factor
  mydata$angle = as.factor(mydata$angle)
  
  if (type == 'basic'){
    
    baseline <- lme(vel ~ 1, data = mydata, method = "ML")
    angleModel <- lme(vel ~ angle, data = mydata, method = "ML")
    
  } else if (type == 'rm'){
    
    baseline <- lme(vel ~ 1, random = ~1 | fly, data = mydata, method = "ML")
    angleModel <- lme(vel ~ angle, random = ~1 | fly, data = mydata, method = "ML")
    
  } else if (type == 'rm_uneven'){

    baseline <- lme(vel ~ 1, random = ~1 | fly, weights=varIdent(form=~1|angle), data = mydata, method = "ML")
    angleModel <- lme(vel ~ angle, random = ~1 | fly, weights=varIdent(form=~1|angle), data = mydata, method = "ML")
    
  }
  
  # Compare the models 
  print(anova(baseline, angleModel))
  
  # Print summary
  print(summary(angleModel))
  
  # Multiple comparisons
  library(multcomp)
  
  posthoc <- glht(angleModel, linfct = mcp(angle = "Tukey"))
  summary(posthoc)
  
}

