import mne
import os
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from glob import glob
from nilearn import datasets
from nilearn import plotting
from nilearn import surface
from nilearn.datasets import fetch_surf_fsaverage


subjects_dir = '/path_to_freesurfer/freesurfer_subjects'
subject = 'fsaverage_small'
os.environ['SUBJECTS_DIR'] = subjects_dir
src = mne.read_source_spaces(subjects_dir + '/fsaverage_small/bem/fsaverage_small-oct6-src.fif', verbose=False)
# For schaefer
labels = mne.read_labels_from_annot(
    subject= 'fsaverage_small', parc="Schaefer2018_200Parcels_17Networks_order", subjects_dir=subjects_dir
)

# Get label names
label_names = [label.name for label in labels[:-2]] 

src = mne.read_source_spaces(subjects_dir + '/fsaverage_small/bem/fsaverage_small-oct6-src.fif', verbose=False)
y_avg_coord = np.zeros(len(labels)-2)

for i in range(0,len(labels)-2):
    if i < 100:
        lh_coordinates = src[0]['rr'][labels[i].vertices]
        y_avg_coord[i] = lh_coordinates[:, 1].mean()
    else:
        rh_coordinates = src[1]['rr'][labels[i].vertices]
        y_avg_coord[i] = rh_coordinates[:, 1].mean()


df = pd.read_csv('/data/combined_data_final.csv')

plt.rcParams.update({'font.size': 16})  # Global font size

# Define parameter list
parameters = ['freq', 'power', 'high_exp','low_exp','x', 'y', 'z', 't0']

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


# Plotting average spatial gradient (across all age groups) on brain surface for visualization
fsaverage_directory = '/path_to_freesurfer/freesurfer_subjects/fsaverage_small/'
fsaverage = {
    'white_left': fsaverage_directory + 'surf/lh.white',
    'white_right': fsaverage_directory + 'surf/rh.white',
}

# Get background mesh
fs7 = fetch_surf_fsaverage(mesh='fsaverage')
lhc = surface.load_surf_data(fs7['curv_right'])

# Define ROI ID and remove nan values
df['roi_id'] = df.index % 200

# List feature and models to plot on brain
list_of_components = ['freq','power','high_exp','low_exp', 'x','y','z','t0']

# Get average for each ROI 
average = df.groupby('roi_id')[list_of_components].mean()

# Initialize the matrix with zeros
network_matrix = np.zeros(len(label_names), dtype=int)

# Assign values to the matrix based on label names and network_indices
for i, label_name in enumerate(label_names):
    for network, index in network_color_indices.items():
        if network in label_name:
            network_matrix[i] = index
            break

vertex_values = {}
num_vertices = 163842

roi_to_vertices = [label.vertices for label in labels[:-2]]
roi_values_stat = network_matrix

# Map the values from each ROI to the respective vertices
for stat in list_of_components:
    average_stat_all = average[stat]
    roi_values_stat = average_stat_all

    # Initialize vertex_values with NaN
    vertex_values[stat] = np.full(num_vertices, np.nan)

    # Map the values from each ROI to the respective vertices
    for roi_idx, vertices in enumerate(roi_to_vertices):
        vertex_values[stat][vertices] = roi_values_stat[roi_idx]
        
    title = stat.capitalize()
    vmin = round(np.nanmin(vertex_values[stat]), 2)
    vmax = round(np.nanmax(vertex_values[stat]), 2)
    
    # Note: For modelling parameter, color was changed in paper on figure, using cmap='PiYG' instead of 'Spectral'
    plotting.plot_surf_stat_map(fsaverage['white_right'], bg_map = lhc,bg_on_data=True, stat_map=vertex_values[stat],
                                hemi='right', view='lateral', vmin=vmin, vmax=vmax,
                                cmap='Spectral', colorbar=True, title=title)
    plt.show()