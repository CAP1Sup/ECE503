disp("2a.")
samplingFreq = 1000; % Hz
% Filter 1
[b1, a1] = cheby1(4, 0.1, 125 / (samplingFreq / 2));

% Plot the magnitude response of filter 1
figure
subplot(2, 2, 1)
[h, w] = freqz(b1, a1, samplingFreq);
w = w * samplingFreq / (2 * pi);
plot(w, abs(h))
title("Magnitude Response of Filter 1")
xlabel("Frequency (Hz)")
ylabel("Magnitude")
grid on

% Plot the first 100 samples of the impulse response of filter 1
subplot(2, 2, 2)
impz(b1, a1, 100);
title("Impulse Response of Filter 1")
xlabel("n")
ylabel("h[n]")
grid on

% Filter 2
[b2, a2] = cheby1(4, 5, 250 / (samplingFreq / 2));

% Plot the magnitude response of filter 2
subplot(2, 2, 3)
[h, w] = freqz(b2, a2, samplingFreq);
w = w * samplingFreq / (2 * pi);
plot(w, abs(h))
title("Magnitude Response of Filter 2")
xlabel("Frequency (Hz)")
ylabel("Magnitude")
grid on

% Plot the first 100 samples of the impulse response of filter 2
subplot(2, 2, 4)
impz(b2, a2, 100);
title("Impulse Response of Filter 2")
xlabel("n")
ylabel("h[n]")
grid on

disp("2b.")
% Filter 1
samplingFreq = 1000; % Hz
[b1, a1] = ellip(2, 1, 20, 400 / (samplingFreq / 2), "high");

% Plot the magnitude response of filter 1
figure
subplot(2, 2, 1)
[h, w] = freqz(b1, a1, samplingFreq);
w = w * samplingFreq / (2 * pi);
semilogy(w, abs(h))
title("Magnitude Response of Filter 1")
xlabel("Frequency (Hz)")
ylabel("Magnitude")
grid on

% Plot the first 25 samples of the impulse response of filter 1
subplot(2, 2, 2)
impz(b1, a1, 25);
title("Impulse Response of Filter 1")
xlabel("n")
ylabel("h[n]")
grid on

% Filter 2
[b2, a2] = ellip(2, 0.25, 60, 400 / (samplingFreq / 2), "high");

% Plot the magnitude response of filter 2
subplot(2, 2, 3)
[h, w] = freqz(b2, a2, samplingFreq);
w = w * samplingFreq / (2 * pi);
semilogy(w, abs(h))
title("Magnitude Response of Filter 2")
xlabel("Frequency (Hz)")
ylabel("Magnitude")
grid on

% Plot the first 25 samples of the impulse response of filter 2
subplot(2, 2, 4)
impz(b2, a2, 25);
title("Impulse Response of Filter 2")
xlabel("n")
ylabel("h[n]")
grid on

disp("3c.")
freqz([1, -1], 1);
title("Magnitude of H(w) = 1 - e^{-jw}")
grid on

function output = dft(seq, inverse)
    N = length(seq);
    output = zeros(1, N);
    n = 0:N - 1;

    for k = 1:N

        e = exp(-1j * 2 * pi * (k - 1) * n / N);

        if inverse
            e = 1 ./ e;
        end

        output(k) = sum(seq .* e);

    end

    if inverse
        output = output / N;
    end

end

function b = filterCreator(M, cutoff)
    N = 10 * M;

    % Normalize the cutoff frequency
    cutoff = round(cutoff * N / (2 * pi));

    % Create the ideal DFT
    idealDFT = [ones(1, cutoff), zeros(1, N - cutoff)];

    % Ensure the phase is symmetric
    for k = 1:N

        if k <= N / 2
            phase =- (M - 1) * pi * k / N;
        else
            phase =- (M - 1) * pi * (k - N) / N;
        end

        idealDFT(k) = idealDFT(k) * exp(1j * phase);
    end

    % Convert to the time domain
    b = dft(idealDFT, true);

    % Truncate to M
    b = b(1:M);

    % Multiply by a Blackman window
    for n = 1:M
        b(n) = b(n) * (0.42 - 0.5 * cos(2 * pi * n / M) + 0.08 * cos(4 * pi * n / M));
    end

end

disp("4.")
b = filterCreator(40, pi / 2);
freqz(b, 1);
