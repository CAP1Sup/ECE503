disp("1a.")
lengths = [5, 9, 13, 21];
figure;

for i = 1:length(lengths)
    subplot(2, 2, i);
    b = firpm(lengths(i) - 1, [0 0.5 0.75 1], [0 0 1 1]);
    [H, W] = freqz(b, 1, 1024);
    plot(W / pi, abs(H));
    title(['Length = ', num2str(lengths(i))]);
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Magnitude');
    grid on;
end

disp("2a.")
sine_wave_freqs = [5, 10, 15, 20, 25]; % Hz

% Sample each of the sine waves at 100 Hz
Fs = 100; % Sampling frequency
t = 0:1 / Fs:1; % Time vector
sine_waves = zeros(length(sine_wave_freqs), length(t));

for i = 1:length(sine_wave_freqs)
    sine_waves(i, :) = sin(2 * pi * sine_wave_freqs(i) * t);
end

% Create the FIR filter
b = fir1(4, 0.5);

% Apply the filter to each sine wave with filter() and plot the results
phase_delays = zeros(length(sine_wave_freqs), 1);
figure;

for i = 1:length(sine_wave_freqs)
    subplot(5, 1, i);
    filtered_wave = filter(b, 1, sine_waves(i, :));
    plot(t, sine_waves(i, :), 'b', 'DisplayName', 'Original'); hold on;
    plot(t, filtered_wave, 'r', 'DisplayName', 'Filtered');
    title(['filter() Sine Wave: ', num2str(sine_wave_freqs(i)), ' Hz']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend;
    grid on;
    hold off;

    % Calculate peaks
    [~, filt_pk_locs] = findpeaks(filtered_wave, "NPeaks", 1);
    [~, orig_pk_locs] = findpeaks(sine_waves(i, :), "NPeaks", 1);

    % Calculate the phase deviation between the peaks
    time_delay = abs((filt_pk_locs - orig_pk_locs) / Fs);
    phase_delays(i) = time_delay * sine_wave_freqs(i) * 360; % Convert to degrees
end

% Plot the phase deviations
figure;
plot(sine_wave_freqs, phase_delays, 'o-');
xlabel('Frequency (Hz)');
ylabel('Phase Delay (deg)');
ylim([0, max(phase_delays) * 1.1]);
title('Phase Deviation vs Frequency - filter()');
grid on;

% Apply the filter to each sine wave with filtfilt() and plot the results
phase_delays = zeros(length(sine_wave_freqs), 1);
figure;

for i = 1:length(sine_wave_freqs)
    subplot(5, 1, i);
    filtered_wave = filtfilt(b, 1, sine_waves(i, :));
    plot(t, sine_waves(i, :), 'b', 'DisplayName', 'Original'); hold on;
    plot(t, filtered_wave, 'r', 'DisplayName', 'Filtered');
    title(['filtfilt() Sine Wave: ', num2str(sine_wave_freqs(i)), ' Hz']);
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend;
    grid on;
    hold off;

    % Calculate peaks
    [~, filt_pk_locs] = findpeaks(filtered_wave, "NPeaks", 1);
    [~, orig_pk_locs] = findpeaks(sine_waves(i, :), "NPeaks", 1);

    % Calculate the phase deviation between the peaks
    time_delay = abs((filt_pk_locs - orig_pk_locs) / Fs);
    phase_delays(i) = time_delay * sine_wave_freqs(i) * 360; % Convert to degrees
end

% Plot the phase deviations
figure;
plot(sine_wave_freqs, phase_delays, 'o-');
xlabel('Frequency (Hz)');
ylabel('Phase Delay (deg)');
ylim([0, max(phase_delays) * 1.1 + 0.01]);
title('Phase Deviation vs Frequency - filtfilt()');
grid on;

disp("3c.")

function output = upsample(input, I)
    % Upsample the input signal by a factor of I
    N = length(input);
    output = zeros(1, N * I);
    output(1:I:end) = input;

    % Apply a non-causal zero phase low-pass filter to the upsampled signal
    [b, a] = butter(4, 1 / I);
    output = I * filtfilt(b, a, output);
end

Fs = 20; % Sampling frequency
Fw = 1; % Frequency of the sine wave
t = 0:1 / Fs:1; % Time vector
original_sine_wave = sin(2 * pi * Fw * t);
upsampled_sine_wave = upsample(original_sine_wave, 4);

% Create stem plots for the original and upsampled sine waves
figure;
subplot(2, 1, 1);
stem(t, original_sine_wave, 'filled');
title('Original Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;
subplot(2, 1, 2);
stem(0:1 / (length(upsampled_sine_wave) - 1):1, upsampled_sine_wave, 'filled');
title('Upsampled Sine Wave');
xlabel('Time (s)');
ylabel('Amplitude');
ylim([min(upsampled_sine_wave), max(upsampled_sine_wave)]);
grid on;

disp("4a.")
passband_stop_freqs = [0.9, 0.93, 0.96, 0.99];
figure;

for i = 1:length(passband_stop_freqs)
    subplot(2, 2, i);
    b = firpm(20, [0.1 passband_stop_freqs(i)], [1 1], "hilbert");
    [H, W] = freqz(b, 1, 1024);
    plot(W / pi, abs(H));
    title(['Passband Stop Freq = ', num2str(passband_stop_freqs(i))]);
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Magnitude');
    grid on;
end
