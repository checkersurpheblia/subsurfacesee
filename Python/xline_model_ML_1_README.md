
# Simple Linear Regression with Seismic Velocity Data

The text file 'xline_twt_vel.txt' is needed for input 
for this Python script. If you've gone to the R directory
in subsurfacesee, then you may already be familiar with
this file. However, in case you're not, I'll give 
you the quick facts.

The content/structure of 'xline_twt_vel.txt' is as 
follows. The FIRST column is vector of two-way-time
data. ALL other columns retains unique data (velocity)
for each CMP. If these technical terms are unfamiliar, 
gomto the R directory and follow the links in the
README file.

The overall objective of this simple ML script is
to use a linear regression model to learn from 
training data - in our case, it is a predictor 
set as two-way-travel time (TWT) and a corresponding
target (i.e. seismic velocity). Given the training
data, we want to model what the velocity values
will be like at different depth ranges. Since 
seismic velocities are more or less ideally 
modeled as linear - particularly at small scales
such as this example - then maintaining and modeling
linear behavior is probably useful/accurate.

- Note that you can change which CMP is selected.
The user must manually provide that in the script.
Lastly, the subplot that is launched at the end 
may at first seem a little confusing. The first 
plot (on the left) shows TWT as the x-axis and 
velocity as the y-axis. But, for the right plot,
both the x- and y-axis shows test and predicted 
seismic velocitites.
