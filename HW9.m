function pxx = powerSpectralDensity(x, window, noverlap)
    pxx = zeros(window, 1);
    window_fn = hamming(window); % Hamming window
    U = 1 / window * sum(window_fn .^ 2); % Normalization factor
    num_segments = floor((length(x) - window) / (window - noverlap)) + 1;

    for i = 1:num_segments
        start_index = (i - 1) * (window - noverlap) + 1;
        end_index = start_index + window - 1;
        segment = x(start_index:end_index);

        % Apply the window function
        segment = segment .* window_fn;

        % Compute the FFT magnitude squared
        fft_mag = abs(fft(segment, window)) .^ 2;

        % Aggregate the power spectral density
        pxx = pxx + fft_mag;
    end

    % Normalize the output
    pxx = pxx / (window * U * num_segments);

    % Remove the negative frequencies
    pxx = pxx(1:floor(window / 2) + 1);
end

function pxx = getPWelch(x, window, noverlap)
    pxx = pwelch(x, window, noverlap, window) * pi;
    pxx(1) = pxx(1) * 2; % Adjust the first element

    % Check if the window is even valued
    if mod(window, 2) == 0
        last = length(pxx);
        pxx(last) = pxx(last) * 2; % Adjust the last element
    end

end

disp("1a.")
% Test the powerSpectralDensity function against the built-in pwelch function
seed = 2025;
rng(seed);
x = randn(2000, 1); % Generate a random signal
window = 50; % Window length
noverlap = window * 0.5; % Overlap length
sample_freq = 1000; % Hz

% Use a Butterworth filter to make the spectrum more interesting
[b, a] = butter(2, 0.5);
x = filter(b, a, x); % Filter the random signal

% Run the power spectral density functions
pxx_custom = powerSpectralDensity(x, window, noverlap);
pxx_builtin = getPWelch(x, window, noverlap);

% Plot the results
figure;
freqs = (0:floor(window / 2)) * sample_freq / window; % Frequency vector

plot(freqs, pxx_custom, 'r*-', 'DisplayName', 'Custom PSD');
hold on;
plot(freqs, pxx_builtin, 'b', 'DisplayName', 'Built-in PSD');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density Comparison');
legend("powerSpectralDensity", "pwelch");
grid on;
hold off;

disp("1b.");
N = 16384; % Number of samples
sample_freq = 100;
sine_amp = 0.05;
sine_freq = 20;
nffts = [64, 512, 4096, 4096];
overlap = [0, 0, 0, 3072];
trials = 1000;

figure;

for i = 1:length(nffts)

    psds = zeros(nffts(i) / 2 + 1, trials);

    for trial = 1:trials
        x = randn(N, 1) + sine_amp * sin(2 * pi * sine_freq * (0:N - 1)' / sample_freq);
        psds(:, trial) = powerSpectralDensity(x, nffts(i), overlap(i));
    end

    % Compute the mean and standard deviation
    mean_psd = mean(psds, 2);
    std_psd = std(psds, 0, 2);
    mean_p_std = mean_psd + std_psd;
    mean_m_std = mean_psd - std_psd;

    freqs = (0:floor(nffts(i) / 2)) * sample_freq / nffts(i); % Frequency vector

    subplot(2, 2, i);
    plot(freqs, mean_psd, 'r', 'DisplayName', 'Mean PSD');
    hold on;
    plot(freqs, mean_p_std, 'b--', 'DisplayName', 'Mean + Std');
    plot(freqs, mean_m_std, 'g--', 'DisplayName', 'Mean - Std');
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');
    title(['PSD for NFFT = ', num2str(nffts(i)), ', Overlap = ', num2str(overlap(i))]);
    legend("Mean PSD", "Mean + Std", "Mean - Std");
    hold off;

end
