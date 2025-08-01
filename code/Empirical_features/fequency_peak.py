# Estimation of the alpha frequency peak for one subject for all source PSD

import mne
import numpy as np
from scipy.signal import find_peaks, find_peaks_cwt
import os
from fooof import FOOOF
from fooof.sim.gen import gen_aperiodic

stc_psd = mne.read_source_estimate(f"stc_results/sub-{subject}_stc_psd")
data_source_psd = stc_psd.data.T[:90,:]
freqs = stc_psd.times[:90]
final_alpha = np.zeros(len(data_source_psd[0,:]))
for j in range(0,len(data_source_psd[0,:])):
    fm = FOOOF()
    fm.fit(freqs, 10**(data_source_psd[:,j]/10), [2, 40])
    init_ap_fit = gen_aperiodic(fm.freqs, fm._robust_ap_fit(fm.freqs, fm.power_spectrum))
    init_flat_spec = fm.power_spectrum - init_ap_fit
    peakind_alpha = find_peaks_cwt(init_flat_spec[11:20], np.arange(0.01,20))
    if peakind_alpha.size > 0:
        pos_alpha =  np.argmax(init_flat_spec[11 + peakind_alpha])        
        final_alpha[j] = fm.freqs[11 + peakind_alpha[pos_alpha]]
    else:
        final_alpha[j] = 0.0
final_alpha = np.array([final_alpha,])
np.save('fr_peak_array_results/sub-'+ sub2model  +'_final_alpha.npy', final_alpha)
