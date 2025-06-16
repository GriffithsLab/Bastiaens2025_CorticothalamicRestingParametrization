import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import patsy
import statsmodels.formula.api as smf
from scipy.io import loadmat

# Prepare data for MLM analysis 
# Load in data and keep 200 ROI results
combined_data = combined_data = pd.read_csv('/path_to_data/combined_data.csv')
combined_data = combined_data.groupby('Subject', group_keys=False).apply(lambda x: x.iloc[:-2])

# Get participant age
participant_info = pd.read_csv('/path_to_data/participants.tsv', sep='\t', usecols=['participant_id', 'age'])
participant_info['participant_id'] = participant_info['participant_id'].str.replace('sub-', '')

merged_data = pd.merge(combined_data, participant_info, left_on='Subject', right_on='participant_id', how='inner')

# Get coordinates of ROIs and add it to the dataframe 
mat = loadmat('/path_to_data/ROI_coord.mat')
regions = mat['ROI_coord'][0]
repeated_regions = np.tile(regions[:-2],(len(combined_data)//len(regions[:-2])))
merged_data['region'] = repeated_regions
df = merged_data.dropna(subset=['x', 'y', 'z', 't0', 'power', 'freq', 'low_exp', 'high_exp', 'participant_id', 'age', 'region'])


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
