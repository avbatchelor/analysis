## Functions in analysis\ballPlotting\currentCode 
	
**allPlotScript** > runs singleFlyAnalysis and plotProcessedDataBall for flies listed
    	
**groupBallDataDiffStim** > processes and groups single trials 
    	
**plotProcessedBallData** > makes plots 
    	
**plotTemperature** > plots temperature of behavior room by day 
    	
**rotateAllTrials** > rotates trials 
    	
**runAllAnalysisScript** > runs groupBallDataDiffStim for flies listed 
    	
**singleFlyAnalysis** > processes grouped data 

## Functions in analysis\ballPlotting\currentCode\groupAnalysis

**getFlyExpts** > lists out flies for each prefix code 

**loadProcessedData** > loads processed data given expt info 

**maxTrialNum** > calculates the maximum number of trials for which every fly has that many trials for each stimulus above the speed threshold

**multiFlyAnalysis** > makes plotData for multiple flies 

**numAboveThresholdTrials** > outputs number of fast trials for each fly given a prefix code and a threshold

## Single fly pipeline 

* groupBallDataDiffStim
	* rotateAllTrials
* singleFlyAnalysis 
* plotProcessedBallData

## Groups of flies pipeline
* groupBallDataDiffStim
	* rotateAllTrials
* multiFlyAnalysis
* plotProcessedBallData?
