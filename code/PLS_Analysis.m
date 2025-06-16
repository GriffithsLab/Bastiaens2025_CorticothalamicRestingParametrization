% Includes the PLS analysis for figures in main text, as well as the
% analysis of the full model provided in Supplementary

%% Empirical data formatting for PLS
data = readtable('combined_data.csv'); % in Data folder
freq_shape = reshape(data.freq, 202,608)';
power_shape = reshape(data.power, 202,608)';
high_shape = reshape(data.high_exp, 202,608)';
low_shape = reshape(data.low_exp, 202,608)';

rows_with_nan = any(isnan(freq_shape), 2);

freq_cleaned = freq_shape(~rows_with_nan, :);
power_cleaned = power_shape(~rows_with_nan, :);
high_cleaned = high_shape(~rows_with_nan, :);
low_cleaned = low_shape(~rows_with_nan, :);

% Getting subjects names
names = data.Subject;
names_shape = reshape(names, 202,608)';
names_cleaned = names_shape(~rows_with_nan, :);
list_names = names_cleaned(:,1);
% Getting subject age
participant_info = readtable("participants.tsv", "FileType","text",'Delimiter', '\t'); % in Paper_2/Data
participant_info.participant_id = regexprep(participant_info.participant_id, 'sub-', '');
list_table = table(list_names, 'VariableNames', {'participant_id'});
[~, idx_list_table_in_participant_info] = ismember(list_table.participant_id, participant_info.participant_id);
ages(~isnan(idx_list_table_in_participant_info)) = participant_info.age(idx_list_table_in_participant_info(~isnan(idx_list_table_in_participant_info)));
list_table.age = ages';


% Formatting for PLS for alpha frequency against age with 200 cortical ROIs
cell_freq = {freq_cleaned(:, 1:200)};
cell_power = {power_cleaned(:, 1:200)};
cell_high = {high_cleaned(:, 1:200)};
cell_low = {low_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages';
option.num_boot = 1000;
option.num_perm = 1000;

% PLS for frequency
result_freq = pls_analysis(cell_freq, 607, 1, option);
result_power = pls_analysis(cell_power, 607,1, option);
result_high = pls_analysis(cell_high, 607,1, option);
result_low = pls_analysis(cell_low, 607,1, option);
load('ROI_coord.mat')
ROI_coord = ROI_coord(1:200);
% Plot the first scatter plot in the first subplot
subplot(1, 4, 1);
scatter(ROI_coord, result_freq.boot_result.compare_u);
title('PLS frequency - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

% Plot the second scatter plot in the second subplot
subplot(1, 4, 2);
scatter(ROI_coord, result_power.boot_result.compare_u);
title('PLS power - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');


% Plot the third scatter plot in the third subplot
subplot(1, 4, 3);
scatter(ROI_coord, result_high.boot_result.compare_u);
title('PLS high exponent - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

% Plot the fourth scatter plot in the fourth subplot
subplot(1, 4, 4);
scatter(ROI_coord, result_low.boot_result.compare_u);
title('PLS low exponent - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');


%% Modelling data (x,y,z) formatting for PLS
x_shape = reshape(data.x, 202,608)';
y_shape = reshape(data.y, 202,608)';
z_shape = reshape(data.z, 202,608)';

rows_with_nan = any(isnan(freq_shape), 2); % For consistency with empirical

x_cleaned = x_shape(~rows_with_nan, :);
y_cleaned = y_shape(~rows_with_nan, :);
z_cleaned = z_shape(~rows_with_nan, :);

% Formatting for PLS for alpha frequency against age
cell_x = {x_cleaned(:, 1:200)};
cell_y = {y_cleaned(:, 1:200)};
cell_z = {z_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages';
option.num_boot = 1000;%500;
option.num_perm = 1000;

% PLS for frequency
result_x = pls_analysis(cell_x, 607, 1, option);
result_y = pls_analysis(cell_y, 607,1, option);
result_z = pls_analysis(cell_z, 607,1, option);

% Plot the first scatter plot in the first subplot
figure
subplot(1, 3, 1);
scatter(ROI_coord, result_x.boot_result.compare_u);
title('PLS x - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

% Plot the second scatter plot in the second subplot
subplot(1, 3, 2);
scatter(ROI_coord, result_y.boot_result.compare_u);
title('PLS y - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

% Plot the third scatter plot in the third subplot
subplot(1, 3, 3);
scatter(ROI_coord, result_z.boot_result.compare_u);
title('PLS z - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');


%% Modelling data (t0) formatting for PLS
t0_shape = reshape(data.t0, 202,608)';

rows_with_nan = any(isnan(freq_shape), 2); % For consistency with empirical

t0_cleaned = t0_shape(~rows_with_nan, :);

% Formatting for PLS for alpha frequency against age
cell_t0 = {t0_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages';
option.num_boot = 1000;%500;
option.num_perm = 1000;

% PLS for frequency
result_t0 = pls_analysis(cell_t0, 607, 1, option);

% Plot the first scatter plot in the first subplot
figure
scatter(ROI_coord, result_t0.boot_result.compare_u);
title('PLS t0 - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

%% Modelling data (Gee, Gei, Gese, Gesre, Gsrs) formatting for PLS
Gee_shape = reshape(data.Gee, 202,608)';
Gei_shape = reshape(data.Gei, 202,608)';
Gese_shape = reshape(data.Gese, 202,608)';
Gesre_shape = reshape(data.Gesre, 202,608)';
Gsrs_shape = reshape(data.Gsrs, 202,608)';

rows_with_nan = any(isnan(freq_shape), 2); %!! For consistency with empirical

Gee_cleaned = Gee_shape(~rows_with_nan, :);
Gei_cleaned = Gei_shape(~rows_with_nan, :);
Gese_cleaned = Gese_shape(~rows_with_nan, :);
Gesre_cleaned = Gesre_shape(~rows_with_nan, :);
Gsrs_cleaned = Gsrs_shape(~rows_with_nan, :);
% Formatting for PLS for alpha frequency against age
cell_Gee = {Gee_cleaned(:, 1:200)};
cell_Gei = {Gei_cleaned(:, 1:200)};
cell_Gese = {Gese_cleaned(:, 1:200)};
cell_Gesre = {Gesre_cleaned(:, 1:200)};
cell_Gsrs = {Gsrs_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages';
option.num_boot = 1000;%500;
option.num_perm = 1000;

% PLS for frequency
result_Gee = pls_analysis(cell_Gee, 607, 1, option);
result_Gei = pls_analysis(cell_Gei, 607, 1, option);
result_Gese = pls_analysis(cell_Gese, 607, 1, option);
result_Gesre = pls_analysis(cell_Gesre, 607, 1, option);
result_Gsrs = pls_analysis(cell_Gsrs, 607, 1, option);

% Plot the first scatter plot in the first subplot
figure
subplot(3,3,1)
scatter(ROI_coord, result_Gee.boot_result.compare_u);
title('PLS Gee - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

subplot(3,3,2)
scatter(ROI_coord, result_Gei.boot_result.compare_u);
title('PLS Gei - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');
subplot(3,3,3)
scatter(ROI_coord, result_Gese.boot_result.compare_u);
title('PLS Gese - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

subplot(3,3,4)
scatter(ROI_coord, result_Gesre.boot_result.compare_u);
title('PLS Gesre - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

subplot(3,3,5)
scatter(ROI_coord, result_Gsrs.boot_result.compare_u);
title('PLS Gsrs - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');


%% Modelling data (alpha and beta) formatting for PLS
alpha_shape = reshape(data.alpha, 202,608)';
beta_shape = reshape(data.beta, 202,608)';

rows_with_nan = any(isnan(freq_shape), 2); %!! For consistency with empirical

alpha_cleaned = alpha_shape(~rows_with_nan, :);
beta_cleaned = beta_shape(~rows_with_nan, :);

% Formatting for PLS for alpha frequency against age
cell_alpha = {alpha_cleaned(:, 1:200)};
cell_beta = {beta_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages';
option.num_boot = 1000;%500;
option.num_perm = 1000;

% PLS for frequency
result_alpha = pls_analysis(cell_alpha, 607, 1, option);
result_beta = pls_analysis(cell_beta, 607, 1, option);

% Plot the first scatter plot in the first subplot
figure
subplot(1,2,1)
scatter(ROI_coord, result_alpha.boot_result.compare_u);
title('PLS alpha - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

subplot(1,2,2)
scatter(ROI_coord, result_beta.boot_result.compare_u);
title('PLS beta - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');
%% Check for outliers

% Check for outliers.
% Check for outliers.
figure;
hist(zscore(result_power.usc(:,1)))
xlabel('result.usc, zscored')
title('outlier check') 

%% Doing two PLS: 1) Empirical features together; 2) Modelling parameters together

% Empirical
option.method = 3;
option.stacked_behavdata = [ages'; ages'; ages'; ages'];
option.num_boot = 1000;
option.num_perm = 1000;

cell_feature = {[freq_cleaned(:, 1:200); power_cleaned(:, 1:200); high_cleaned(:, 1:200); low_cleaned(:, 1:200)]};
% PLS for frequency
result_feature = pls_analysis(cell_feature, 607, 4, option);
figure, scatter(ROI_coord, result_feature.boot_result.compare_u(:,1))
figure, scatter(ROI_coord, result_feature.boot_result.compare_u(:,2))

% Modelling xyz and t0
option.method = 3;
option.stacked_behavdata = [ages'; ages'; ages'; ages'];
option.num_boot = 1000;
option.num_perm = 1000;

cell_modelling = {[x_cleaned(:, 1:200); y_cleaned(:, 1:200); z_cleaned(:, 1:200); t0_cleaned(:, 1:200)]};
% PLS for frequency
result_modelling = pls_analysis(cell_modelling, 607, 4, option);
figure, scatter(ROI_coord, result_modelling.boot_result.compare_u(:,1))
figure, scatter(ROI_coord, result_modelling.boot_result.compare_u(:,2))

% Modelling Gs, alpha, beta, t0
option.method = 3;
option.stacked_behavdata = [ages'; ages'; ages'; ages'; ages'; ages'; ages'; ages'];
option.num_boot = 1000;
option.num_perm = 1000;

cell_modelling_1 = {[Gee_cleaned(:, 1:200); Gei_cleaned(:, 1:200); Gese_cleaned(:, 1:200); Gesre_cleaned(:, 1:200); Gsrs_cleaned(:, 1:200); alpha_cleaned(:, 1:200); beta_cleaned(:, 1:200); t0_cleaned(:, 1:200)]};
% PLS for frequency
result_modelling_1 = pls_analysis(cell_modelling_1, 607, 8, option);
% scatter(ROI_coord, result_modelling.boot_result.compare_u(:,1))
%figure, scatter(ROI_coord, result_modelling.boot_result.compare_u(:,2))

empirical_modelling_product_lv1 = result_feature.u(:,1)'*result_modelling.u(:,1);
empirical_modelling_product_lv2 =  result_feature.u(:,2)'*result_modelling.u(:,2);
empirical_modelling_product_lv1lv2 =  result_feature.u(:,1)'*result_modelling.u(:,2);
empirical_modelling_product_lv2lv1 = result_feature.u(:,2)'*result_modelling.u(:,1);

%% Save bootstrapping results

% Create a table

T = table(result_freq.boot_result.compare_u, result_power.boot_result.compare_u, result_high.boot_result.compare_u, result_low.boot_result.compare_u, 'VariableNames', {'freq', 'power', 'high', 'low'});
writetable(T, 'bootstrap_empirical.csv');

T = table(result_x.boot_result.compare_u, result_y.boot_result.compare_u, result_z.boot_result.compare_u, result_t0.boot_result.compare_u, 'VariableNames', {'x', 'y', 'z', 't0'});
writetable(T, 'bootstrap_xyzt0.csv');

T = table(result_Gee.boot_result.compare_u,result_Gei.boot_result.compare_u,result_Gese.boot_result.compare_u,result_Gesre.boot_result.compare_u, result_Gsrs.boot_result.compare_u, result_alpha.boot_result.compare_u,result_beta.boot_result.compare_u, 'VariableNames', {'Gee','Gei','Gese','Gesre', 'Gsrs', 'alpha', 'beta'});
writetable(T, 'bootstrap_Gsalpha_all.csv');


T = table(result_feature.boot_result.compare_u, result_modelling.boot_result.compare_u, 'VariableNames', {'feature', 'modelling'});
writetable(T, 'bootstrap_featuremodelling.csv');