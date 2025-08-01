import mne
import numpy as np
import sys


sub2model = sys.argv[1]
raw = mne.io.Raw('new_derivatives/sub-'+ sub2model +'/ses-rest/meg/sub-'+ sub2model + '_ses-rest_task-rest_proc-filt_raw.fif', verbose=False)
inv = mne.minimum_norm.read_inverse_operator('new_derivatives/sub-'+ sub2model +'/ses-rest/meg/sub-'+ sub2model +'_ses-rest_task-rest_inv.fif', verbose=False)
stc_psd, sensor_psd = mne.minimum_norm.compute_source_psd(raw, inv, dB=True, return_sensor=True, verbose=False)
stc_psd.save("/external/rprshnas01/netdata_kcni/jglab/MemberSpaces/sb/CAM-can_data/stc_results/sub-"+ sub2model + "_stc_psd")
