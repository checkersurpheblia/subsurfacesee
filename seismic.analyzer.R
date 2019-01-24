
seismic.analyzer <- function(input.stackedSection_1){
  # We analyze the spatial distribution of shear-wave
  # root-mean-squared velocity in from a 2-D perspective
  # in terms of its vertical/lateral characterisitics 
  # in the near-surface. Note that we are dealing with 
  # extremely slow velocities compared to most that 
  # deal with primary-wave (or P-wave) velocities 
  # usually observed and processed for oil/gas 
  # exploration and development
  
  # The first.only argument must be a 2-D matrix 
  # set according to the following format: col. 1
  # most be time (TWT) and all other columns are
  # shear-wave (or S-wave) seismic velocities.
  # The time vector and all observations of velocities
  # for each column are deliminated by a tab.
  # Note, also, that each velocity column is denoted 
  # by what is called in seismic geophysics a 'CDP' or
  # 'CMP'- if you want to know more about this, see:
  # https://wiki.seg.org/wiki/CMP_sorting
  
  
  ### SECTION 1 ###
  
  # Calculating/assign dimensions of input matrix
  input_matrix_seismic <- read.delim(file = input.stackedSection_1)
  allSize <- dim(input_matrix_seismic)
  row_count <- allSize[1]
  col_count <- allSize[2]
  
  # Create integer vector and covert to character 
  # for CDP/CMP names for each velocity column
  # and assingment to data frame (created below).
  cmp_list <- seq(from = 1, to = (col_count-1), by = 1)
  cmp_list <- as.character(cmp_list)
  
  # Create data frame for input matrix and 
  # name time and velocity columns accordingly
  # source(1): https://stackoverflow.com/questions/15885111/create-dataframe-from-a-matrix
  df_seismic_1 <- as.data.frame.array(x = input_matrix_seismic)
  colnames(df_seismic_1) <- c("TWT[s]", cmp_list)
  
  ### SECTION 2 ### 
  
  # Print summary of all basic velocity info by CDP/CMP number
  print(summary(df_seismic_1[,-1]))
  
  # Plot velocity model from input file as basic contour image
  filled.contour(z = data.matrix(t(df_seismic_1[,-1]), rownames.force = NA),
                 x = as.numeric(colnames(df_seismic_1[,-1])),
                 y = as.numeric(unlist(df_seismic_1[,1])),
                 ylim = rev(range(df_seismic_1[,1])),
                 color = rainbow,
                 plot.title=title(main = "Shear-Wave Velocity Model",
                                  xlab = "CMP",
                                  ylab = "TWT[s]"))
  
  # Provide generated velocity model dataframe as final output
  df_seismic_1
}