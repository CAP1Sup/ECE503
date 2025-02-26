clear all;

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

disp("1. Test")
x1 = [-2, 2, 1, 3, 0, 0, 0];
x2 = [5, 3, -1, 0, 0, 0, 0];

X1 = dft(x1, false);
X2 = dft(x2, false);
dft(X1 .* X2, true)

disp("1c.")
x = [0, 4, 3, 2, 1, 0];
X = dft(x, false)
real_X = dft(real(X), true)
imag_X = dft(imag(X), true)

% Plot the real and imaginary parts of the DFT of x on stem plots.
figure
subplot(2, 1, 1)
stem(real_X)
title("Real part of DFT of x")
xlabel("n")
ylabel("Magnitude of Re{X[n]}")
subplot(2, 1, 2)
stem(imag_X * -1j)
title("Imaginary part of DFT of x")
xlabel("n")
ylabel("Magnitude of Im{X[n]}")

disp("1d.")
x = 0:7;
X = dft(cos(pi / 4 * x), false)

% Plot the real and imaginary parts of the DFT of x on stem plots.
figure
subplot(2, 1, 1)
stem(x, real(X))
title("Real part of DFT of x")
xlabel("n")
ylabel("Magnitude of Re{X[n]}")
subplot(2, 1, 2)
stem(x, imag(X))
title("Imaginary part of DFT of x")
xlabel("n")
ylabel("Magnitude of Im{X[n]}")

disp("3.")

function X = calculateX(N)
    a = 0.8;
    w = 0:2 * pi / (N - 1):2 * pi;

    for i = 1:length(w)
        X(i) = (1 - a ^ 2) / (1 - 2 * a * cos(w(i)) + a ^ 2);
    end

end

figure
N = 5;
subplot(3, 2, 1)
X = calculateX(N);
stem(0:2 * pi / (N - 1):2 * pi, X)
title("Magnitude of X[n] for N = " + N)
xlabel("w (rad)")
ylabel("Magnitude of X[n]")
x = dft(X, true);

subplot(3, 2, 2)
stem(x)
title("IDFT of X[n] for N = " + N)
xlabel("n")
ylabel("Magnitude of x[n]")

N = 40;
subplot(3, 2, 3)
X = calculateX(N);
stem(0:2 * pi / (N - 1):2 * pi, X)
title("Magnitude of X[n] for N = " + N)
xlabel("w (rad)")
ylabel("Magnitude of X[n]")
x = dft(X, true);

subplot(3, 2, 4)
stem(x)
title("IDFT of X[n] for N = " + N)
xlabel("n")
ylabel("Magnitude of x[n]")

N = 1000;
subplot(3, 2, 5)
X = calculateX(N);
stem(0:2 * pi / (N - 1):2 * pi, X)
title("Magnitude of X[n] for N = " + N)
xlabel("w (rad)")
ylabel("Magnitude of X[n]")
x = dft(X, true);

subplot(3, 2, 6)
stem(x)
title("IDFT of X[n] for N = " + N)
xlabel("n")
ylabel("Magnitude of x[n]")

disp("4c.")

function RMS = calculateRMS(precision)
    x = 1:64;
    X = dft(x, false);

    % Reduce the precision of the DFT
    X = round(X, precision);
    transX = dft(X, true);

    % Calculate the RMS error between the original and transformed signals
    RMS = sqrt(sum((x - real(transX)) .^ 2) / length(x));
end

digits = 1:16;
RMS = zeros(1, length(digits));

for i = 1:length(digits)
    RMS(i) = calculateRMS(digits(i));
end

figure
semilogy(digits, RMS)
title("RMS error vs. precision")
xlabel("Precision (decimal places)")
ylabel("RMS error")
