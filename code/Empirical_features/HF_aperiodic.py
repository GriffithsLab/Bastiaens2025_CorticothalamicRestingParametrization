# Estimation of the HF aperiodic slope looping over all subject in subject list

import mne
import numpy as np
import os

all_exponents = {}
# Loop through each subject
for subject in subject_list:
    stc_psd = mne.read_source_estimate(f"stc_results/sub-{subject}_stc_psd")
    data_source_psd = stc_psd.data.T[:90, :]
    freqs = stc_psd.times[:90]
    exponent = np.zeros(len(data_source_psd[0, :]))

    for j in range(0, len(data_source_psd[0, :])):
        x = freqs[24:len(freqs)]
        y_dB= data_source_psd[24:len(freqs), j]

        # Fit: log10(frequency) vs dB power
        log_x = np.log10(x)
        coefficients = np.polyfit(log_x, y_dB, 1)
        slope, intercept = coefficients

        # Convert slope to 1/f exponent: slope = -10 * beta (because of power spectra is in dB)
        beta = -slope / 10
        exponent[j] = beta
    # Store the results for the current subject
    all_exponents[subject] = exponent