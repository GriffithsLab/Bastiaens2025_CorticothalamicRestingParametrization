
%% Empirical data formatting for PLS
data = readtable('combined_data_final.csv');

% Getting subject age
[~, idx] = unique(data.participant_id);  % indices of first occurrence
ages = data.age(idx);
% Formatting for PLS for alpha frequency against age

freq_cleaned = reshape(data.freq, 200,607)';
power_cleaned = reshape(data.power, 200,607)';
high_cleaned = reshape(data.high_exp, 200,607)';
low_cleaned = reshape(data.low_exp, 200,607)';
cell_freq = {freq_cleaned(:, 1:200)};
cell_power = {power_cleaned(:, 1:200)};
cell_high = {high_cleaned(:, 1:200)};
cell_low = {low_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages;
option.num_boot = 1000;
option.num_perm = 1000;

load('ROI_coord.mat')
ROI_coord = ROI_coord(1:200);

% PLS for empirical
result_freq = pls_analysis(cell_freq, 607, 1, option);
result_power = pls_analysis(cell_power, 607,1, option);
result_high = pls_analysis(cell_high, 607,1, option);
result_low = pls_analysis(cell_low, 607,1, option);

% Plot for frequency
subplot(1, 4, 1);
scatter(ROI_coord, result_freq.boot_result.compare_u);
title('PLS frequency - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

% Plot for power
subplot(1, 4, 2);
scatter(ROI_coord, result_power.boot_result.compare_u);
title('PLS power - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');


% Plot for high exponent
subplot(1, 4, 3);
scatter(ROI_coord, result_high.boot_result.compare_u);
title('PLS high exponent - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

% Plot for low exponent
subplot(1, 4, 4);
scatter(ROI_coord, result_low.boot_result.compare_u);
title('PLS low exponent - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

%% Modelling data (x,y,z) formatting for PLS
x_cleaned = reshape(data.x, 200,607)';
y_cleaned = reshape(data.y, 200,607)';
z_cleaned = reshape(data.z, 200,607)';

cell_x = {x_cleaned(:, 1:200)};
cell_y = {y_cleaned(:, 1:200)};
cell_z = {z_cleaned(:, 1:200)};

option.method = 3;
option.stacked_behavdata = ages;
option.num_boot = 1000;
option.num_perm = 1000;

% PLS for modelling
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
t0_cleaned = reshape(data.t0, 200,607)';

cell_t0 = {t0_cleaned(:, 1:200)};

% PLS for t0
result_t0 = pls_analysis(cell_t0, 607, 1, option);

% Plot the first scatter plot in the first subplot
figure
scatter(ROI_coord, result_t0.boot_result.compare_u);
title('PLS t0 - age: compare u');
xlabel('ROI coordinate');
ylabel('Boot strap u result');

%% Doing two PLS: 1) Empirical features together; 2) Modelling parameters together

% Empirical
option.method = 3;
option.stacked_behavdata = [ages; ages; ages; ages];
option.num_boot = 1000;
option.num_perm = 1000;

cell_feature = {[freq_cleaned(:, 1:200); power_cleaned(:, 1:200); high_cleaned(:, 1:200); low_cleaned(:, 1:200)]};
% PLS for all empirical features
result_feature = pls_analysis(cell_feature, 607, 4, option);
figure, scatter(ROI_coord, result_feature.boot_result.compare_u(:,1))
figure, scatter(ROI_coord, result_feature.boot_result.compare_u(:,2))

% Modelling xyz and t0

cell_modelling = {[x_cleaned(:, 1:200); y_cleaned(:, 1:200); z_cleaned(:, 1:200); t0_cleaned(:, 1:200)]};
% PLS for frequency
result_modelling = pls_analysis(cell_modelling, 607, 4, option);
figure, scatter(ROI_coord, result_modelling.boot_result.compare_u(:,1))
figure, scatter(ROI_coord, result_modelling.boot_result.compare_u(:,2))

empirical_modelling_product_lv1 = result_feature.u(:,1)'*result_modelling.u(:,1);
empirical_modelling_product_lv2 =  result_feature.u(:,2)'*result_modelling.u(:,2);
empirical_modelling_product_lv1lv2 =  result_feature.u(:,1)'*result_modelling.u(:,2);
empirical_modelling_product_lv2lv1 = result_feature.u(:,2)'*result_modelling.u(:,1);

%%

T = table(result_freq.boot_result.compare_u, result_power.boot_result.compare_u, result_high.boot_result.compare_u, result_low.boot_result.compare_u, 'VariableNames', {'freq', 'power', 'high', 'low'});
writetable(T, 'bootstrap_empirical_final.csv');

T = table(result_x.boot_result.compare_u, result_y.boot_result.compare_u, result_z.boot_result.compare_u, result_t0.boot_result.compare_u, 'VariableNames', {'x', 'y', 'z', 't0'});
writetable(T, 'bootstrap_xyzt0_final.csv');


T = table(result_feature.boot_result.compare_u, result_modelling.boot_result.compare_u, 'VariableNames', {'feature', 'modelling'});
writetable(T, 'bootstrap_featuremodelling_final.csv');