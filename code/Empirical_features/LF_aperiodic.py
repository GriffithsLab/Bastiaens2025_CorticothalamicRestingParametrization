# Estimation of LF aperiodic using the exponent of a monoexponentially decaying function for all subject in subject_list with calculation
# of R squared values and subject for which fitting did not work

import scipy.optimize
def monoExp(x, m, t, b):
    return m * np.exp(-t * x) + b

# Initialize dictionaries to store results
all_exponents = {}

for subject in subject_list:
        stc_psd = mne.read_source_estimate(f"stc_results/sub-{subject}_stc_psd")
        data_source_psd = stc_psd.data.T[:90, :]
        freqs = stc_psd.times[:90]
        exponent = np.zeros(len(data_source_psd[0, :]))
        goodness_of_fit = np.zeros(len(data_source_psd[0, :]))
        # Initialize list to store indices of failed fits for this subject
        error_indices = []
        for j in range(0, len(data_source_psd[0, :])):
            try:
                xs = freqs[1:15]
                ys = data_source_psd[1:15, j]

                p0 = (50, 1, 50)
                # Use curve_fit to fit the exponential function to the data
                params, cv = scipy.optimize.curve_fit(monoExp, xs, ys, p0)
                exponent[j] = params[1]
                # Calculate the fitted values and residuals
                y_fit = monoExp(xs, *params)
                residuals = ys - y_fit
                ss_res = np.sum(residuals**2)  # Sum of squares of residuals
                ss_tot = np.sum((ys - np.mean(ys))**2)  # Total sum of squares
                r_squared = 1 - (ss_res / ss_tot)  # R-squared calculation
    
                # Save the R-squared value
                goodness_of_fit[j] = r_squared
                
            except RuntimeError as e:
                # Log the index j where the fitting failed for this subject
                error_indices.append(j)
                continue
    
        # Store the results for the current subject
        all_exponents[subject] = exponent
        all_goodness_of_fit[subject] = goodness_of_fit
    
        # If there are any errors for this subject, store the error indices
        if error_indices:
            error_log[subject] = error_indices
        final_exponent = np.array([exponent, ])
        np.save(f'aperiodic_low_results/sub-{subject}_low_exponent.npy', final_exponent)