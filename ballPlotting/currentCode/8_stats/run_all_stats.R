# Run all stats 

# Change to stats directory 
setwd('C:/Users/Alex/Documents/GitHub/analysis/ballPlotting/currentCode/8_stats')

# import functions 
source('pd_lmm.R')

# Figure 2 - basic

# Figure 3 - gluing a2 vs. a3

# Figure 4 - gluing left/right a3

# Figure 6 - diag
filename = 'D:/ManuscriptData/processedData/stats/diag_lat_vel.csv'
pd_lmm(filename,'rm')

filename = 'D:/ManuscriptData/processedData/stats/diag_forward_vel.csv'
pd_lmm(filename,'rm')

# Figure 7 - cardinal - part 1 


# Figure 7 - cardinal - part 2 
filename = 'D:/ManuscriptData/processedData/stats/cardinal_lat_vel.csv'
pd_lmm(filename,'rm_uneven')

filename = 'D:/ManuscriptData/processedData/stats/cardinal_forward_vel.csv'
pd_lmm(filename,'rm')

# Figure 8 - freq.  NB. I renamed the frequency to 'angle' just so I could reuse the same code. 
filename = 'D:/ManuscriptData/processedData/stats/freq_lat_velpips.csv'
pd_lmm(filename,'rm_uneven')

filename = 'D:/ManuscriptData/processedData/stats/freq_lat_veltones.csv'
pd_lmm(filename,'rm_uneven')

filename = 'D:/ManuscriptData/processedData/stats/freq_forward_velpips.csv'
pd_lmm(filename,'rm')

filename = 'D:/ManuscriptData/processedData/stats/freq_forward_veltones.csv'
pd_lmm(filename,'rm')

# Figure 9 - male vs. female

