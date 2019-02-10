
#------------------------------------------------------------------------------
# Builder: Nathan Benton
# Name: xline_model_ML_1.py
# Description: uses velocity data from 1-D profiles, generates linear
# regression model from a selected CMP, and applies a learned model according
# to various depth ranges
# Date Created: 01/15/2019
# Date Modified: 02/08/2019
# NOTES: much of the content and overall structure for this script was made
# with insight provided by 'Hands-On Machine Learning with Python'
# Anderson (2018).
#------------------------------------------------------------------------------

# Import all necessary modules
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score
import pandas as pd

# Load CSV file into Pandas dataframe
vmodel_1 = pd.read_csv('xline_vmodel_1.csv', header=None)

# Convert dataframe values to matrix
vmodel_1_matrix = vmodel_1.values

# Take single CMP (with TWT and corresponding velocity data) set

# The predictor (or independent variable) is set as TWT
# or two-way-travel time
cmp_x_twt = vmodel_1_matrix[:,0]

# Likewise, the dependant variable (or target) I set is velocity.
# There, each column - other than the first 'cmp_x_twt' - is
# a vector of velocity values according to CMP, of which are 60
cmp_x_vel = vmodel_1_matrix[:,30]

# Separate TWT/Velocity info info training/testing data sets
# Method 1
cmp_x_twt_train, cmp_x_twt_test,cmp_x_vel_train,cmp_x_vel_test \
    = train_test_split(cmp_x_twt,
                       cmp_x_vel,
                       test_size=0.1)

# Method 2 - 'harder way to do it'
# Training data
#cmp_x_twt_train = cmp_x_twt[:-100]
#cmp_x_vel_train = cmp_x_vel[:-100]
# Testing data
#cmp_x_twt_test = cmp_x_twt[-100:]
#cmp_x_vel_test = cmp_x_vel[-100:]

# Generate linear regression object for later use
twt_vel_regr_1 = LinearRegression()

# Train the model using the training sets
twt_vel_regr_1.fit(cmp_x_twt_train.reshape(-1,1),
                   cmp_x_vel_train)

# Using regression model, predict target values
cmp_x_vel_pred = twt_vel_regr_1.predict(cmp_x_twt_test.reshape(-1,1))

# Statistical overview of predicted results and metrics of model/data
print("Total number of data point pairs: ", len(cmp_x_twt))
print("Number of training point pairs: ", len(cmp_x_twt_train))
print("Number of testing point pairs: ", len(cmp_x_twt_test))
print("-------------------------------------")
print('Regression Coefficient: \n', twt_vel_regr_1.coef_)
print("Mean squared error: ",
      mean_squared_error(cmp_x_vel_test,
                         cmp_x_vel_pred))
print('Variance score: %.2f' % r2_score(cmp_x_vel_test,
                                        cmp_x_vel_pred))

# Plot predicting results from training model to test data
# This subplot shows two images: the first is a scatter
# displaying the raw data (TWT v. velocity) and the second
# shows the best-fit line going through the raw points
plt.subplot(1,2,1)
plt.scatter(cmp_x_twt,
            cmp_x_vel,
            color='black')
plt.xlabel('TWT [s] - Test')
plt.ylabel('Velcocity [m/s] - Test')
plt.plot(cmp_x_twt_test,
         cmp_x_vel_pred,
         color='red')
plt.grid(True)

# The plot below displays a scatter displaying predicted
# and test velocity values
plt.subplot(1,2,2)
plt.scatter(cmp_x_vel_test,
            cmp_x_vel_pred,
            color='blue')
plt.xlabel('Velocity [m/s] - Test')
plt.ylabel('Velocity [m/s] - Predicted')

plt.grid(True)
plt.show()