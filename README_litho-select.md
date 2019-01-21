
## A Preliminary Attempt at Near-Surface EC to Vs Transforms

There is a lot of research that has gone into calculating seismic velocities 
from only electrical conductivity (EC) well-logs. Sometimes, info about lithology and/or 
porosity is available (which is great!). However, for our case, we ONLY 
have EC. Morever, we are jumping from EC straight to shear-wave (or S-wave) velocity,
which isn't conventional at all. Best case scenarios for data include 
having lithology info (e.g. sand, sandy shale, shale, etc.), porosity, and EC data together 
to calculate primary-wave (or P-wave) velocity. From there, S-wave velocity is sometimes
estimated. The last factor I am not really considering here is that 
EC to seismic velocity transforms as applied to data sets corresponding to 
subsurface enviroments that have at least undergone mid- to late-stage 
diagenisis and are in eviroments much, much deeper than the subsurface we are looking at.

With that, let's get to the code. This MATLAB script is pretty simple. You 
run litho_select.m with the required input file ('W5_EC.txt') in the 
working directory wherever litho_select.m resides and is running. 

When the well-log is displayed, note that the vertical axis is in meters
and the lateral axis in LOG10 of resistivity (NOT EC). 

The main thing to note of how to use the graphical user interface with 
this plot (via ginput) is that relative increases of electrical resistivity (ER)
indicate more sand-rich lithologies while decreases may correspond to more
clay-rich ones.

At any point, if you **LEFT/RIGHT-click** the log once (with your mouse), all EC values at and 
above the depth at which is clicked will be classified as either **clay** or **sand**. For example,
if my first **RIGHT** click is ~9 m, then ALL values at and above that depth are classified 
as clay. Now, if I continue down (with increasing depth) and **LEFT** click near 10 m, then ALL 
values at and above that depth _BUT_ less than the depth of previous click are set as clay. 
The user must click (or classify) at least three points for this script to work. Also, note that 
a click entails clicking right (or left) and _THEN_ pressing **ENTER/RETURN**. Once you have entered 
at least three clicks, simply end the analysis/interpretation by clicking ENTER with no mouse 
click.
