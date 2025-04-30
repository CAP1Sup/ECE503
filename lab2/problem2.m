function y = my_qmf(x)
    y = flip(x);

    % Negate the odd indexed elements
    for i = 2:2:length(x)
        y(i) = -y(i);
    end

end

disp("2a.");
X = dbwavf('db4');
X = X / sqrt(sum(X .^ 2));
Y = my_qmf(X)
ref_Y = qmf(X)

figure;
freqz(X);
hold on;
freqz(Y);
legend('Lo\_R', 'Hi\_R');
title('Frequency Response of db4 and its QMF');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;
hold off;

function [cA, cD] = my_dwt(x, Lo_D, Hi_D)
    % Ensure that x is a column vector
    if isrow(x)
        x = x';
    end

    % Filter x
    x_low = filter(Lo_D, 1, x);
    x_high = filter(Hi_D, 1, x);

    % Downsample the filtered signals
    cA = x_low(1:2:end);
    cD = x_high(1:2:end);

    % Shift the sequences
    shift = round(length(Lo_D) / 4);
    cA = circshift(cA, -shift);
    cD = circshift(cD, -shift);

end

disp("2b.");
load('mit200.mat');
[cA1, cD1] = my_dwt(ecgsig, X, Y);
[cA2, cD2] = dwt(ecgsig, X, Y, 'mode', 'per');

figure;
subplot(2, 2, 1);
stem(cA1);
xlabel('Sample Number');
ylabel('Amplitude');
title('Approximation Sequence From my\_dwt');
subplot(2, 2, 2);
stem(cA1);
xlabel('Sample Number');
ylabel('Amplitude');
title('Approximation Sequence From MATLAB dwt');
subplot(2, 2, 3);
stem(cD1);
xlabel('Sample Number');
ylabel('Amplitude');
title('Detail Sequence From my\_dwt');
subplot(2, 2, 4);
stem(cD2);
xlabel('Sample Number');
ylabel('Amplitude');
title('Detail Sequence From MATLAB dwt');

function [C, L] = my_wavedec(x, stages, Lo_D, Hi_D)
    % Ensure that x is a column vector
    if isrow(x)
        x = x';
    end

    % Initialize the output
    L = zeros(1, stages + 2);
    C = [];

    L(stages + 2) = length(x);

    % Perform the wavelet decomposition
    for i = 1:stages
        [cA, cD] = my_dwt(x, Lo_D, Hi_D);
        C = [cD; C];
        L(stages + 2 - i) = length(cD);
        x = cA;

        % If this is the last stage, store the approximation coefficients and length
        if i == stages
            C = [cA; C];
            L(1) = length(cA);
        end

    end

end

disp("2c.");
[C, L] = my_wavedec(ecgsig, 5, X, Y);

tiledlayout(figure, ceil(length(L) / 3), 3);

% Plot the original signal
nexttile([1, 3]);
plot(ecgsig);
xlabel('Sample Number');
ylabel('Amplitude');
title('Original Signal');

start = 1;

for i = 1:length(L) - 1
    nexttile;
    plot(C(start:start + L(i) - 1));
    start = start + L(i);
    xlabel('Sample Number');
    ylabel('Amplitude');

    if i == 1
        title(sprintf('Approximation Coefficients at Stage %d', length(L) - 2));
    else
        title(sprintf('Detail Coefficients at Stage %d', length(L) - i));
    end

end

disp("2d.");
% Reconstruct the signal
dwtmode('per');
x = waverec(C, L, flip(X), flip(Y));
figure;
plot(ecgsig);
hold on;
plot(x);
xlabel('Sample Number');
ylabel('Amplitude');
title('Original and Reconstructed Signals');
legend('Original Signal', 'Reconstructed Signal');
grid on;
hold off;

% Filter the decomposed signals
% Set the approximated coefficients to zero
C(1:L(1) - 1) = 0;

% Set the detail 1 and 2 coefficients to zero
C(end - L(end - 1) - L(end - 2) + 1:end) = 0;

% Then reconstruct and plot against the original signal
x = waverec(C, L, flip(X), flip(Y));
figure;
subplot(2, 1, 1);
plot(ecgsig);
xlabel('Sample Number');
ylabel('Amplitude');
title('Original Signal');
grid on;

subplot(2, 1, 2);
plot(x);
xlabel('Sample Number');
ylabel('Amplitude');
title('Filtered Signal');
grid on;
