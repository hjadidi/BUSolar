# BUSolar
Bayesian updating of long-term satellite-based GHI using ground measurements
-This MATLAB package updates prior distribution of long term hourly GHI using at least one year ground measurment
-The codes relates to the original paper in Solar Energy Journal with the subject of "Bayesian updating of solar resource data for risk mitigation in project finance" by H Jadidi et al.(2020).
-The code is written for a sample data (21 years satellite-based data and 4-years ground measurements).The code updates the distribution of hourly long-term GHI using ground measurements via Bayesian updating method. The details of the method is available at the mentioned paper. 
-To run the code two matrix as the inputs are essential:
1)The matrix of long term satellite-based GHI for a coordinate 
2)The matrix of available ground measured GHI for the selected coordinate  
The sample Excel file(SourceMCMC_NSRDB.xlsx) includes the two sample matrices.
-In addition, two functions are essential which should exist in the current directory to run the code. Here these functions are avialable in the package as follow:
1)Liklihood function (lk.m) 
2)Prior function (prior.m)
-The outputs of the code is "post" matrix. Each row of the matrix shows the estimated mean value(first column) and standard deviation(second column) of GHI posterior distribution.
