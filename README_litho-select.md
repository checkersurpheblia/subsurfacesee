
## A Preliminary Attempt at Near-Surface EC to Vs Transforms

There is a lot of research that has gone into calculating seismic velocities 
from only electrical conductivity (EC) well-logs. Somes info about facies or 
porosity is available (which is great!). However, for our case, we ONLY 
have EC. Morever, we are jumping from EC straight to shear-wave velocity,
which isn't conventioal at all. Best case scenarios for data include 
having facies (i.e. clay v. sand), porosity, and EC data together to calculate 
primary-wave (or p-wave) velocity. From there, shear-wave velocity is sometimes
estimated. The last factor I am not really considering here is that 
EC to seismic velcoity transforms as applied to data sets corresponding to 
subsurface enviroments that have at least undergone mid- to late-stage 
diagenisis.

With that, let's get to the code. This script is pretty simple. You 
run litho_select.m with the required input file (W5_EC.txt) in the 
PWD wherever litho_select resides. 

When the well-log is displayed, note that the vertical axis is in meters
and the lateral in LOG10 of resistivity (NOT EC). 

The main thing to note of how to use the graphical user interface with 
this plot (via ginput) is that relative increases of electrical resistivity (ER)
indicate more sand-rich facies while decreases may correspond to clay-rich facies.

![alt text](C:\Users\Nathan\Documents\Github_Stuff\Ec_to_Vs.jpg)

At any point, if you LEFT-click the log, all EC values at and above the depth 
at which is clicked will be classified as either clay or sand. For example,
if my first RIGHT click is ~9 m, then ALL values at and above that depth are classified 
as clay. Now, if I continue down and right click near 10 m, then ALL values at and above 
that depth BUT less than the depth of previous click are set as clay. The user must 
click (or classify) at least three points for this script to work. Also, note that 
a click entails clicking right (or left) and THEN pressing ENTER. Once you have entered 
at least three clicks, simply end the analysis/interpretation by clicking ENTER.
The output should look like what's displayed above.
