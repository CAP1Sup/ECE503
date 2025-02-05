% Problem 1a.
% Performs a convolution of two sequences, x and h, and plots the result.
% Zero indexes must be within their respective input sequences.
% @param x the first sequence
% @param x0 the MATLAB index of the zero index of the first sequence
% @param h the second sequence
% @param h0 the MATLAB index of the zero index of the second sequence
% @return y the convolution of x and h
% @return y0 the MATLAB index of the zero index of the convolution
function [y, y0] = convol(x, x0, h, h0)
    % Calculate y0
    y0 = x0 + h0 - 1;

    h = flip(h);

    % Loop through all sums of x and h
    maxI = length(x) + length(h) - 1;

    for i = 1:maxI

        % Take the sub sequences of x and h
        subX = x(max(1, i - length(h) + 1):min(i, length(x)));
        subH = h(max(length(h) - i + 1, 1):min(maxI - i + 1, length(h)));

        % Multiply each element of the sub sequences together and sum
        y(i) = 0;

        for j = 1:length(subX)
            y(i) = y(i) + subX(j) * subH(j);
        end

    end

    % Make a stem plot of the convolution
    fig = stem(1 - y0:maxI - y0, y);
    xlabel("n")
    ylabel("y[n]")
    title("Convolution of x and h")
    set(gca, 'xtick', 1 - y0:1:maxI - y0);
    grid on
    waitfor(fig)

end

% Test the function
disp("1a Test 1")
x = [1, 2, 3];
x0 = 2;
h = [-1, 4, 2, 3];
h0 = 1;
[y, y0] = convol(x, x0, h, h0)

disp("1a Test 2")
x = [1, 2, 3];
x0 = 2;
h = [2, 2, 1];
h0 = 1;
[y, y0] = convol(x, x0, h, h0)

disp("1a Test 3")
x = [-1, 0, 1];
x0 = 2;
h = [2, 2];
h0 = 1;
[y, y0] = convol(x, x0, h, h0)

disp("1a Test 4")
x = [1, 2, 3, 4, 5];
x0 = 4;
h = [6, 7, 8, 9, 10, 11];
h0 = 5;
[y, y0] = convol(x, x0, h, h0)

% Use the function
disp("1a Sample")
x = [-1, 2, 3];
x0 = 2;
h = [4, 5, 6, 7];
h0 = 3;
[y, y0] = convol(x, x0, h, h0)

disp("1b Result")
x = [1, -2, 3];
x0 = 1;
h = [0, 0, 1, 1, 1, 1];
h0 = 1;
[y, y0] = convol(x, x0, h, h0)

disp("1c Result")
x = [1, -2, 0, 2, 1];
x0 = 3;
h = [1, -2, 0, 2, 1];
h0 = 3;
[y, y0] = convol(x, x0, h, h0)

disp("1d Result")
x = [1, 4, 2, 3, 5, 3, 3, 4, 5, 7];
x0 = 1;
h = [1, 2, 1];
h0 = 1;
[y, y0] = convol(x, x0, h, h0)

disp("2 Check")
y = fft([2, 1, 0, 3]) / 4

% Problem 3e
% Plots the magnitude of the z-Transform of x[n] = a^n * u[n]
% @param a the value of a
function plotzTrans(a)
    % Create the value ranges
    range = 4;
    [x, y] = meshgrid(-range:0.01:range);

    % Define the function to be plotted
    z = x + y * j;
    X = 1 ./ (1 - a ./ z);

    % Remove any points outside of the ROC
    X(abs(z) <= abs(a)) = NaN;

    % Plot the function
    fig = mesh(x, y, abs(X));
    xlabel("Re(z)")
    ylabel("Im(z)")
    zlabel("|Z Transform|")
    title("Z Transform of x[n] = a^n * u[n] for a = " + a)
    grid on
    waitfor(fig)
end

disp("3e")
plotzTrans(0.5)
