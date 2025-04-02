% Generates 3D error plots for Q = 1:40, Tol = 0.0025:0.0025:0.3
clear;
load('lab1data.mat', "LB1229", "LB1249", "LB1269");

% Plot the error on the test data for different model orders and tolerances
model_orders = 1:40;
pinv_tol = 0.0025:0.0025:0.3; % Tolerance for pseudo-inverse

% Initialize arrays to store errors
errors_49 = zeros(length(model_orders), length(pinv_tol));
errors_69 = zeros(length(model_orders), length(pinv_tol));

for tol_idx = 1:length(pinv_tol)
    % Display the current model order and tolerance
    fprintf('Evaluating results with tolerance = %.4f\n', pinv_tol(tol_idx));

    for Q = model_orders

        % Train the model with the current order and tolerance
        [e_coeff, f_coeff] = trainFIR(LB1229.EMGrmsE, LB1229.EMGrmsF, LB1229.T, pinv_tol(tol_idx), Q);
        errors_49(Q, tol_idx) = testFIR(LB1249.EMGrmsE, LB1249.EMGrmsF, LB1249.T, e_coeff, f_coeff);
        errors_69(Q, tol_idx) = testFIR(LB1269.EMGrmsE, LB1269.EMGrmsF, LB1269.T, e_coeff, f_coeff);
    end

end

% Plotting the test 49 errors for different tolerances
fig = figure;
[X, Y] = ndgrid(model_orders, pinv_tol);
scatter3(X, Y, errors_49);
xlabel('Model Order (Q)');
ylabel('Tolerance');
zlabel('RMS Error (ADC Units)');
title('LB1249 (Test) RMS Error vs Model Order and Tolerance');
grid on;
view(45, 30); % Adjust the view angle for better visualization
saveas(fig, 'plots/lab1_tol_test_49.png');

% Plotting the test 69 errors for different tolerances
fig = figure;
scatter3(X, Y, errors_69);
xlabel('Model Order (Q)');
ylabel('Tolerance');
zlabel('RMS Error (ADC Units)');
title('LB1269 (Test) RMS Error vs Model Order and Tolerance');
grid on;
view(45, 30); % Adjust the view angle for better visualization
saveas(fig, 'plots/lab1_tol_test_69.png');
