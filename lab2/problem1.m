function [s, f, t] = my_stft(x, win_size, overlap, Fs)
    window = hamming(win_size);
    windows = 1 + floor((length(x) - win_size) / (win_size - overlap));

    s = zeros(floor(win_size / 2) + 1, windows);
    t = zeros(windows, 1);

    for i = 1:windows
        % Calculate the start and stop indices for the current window
        start = (i - 1) * (win_size - overlap) + 1;
        stop = start + win_size - 1;

        % Take the window
        xw = x(start:stop)' .* window;

        % Find the fft and save only the positive frequencies
        win_fft = fft(xw, win_size);
        s(:, i) = win_fft(1:floor(win_size / 2) + 1, 1);

        % Calculate the time vector
        t(i, 1) = (start - 1 + (win_size / 2)) / Fs;
    end

    % Calculate the frequency vector
    f = (0:floor(win_size / 2)) * Fs / win_size;

end

disp("1a.");
t = 0:1e-4:2;
x = cos(2 * pi * (1500/2) * t .* t);
[s, f, t] = my_stft(x, 256, 128, 10000);
figure;
mesh(t, f, 10 * log10(abs(s)));
colorbar;
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title("STFT of Sample Chirp Signal with my\_stft function");

disp("1b.");
figure;
[s2, f2, t2] = spectrogram(x, 256, 128, 256, 10000);
mesh(t2, f2, 10 * log10(abs(s2)));
colorbar;
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title("STFT of Sample Chirp Signal using MATLAB's spectrogram");

disp("1c.");
windows = [64, 128, 256, 512];
figure;

for i = 1:length(windows)
    subplot(2, 2, i);
    [s, f, t] = my_stft(x, windows(i), windows(i) / 2, 10000);
    mesh(t, f, 10 * log10(abs(s)));
    colorbar;
    xlabel("Time (s)");
    ylabel("Frequency (Hz)");
    title(sprintf("STFT of Sample Chirp Signal with my\\_stft function\nWindow Size: %d", windows(i)));
end
