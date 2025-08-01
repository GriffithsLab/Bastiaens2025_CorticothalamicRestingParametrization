subjects_dir = '/path_to_freesurfer/freesurfer/'
subject = 'fsaverage_small'
os.environ['SUBJECTS_DIR'] = subjects_dir

# For schaefer
labels = mne.read_labels_from_annot(
    subject= 'fsaverage_small', parc="Schaefer2018_200Parcels_17Networks_order", subjects_dir=subjects_dir
)

# Folder with source psd
source_estimate_folder = "/path_to_source_psd/stc_results"

subject_names = list({f.split('_')[0][4:] for f in os.listdir(source_estimate_folder) if f.startswith("sub-") and f.endswith("_stc_psd-lh.stc")})

# Initialize 
all_subject_data = []

# Loop through each subject file
for subject_name in subject_names:
    # Load source estimate data
    stc_psd = mne.read_source_estimate("/path_to_source_psd/stc_results/sub-"+ subject_name + "_stc_psd")
    data_source_psd = stc_psd.data.T[:90, :]
    freqs = stc_psd.times[:90]
    
    # Computes the average psds in every label in Shaeffer
    average_psds = [np.mean(stc_psd.in_label(label).data, axis=0)[1:90] for label in labels]

    # Store data for the current subject
    subject_data = {'average_psds': average_psds, 'freqs':stc_psd.times[1:90], 'subject_names': subject_name}
    all_subject_data.append(subject_data)

# Save the data for all subjects
#io.savemat('/lustre07/scratch/bastiaen/fit_camcan/ROI_matlab/psds_average_labels.mat', {'all_subject_data': all_subject_data})
