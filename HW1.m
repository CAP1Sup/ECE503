%% Prints the residue and pole of a transfer function
% @param b the numerator of the transfer function
% @param a the denominator of the transfer function
function printResideuz(b, a)
    [r, p, k] = residuez(b, a);
    num = "";
    fract = "";
    denom = "";

    % r + p
    for i = 1:size(r, 1)

        if r(i) < 0
            num = num + "  " + num2str(r(i)) + "      ";
        else
            num = num + "   " + num2str(r(i)) + "      ";
        end

        if i == size(r, 1)
            fract = fract + "-------";
        else
            fract = fract + "------- + ";
        end

        if p(i) < 0
            denom = denom + "1+" + num2str(-p(i)) + "z^-1   ";
        else
            denom = denom + "1-" + num2str(p(i)) + "z^-1   ";
        end

    end

    % k
    for i = 1:size(k, 1)

        if k(i) < 0
            fract = fract + " - " + num2str(-k(i));
        else
            fract = fract + " + " + num2str(k(i));
        end

    end

    disp(num)
    disp(fract)
    disp(denom)
end

%% Solve problem 1
disp("1a.")
printResideuz([1, -12], [1, 1, -6])

disp("1b.")
printResideuz([6, -12.5], [1, -10, 25])

disp("1c.")
printResideuz([2, -10, 15], [1, -4, 3])

%% Problem 3d.
% Generates odd and even sequences from a given x and n0
% @param x the sequence to generate odd and even sequences from
% @param n0 the MATLAB index of the zero index of the input sequence
% @return x_o the odd sequence.
% @return x_e the even sequence.
% @return sn0 the MATLAB index of the zero index of the odd and even
% output sequences. It will always be the center of the produced sequences
function [x_o, x_e, sn0] = oddEvenSeq(x, n0)
    halfway = (length(x) + 1) / 2;

    % Pad the sequence with zeros to make the halfway point at n0
    if n0 < halfway
        x = [zeros(1, 2 * (halfway - n0)), x];
    elseif n0 > halfway
        x = [x, zeros(1, 2 * (n0 - halfway))];
    end

    x_o = (x - flip(x)) / 2;
    x_e = (x + flip(x)) / 2;
    sn0 = ceil(length(x) / 2);
end

% Test the function
disp("3d.")
x = [2, 3, 4, 5, 6];
n0 = 4;
[odd, even, sn0] = oddEvenSeq(x, n0);
sn0
odd
even
