import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import patsy
import statsmodels.formula.api as smf
from scipy.io import loadmat

# Load in data and keep 200 ROI results
combined_data = combined_data = pd.read_csv('/data/combined_data_final.csv')

# Get coordinates of ROIs and add it to the dataframe 
mat = loadmat('/data/ROI_coord.mat')
regions = mat['ROI_coord'][0]
repeated_regions = np.tile(regions[:-2],(len(combined_data)//len(regions[:-2])))
combined_data['region'] = repeated_regions
df = combined_data

# Run MLM analysis
# Define the mixed model formula
formula_freq = 'freq ~ x * age + y * age + z * age + t0 * age + x * region + y * region + z * region + t0 * region'

# Fit the model
model_freq = smf.mixedlm(formula_freq, df, groups=df['participant_id'])
result_freq = model_freq.fit()
print(result_freq.summary())

# For power
formula_power = 'power ~ x * age + y * age + z * age + t0 * age + x * region + y * region + z * region + t0 * region'
model_power = smf.mixedlm(formula_power, df, groups=df['participant_id'])
result_power = model_power.fit()
print(result_power.summary())

# For low_exp:
formula_low_exp = 'low_exp ~ x * age + y * age + z * age + t0 * age + x * region + y * region + z * region + t0 * region'
model_low_exp = smf.mixedlm(formula_low_exp, df, groups=df['participant_id'])
result_low_exp = model_low_exp.fit()
print(result_low_exp.summary())

# For high_exp:
formula_high_exp = 'high_exp ~ x * age + y * age + z * age + t0 * age + x * region + y * region + z * region + t0 * region'
model_high_exp = smf.mixedlm(formula_high_exp, df, groups=df['participant_id'])
result_high_exp = model_high_exp.fit()
print(result_high_exp.summary())
