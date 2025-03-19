disp("1e.")

function [true_y_n, y_n, rms] = calculateRMS(precision)
    x_n = ones(1, 32);
    [b, a] = butter(4, 0.5);
    true_y_n = filter(b, a, x_n);

    % Round the values to the given precision
    b = round(b, precision);
    a = round(a, precision);

    y_n = filter(b, a, x_n);
    rms = sqrt(mean((true_y_n - y_n) .^ 2));
end

firstIteration = true;
maxPrecision = 3;
RMSValues = zeros(1, maxPrecision + 1);

for precision = 0:maxPrecision
    [true_y_n, y_n, rms] = calculateRMS(precision);

    if firstIteration
        figure
        firstIteration = false;
        stem(true_y_n)
    end

    hold on
    stem(y_n)
    RMSValues(precision + 1) = rms;
end

title("Comparison of True y[n] and y[n] for Different Filter Coefficient Precisions")
xlabel("n")
ylabel("y[n]")
legendText = strings(1, maxPrecision + 2);
legendText(1) = "True y[n]";

for i = 0:maxPrecision
    legendText(i + 2) = "y[n] with precision " + i + " (RMS = " + ...
        num2str(RMSValues(i + 1), '%.4f') + ")";
end

legend(legendText)

disp("2d.")

function output = x(n, freq)
    samplingFreq = 5000; % Hz
    output = sin(2 * pi * (freq / samplingFreq) * n);
end

n = 0:99;
figure
subplot(2, 2, 1)
stem(n, x(n, 500))
title("x[n] for freq = 0.5 kHz")
xlabel("n")
ylabel("x[n]")
subplot(2, 2, 2)
stem(n, x(n, 2000))
title("x[n] for freq = 2 kHz")
xlabel("n")
ylabel("x[n]")
subplot(2, 2, 3)
stem(n, x(n, 3000))
title("x[n] for freq = 3 kHz")
xlabel("n")
ylabel("x[n]")
subplot(2, 2, 4)
stem(n, x(n, 4500))
title("x[n] for freq = 4.5 kHz")
xlabel("n")
ylabel("x[n]")

disp("3a.")
b = [1, -sqrt(2), 1];
a = 1;
n = 0:4;
x_n = sin(pi / 4 * n);
y_n = filter(b, a, x_n)

disp("3b.")
[h, w] = freqz([1, -1], [-0.9, -1]);
figure;
plot(w, abs(h))
xlabel("w (rad)")
xlim([0, pi])
ylabel("|H(w)|")
title("Magnitude of H(w)")
grid on

figure;
plot(w, angle(h))
xlabel("w (rad)")
xlim([0, pi])
ylabel("angle(H(w)) (rad)")
title("Phase of H(w)")
grid on
hold off

disp("3c.")
b = ones(1, 9);
a = 1;
freqz(b, a, 1000, 1000);
