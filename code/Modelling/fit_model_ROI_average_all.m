function fit_model_ROI_average_all(subj_id)

    % Setup
    addpath '/path_to_braintrack/braintrack/corticothalamic-model'
    addpath '/path_to_braintracl/braintrack/braintrak'

    % Load PSDs and freqs for one subj
    loaded_data = load('psds_average_labels.mat');
    res = loaded_data.all_subject_data{1, subj_id}.average_psds;
    linear_psds = double(10.^(res'/10));
    fs = loaded_data.all_subject_data{1,subj_id}.freqs;
    % Initialize parallel pool
    %sz = str2num(getenv('SLURM_CPUS_PER_TASK'));
    %if isempty(sz), sz = 6; end
    %p = parpool('local',sz);
    for i = 1:size(linear_psds,2)
        display(i)
    
        % Select current PSD
        pws_roi = linear_psds(:,i);
    
        % Fit model
        this_fit_roi = bt.fit(bt.model.full, fs, pws_roi, 1e5);
    
        if i == 1 %Initialize feather if first fit
            all_fits_roi = bt.feather(bt.model.full, this_fit_roi.fit_data, this_fit_roi.plot_data);
        else % add new fits to existing feather
            all_fits_roi.insert(this_fit_roi.fit_data, this_fit_roi.plot_data);
        end 
        % Truncate unused fits from dynamic pre-allocation
        all_fits_roi.compress
    end
    
    % Extract fitted params GAB and XYZ, as well as chisq
    fit_gab_roi = all_fits_roi.fitted_params;
    fit_xyz_roi = all_fits_roi.xyz;
    fit_chisq_roi = all_fits_roi.chisq;

    % Save feather to .mat file
    results_dir_roi = strcat('/lustre07/scratch/bastiaen/fit_camcan/ROI_matlab/model_ROI_results')
    mkdir(results_dir_roi)
    save(strcat(results_dir_roi, 'all_fits_roi.mat'), 'all_fits_roi')
    % Save result matrices to .csv
    writematrix(fit_gab_roi, strcat(results_dir_roi, '/', loaded_data.all_subject_data{1,subj_id}.subject_names, '_fit_gab_roi.csv'))
    writematrix(fit_xyz_roi, strcat(results_dir_roi, '/', loaded_data.all_subject_data{1,subj_id}.subject_names, '_fit_xyz_roi.csv'))
    writematrix(fit_chisq_roi, strcat(results_dir_roi, '/', loaded_data.all_subject_data{1,subj_id}.subject_names, '_fit_chisq_roi.csv'))
    % if running this again, save out PSDs and freqs here
    
    % Shut down parallel pool
    delete(gcp('nocreate')) 
end
