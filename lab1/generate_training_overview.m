% Generates overview of training process for Q = 20, Tol = 0.005
clear;
load('lab1data.mat', "LB1229")

Q = 20; % Example model order
pinv_tol = 0.005; % Example tolerance for pseudo-inverse

% Plot the original and filtered extensor, flexor, and torque signals for LB1229
fig = figure;
fig.Position = [100, 100, 1250, 1250]; % Set figure size
hold on;
tiledlayout(fig, 4, 3);
raw_samples = 1:length(LB1229.EMG_E4096);
down_samples = 1:length(LB1229.EMGrmsE);

% Original extensor signal
nexttile;
plot(raw_samples, LB1229.EMG_E4096, 'b', 'LineWidth', 1.5);
title('Extensor Signal (LB1229)');
xlabel('Sample Number');
ylabel('Raw EMG Amplitude');

% Original flexor signal
nexttile;
plot(raw_samples, LB1229.EMG_F4096, 'r', 'LineWidth', 1.5);
title('Flexor Signal (LB1229)');
xlabel('Sample Number');
ylabel('Raw EMG Amplitude');

% Original torque signal
nexttile;
plot(raw_samples, LB1229.T4096, 'k', 'LineWidth', 1.5);
title('Torque Signal (LB1229)');
xlabel('Sample Number');
ylabel('Raw Torque Values');

% RMS extensor signal
nexttile;
plot(down_samples, LB1229.EMGrmsE, 'b', 'LineWidth', 1.5);
xlabel('Sample Number');
ylabel('Downsampled EMG RMS');

% RMS flexor signal
nexttile;
plot(down_samples, LB1229.EMGrmsF, 'r', 'LineWidth', 1.5);
xlabel('Sample Number');
ylabel('Downsampled EMG RMS');

% Original torque signal
nexttile;
plot(down_samples, LB1229.T, 'k', 'LineWidth', 1.5);
xlabel('Sample Number');
ylabel('Downsampled Torque Values');

% Truncate and plot the filtered signals
transient_samples = 41; % Number of samples to ignore at the beginning and end
trunc_e_rms = remove_transients(LB1229.EMGrmsE, transient_samples);
trunc_f_rms = remove_transients(LB1229.EMGrmsF, transient_samples);
trunc_torque = remove_transients(LB1229.T, transient_samples);
trunc_samples = 1:length(trunc_e_rms);

% Truncated RMS extensor signal
nexttile;
plot(trunc_samples, trunc_e_rms, 'b', 'LineWidth', 1.5);
xlabel('Sample Number');
ylabel('Truncated EMG RMS');

% Truncated RMS flexor signal
nexttile;
plot(trunc_samples, trunc_f_rms, 'r', 'LineWidth', 1.5);
xlabel('Sample Number');
ylabel('Truncated EMG RMS');

% Original torque signal
nexttile;
plot(trunc_samples, trunc_torque, 'k', 'LineWidth', 1.5);
xlabel('Sample Number');
ylabel('Truncated Torque Values');

% Train the FIR model with the truncated signals
% The training function handles truncating, so use the down sampled versions
[e_coeff, f_coeff] = trainFIR(LB1229.EMGrmsE, LB1229.EMGrmsF, LB1229.T, pinv_tol, Q);

% Drop the startup transients
startup_e_rms = remove_startup_transients(LB1229.EMGrmsE, transient_samples - Q);
startup_f_rms = remove_startup_transients(LB1229.EMGrmsF, transient_samples - Q);
startup_torque = remove_startup_transients(LB1229.T, transient_samples - Q);
plotted_startup_torque = remove_startup_transients(LB1229.T, transient_samples);

N = length(startup_e_rms);
startup_samples = 1:N - Q;

% Estimate the torque using the coefficients
estimated_torque = zeros(1, N - Q);

for i = 1:N - Q
    % Calculate the estimated torque for each sample using the coefficients
    estimated_torque(1, i) = sum(e_coeff .* flip(startup_e_rms(i:i + Q))) + sum(f_coeff .* flip(startup_f_rms(i:i + Q)));
end

% Plot the predicted torque over the truncated torque
nexttile([1, 3]); % Span across the last row
plot(startup_samples, estimated_torque, 'g', 'LineWidth', 1.5)
hold on;
plot(startup_samples, plotted_startup_torque, 'k', 'LineWidth', 1.5);
title('Estimated vs Actual Torque (LB1229)');
xlabel('Sample Number');
ylabel('Torque Values');
legend('Estimated Torque', 'Actual Torque', 'Location', 'best');
saveas(fig, 'plots/lab1_training_overview.png');
