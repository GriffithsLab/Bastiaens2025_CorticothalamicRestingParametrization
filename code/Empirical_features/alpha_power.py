for subject in subject_list:
#     stc_psd = mne.read_source_estimate(f"/path_to_stc_psds/stc_results/sub-{subject}_stc_psd")
#     data_source_psd = stc_psd.data.T[:90,:]
#     freqs = stc_psd.times[:90]
#     closest_power = np.zeros(len(data_source_psd[0,:]))
#     for j in range(0,len(data_source_psd[0,:])):
#         fm = FOOOF(peak_width_limits=[1, 8], max_n_peaks=6)
#         fm.fit(freqs, 10**(data_source_psd[:,j]/10), [1, 40])
#         target_frequency = 10.0
#             # Check if fm.peak_params_ is not empty
#         if len(fm.peak_params_) > 0:
#             # Get indices of peaks within the frequency range
#             valid_idx = np.where((fm.peak_params_[:, 0] >= 7.5) & (fm.peak_params_[:, 0] <= 12.5))[0]
        
#             if len(valid_idx) > 0:
#                 # Find the index of the peak with the highest power in that range
#                 max_power_idx = valid_idx[np.argmax(fm.peak_params_[valid_idx, 1])]
#                 closest_power[j] = fm.peak_params_[max_power_idx, 1]
#             else:
#                 closest_power[j] = 0.0
#         else:
#             closest_power[j] = 0.0
#     final_power = np.array([closest_power,])   
#     np.save(f'/folder_to_save_results_power/sub-{subject}_alpha_power.npy', final_power)