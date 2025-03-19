disp("1b.")

for k = [0:19]
    ck = 0;

    for n = [0:19]
        ck = ck + (cos(2 * pi / 5 * n) + sin(pi / 2 * n)) * exp(-j * pi * k * n / 10);
    end

    ck = 1/20 * ck;

    disp("c_" + k + " = " + ck);
    disp(" ");
end

disp("3b.")
[h, w] = freqz(1/8 * [1, 3, 3, 1], 1);

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
