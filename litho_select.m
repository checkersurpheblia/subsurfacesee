
% % Author: Nathan Benton 
% % Description: accepts EC (mS/m) and Depth (m) as single input file  
% % and then uses 'ginput' to select certain ranges of depth/EC pairs 
% % to approximate lithology - note that the only purpose of this script
% % is to find and select which lithology is at which depth (i.e., the 
% % EC/ER value that is simultaneously evaluated in section 1 is NOT 
% % important - the only data we care about it the depth/litho pair 
% % Created: 03/14/17
% % Modified: (v.1)->03/26/15, (v.2)->03/30/17, (v.3)->04/01/17
% % (v.4)->04/06/17, (v.5)->04/26/17
% % Special Note: for each run of this script, the clc and clear 
% % must remain - it clears all memory before each interation 
% -------------------------------------------------------------------

                            %---SECTION 1---%
% % Objective: to convert units to match HAY data and to perform 
% % graphical input via 'ginput' to select depth/litho pairs 

clc; clear all; %clear all current memory 

%accept user input and assign to variables for EC(S/m) and depth[m]
all_data=dlmread('W5_EC.txt');    %manually provide input file 
depth=all_data(:,1); ec=all_data(:,2)/1000; %mS/m to S/m

%change EC to LOG10[RES]
for i1=1:size(all_data,1),
    if(ec(i1)==0)   %special case of when EC/RC is zero 
        er(i1)=0;   %if array element=0, then assign (remain) zero 
        erLOG10(i1)=ec(i1);
        continue;   %if condition is met, loop returns to control 
    end
    er(i1)=1/ec(i1);
    erLOG10(i1)=log10(er(i1));
end

%assign log10(ER) to column 2 of all_data for later use in section 4
all_data(:,2)=erLOG10;


%plotting and special formatting of plot 
figure; hold on; grid on; set(gca,'Ydir','reverse');    %reverse y-axis 
plot(erLOG10,depth); xlim([0,2]);   %generate 2-D plot and set x-axis lim
title('LOG_{10}[RES] v. Depth [m]') %main title 
xlabel('LOG_{10}[RES]');   %x-axis title 
ylabel('Depth [m]');    %y-axis title 

%select possible ranges for given litho types via user (graphical) input
i=1;    %counter and index used in looping 
while('true')   %while-loop continues until short-circuit by 'break'

    %input and launch plot
    %note: mouse click on far left generates a 1 value and the far right 
    %generates a 3 -> 1=clay and 3=sand [the middle button gives 2, but 
    %there is no need for that yet
    %special note: only click the mouse ONCE for each enter - if the mouse 
    %is clicked more than once, the entire program will fail 
  
    %prompt for user input
    fprintf('Cell: %d -> Select Range of Litho Type: \n',i);
    fprintf('***NOTE: left click for CLAY and right click for SAND. \n');
    
    %user input via ginput - remember that we only care about the 
    %depth/litho pair - NOT the ER/EC value
    [selected_ec,selected_depth,litho_type_button]=ginput();

    %empty array/cell from ginput to short circuit loop
    if(isempty(selected_ec(:)))
        hold off;
        fprintf('\n~NOTHING ENTERED -> CELL %d WILL BE DISREGARDED~\n',i);
        break;  
    end
    
    %add references line of current depth - don't pick points above it
    hline=refline([0 selected_depth]);  %no slope (o) and y-intercept 
    hline.Color='r';    %color type for horizontal line 
    
    %the litho_cells cell data type will be used in section two 
    %for further processing of ER, Depth, and Litho data triplets 
    litho_cells{i}=[selected_ec,selected_depth,litho_type_button];

    i=i+1; %update index/counter 
end

                            %---SECTION 2---%
% % Objective: to accept data from section 1 and take data from cell
% % and convert/transfer data to arrays for later processing   
                            
total_size=size(litho_cells,2); %total size of array from section 1 loop 

%arrays corresponding to ER/EC, depth, and litho are populated with zeros
all_ER=zeros(1,total_size); 
all_DEPTH=zeros(1,total_size);
all_LITHO=zeros(1,total_size);

for i1=1:size(litho_cells,2),
    %data from the litho_cells are assigned to seperate arrays
    all_ER(:,i1)=litho_cells{1,i1}(1,1); 
    all_DEPTH(:,i1)=litho_cells{1,i1}(1,2);
    all_LITHO(:,i1)=litho_cells{1,i1}(1,3);
end     

%all data from section 1 and 2 are now combined into single array 
ALL=[all_ER; all_DEPTH; all_LITHO]; %all data types now concatenated     
ALL=ALL';   %take transpose to format correctly                                                                                          
                                                      
                            %---SECTION 3---%                           
% % Objective: to accept data from section 2 and combine litho type with
% % all depth/EC/litho data into single array

%this loop will fail if the user only selected one point - there must be 
%at least two points in order for this evaluation to work
last=size(ALL,1);   %for last interation of second loop
for i1=1:size(ALL,1),   %first loop start 
    for i2=1:size(all_data,1),  %second loop start 
        %for the first depth value 
        if(i1==1 && all_data(i2,1)<=ALL(1,2))
            all_data(i2,3)=ALL(i1,3);
        end
        %for all middle values
        if(i1~=1 && i1~=last && all_data(i2,1)<=ALL(i1,2) && all_data(i2,1)>ALL(i1-1,2))
            all_data(i2,3)=ALL(i1,3);
        end 
        %for the last value
        if(i1==last && all_data(i2,1)<=ALL(last,2) && all_data(i2,1)>ALL(i1-1,2))
            all_data(i2,3)=ALL(i1,3);
        end 
    end %end of second loop
end %end of first loop                            
                            
                            %---SECTION 4---%                           
% % Objective: calculates acoustic impedance (AI) from EC to velocity 
% % based on HAY data - thus this transform is not a direct calculation 
% % instead it is merely a replacement of EC to s-wave velocity         
          
%read in and assign HAY data for EC/ER to velocity replacement 
%note: the way the that the HAY txt file is arranged is - from left 
%to right - the columns are arranged from log10(RES), V_s, and soil type 
HAY_1_Vs_LOG10R_ST=dlmread('HAY_1_Vs_LOG10R_ST.txt');

%modify litho type value from section 1 to compare with HAY data set,
%which retains values around ~1.0 for clay and ~2.0 for sand - normal 
%values for c_max and s_max are 1.4 and 2.3, respectively
c_max=input('\nEnter MAX threshold value for CLAY: \n');
s_max=input('Enter MAX threshold value for SAND: \n');

%this loop takes c_max and s_max and replaces the original litho type 
%values from section 1 with user input shown above 
for i1=1:size(all_data,1),
    if(all_data(i1,3)==3)
        all_data(i1,3)=s_max;
    end
    if(all_data(i1,3)==1)
        all_data(i1,3)=c_max;
    end
end

%the loop below serves to compare HAY data (imported above)
%with the imported well data - in the process of this "comparing" section,
%the min error between well ER and HAY ER is calculated. 
%whichever Vs/ER pair results in the best value, the Vs is assigned to 
%cell of the well data for a given litho type, ER, and depth triplet
for i1=1:size(all_data,1),    %first loop - i1 
    least_ab_error_win=100000000;   %sloppy coding, but neccessary 
    for i2=1:size(HAY_1_Vs_LOG10R_ST,1), %second loop - i2
        %for the clay 
        if(HAY_1_Vs_LOG10R_ST(i2,3)<=all_data(i1,3))
            least_ab_error_temp=((abs(all_data(i1,2)- ...
            HAY_1_Vs_LOG10R_ST(i2,3)))/all_data(i1,2))*100;
            if(least_ab_error_temp<least_ab_error_win)  
                 %least absolute error between well and HAY data 
                 least_ab_error_win=least_ab_error_temp;
                 %assign Vs based from ER error
                 all_data(i1,4)=HAY_1_Vs_LOG10R_ST(i2,1);
                 %assign best error
                 all_data(i1,5)=least_ab_error_win;
            end
        end
        
        %for the sand
        if(HAY_1_Vs_LOG10R_ST(i2,3)<=all_data(i1,3) && HAY_1_Vs_LOG10R_ST(i2,3)>c_max)
            least_ab_error_temp=((abs(all_data(i1,3)- ...
            HAY_1_Vs_LOG10R_ST(i2,3)))/all_data(i1,3))*100;
            if(least_ab_error_temp<least_ab_error_win)
                 %least absolute error between well and HAY data 
                 east_ab_error_win=least_ab_error_temp;
                 %assign Vs based from ER error
                 all_data(i1,4)=HAY_1_Vs_LOG10R_ST(i2,1);    
            end
        end
    end   %end of loop 2
end    %end of loop 1

%all processed data is arranged below (as columns) to depth, Vs, and
%density - note that density is a constant one for simplification 
d_Vs_rho=[all_data(:,1),all_data(:,4),ones(size(all_data,1),1)];

%plot velocity log with respect to depth
figure; hold on; grid on; set(gca,'Ydir','reverse');
plot(all_data(:,4),all_data(:,1))
title('Shear-Wave Velocity v. Depth') %main title 
xlabel('Velocity [m/s]');   %x-axis title 
ylabel('Depth [m]');    %y-axis title 

%ginput is now used to pick a general velocity trend 
%[vel,depth]=ginput();
%vel=smooth(all_data(:,4),'moving');
%figure; hold on; grid on; set(gca,'Ydir','reverse');
%plot(vel,all_data(:,1));
%title('Low-Pass');
  
