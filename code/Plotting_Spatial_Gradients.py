import mne
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from glob import glob


subjects_dir = '/path_to_freesurfer/freesurfer_subjects'
subject = 'fsaverage_small'
os.environ['SUBJECTS_DIR'] = subjects_dir
src = mne.read_source_spaces(subjects_dir + '/fsaverage_small/bem/fsaverage_small-oct6-src.fif', verbose=False)
# For schaefer
labels = mne.read_labels_from_annot(
    subject= 'fsaverage_small', parc="Schaefer2018_200Parcels_17Networks_order", subjects_dir=subjects_dir
)

src = mne.read_source_spaces(subjects_dir + '/fsaverage_small/bem/fsaverage_small-oct6-src.fif', verbose=False)
y_avg_coord = np.zeros(len(labels)-2)

for i in range(0,len(labels)-2):
    if i < 100:
        lh_coordinates = src[0]['rr'][labels[i].vertices]
        y_avg_coord[i] = lh_coordinates[:, 1].mean()
    else:
        rh_coordinates = src[1]['rr'][labels[i].vertices]
        y_avg_coord[i] = rh_coordinates[:, 1].mean()


combined_data = pd.read_csv('/path_to_data/combined_data.csv')
combined_data_trimmed = combined_data.groupby('Subject', group_keys=False).apply(lambda x: x.iloc[:-2]) # Cortical 200 ROIs

# Read participant information
participant_info = pd.read_csv('/path_to_info_age/participants.tsv', sep='\t', usecols=['participant_id', 'age'])
participant_info['participant_id'] = participant_info['participant_id'].str.replace('sub-', '')


merged_data = pd.merge(combined_data_trimmed, participant_info, left_on='Subject', right_on='participant_id', how='inner')
# Create age groups
bins = [18, 28, 38, 48, 58, 68, 78, 89]  # Define the boundaries for the age groups
labels = ['18-27', '28-37', '38-47', '48-57', '58-67', '68-77', '78-88']  # Define the labels for the age groups
merged_data['age_group'] = pd.cut(merged_data['age'], bins=bins, labels=labels, right=False)

plt.rcParams.update({'font.size': 16})  # Global font size

# Define parameter list
parameters = ['freq', 'power', 'high_exp','low_exp','x', 'y', 'z', 't0']
df = merged_data.dropna(subset=parameters + ['participant_id', 'age'])

# Group by age_group
age_groups = df.groupby('age_group')
n_params = len(parameters)
n_groups = len(age_groups)

# Create subplots: rows = parameters, columns = age groups
fig, axs = plt.subplots(n_params, n_groups, figsize=(6 * n_groups, 4.5 * n_params), sharey = 'row')

# Color index mapping
network_color_indices = {
    'Cont': 1,
    'Default': 29,
    'DorsAttn': 43,
    'Limbic': 54,
    'SalVentAttn': 60,
    'SomMo': 71,
    'TempPar': 185,
    'Vis': 90
}

for param_idx, param in enumerate(parameters):
    for group_idx, (age_group, data_group) in enumerate(age_groups):
        num_subjects = data_group['participant_id'].nunique()
        new_mat = data_group[param].values.reshape(num_subjects, 200)
        y_coord = new_mat.mean(axis=0)
        x_coord = y_avg_coord  # Assumed to be defined

        ax = axs[param_idx, group_idx]

        # Plot by network
        for net, label_index in network_color_indices.items():
            net_x = []
            net_y = []
            for idx, label in enumerate(label_names):
                if net in label:
                    net_x.append(x_coord[idx])
                    net_y.append(y_coord[idx])
            ax.scatter(net_x, net_y, color=labels[label_index].color, s=30)

        minval = data_group['age'].min()
        maxval = data_group['age'].max()
        ax.set_title(f'{param} - N={num_subjects}, Age {minval}-{maxval}', fontsize=20)
        ax.tick_params(axis='both', labelsize=14)

        if group_idx == 0:
            ax.set_ylabel(param, fontsize=18)
        if param_idx == n_params - 1:
            ax.set_xlabel('Posterior-Anterior Coordinate', fontsize=18)

plt.tight_layout()
plt.show()
