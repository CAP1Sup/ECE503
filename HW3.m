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
disp("1b.")
printResideuz(1, [1, -2, 1])

disp("1c.")
printResideuz([4, -3/2], [1, -3/2, -1/2])

disp("2a.")
printResideuz(1, [1, -1, -1])

disp("2b. Impulse")
printResideuz([0, 1, 1/4], [1, -3/5, 2/25])

disp("2b. Step")
printResideuz([0, 1, 1/4], [1, -8/5, 17/25, -2/25])

disp("3c.")
printResideuz([1, 2, 1], [1, 4, 4])

disp("4a.")
printResideuz([-0.25, 0.25], [1, 0.5, -0.25])