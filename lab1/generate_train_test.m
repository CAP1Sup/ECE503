% Generates training/test error plots for Q = 1:200, Tol = 0.005
clear;
load('lab1data.mat', "LB1229", "LB1249", "LB1269");

% Plot the error on the training and test data for different model orders
model_orders = 1:200;

% Initialize arrays to store test/train errors
train_errors = zeros(1, length(model_orders));
test_49_errors = zeros(1, length(model_orders));
test_69_errors = zeros(1, length(model_orders));

for Q = model_orders
    % Display the current model order
    fprintf('Evaluating results with model order Q = %d\n', Q);

    % Train the model with the current order
    [e_coeff, f_coeff] = trainFIR(LB1229.EMGrmsE, LB1229.EMGrmsF, LB1229.T, 0.005, Q);
    train_errors(Q) = testFIR(LB1229.EMGrmsE, LB1229.EMGrmsF, LB1229.T, e_coeff, f_coeff);
    test_49_errors(Q) = testFIR(LB1249.EMGrmsE, LB1249.EMGrmsF, LB1249.T, e_coeff, f_coeff);
    test_69_errors(Q) = testFIR(LB1269.EMGrmsE, LB1269.EMGrmsF, LB1269.T, e_coeff, f_coeff);
end

% Plotting the training and test errors with LB1249
fig = figure;
hold on;
plot(model_orders, train_errors, 'b-', 'LineWidth', 2);
plot(model_orders, test_49_errors, 'r-', 'LineWidth', 2);
xlabel('Model Order (Q)');
ylabel('RMS Error (ADC Units)');
title('Training and Test RMS Errors vs Model Order');
subtitle('Training Data: LB1229, Test Data: LB1249');
legend('Train Error', 'Test Error');
grid on;
hold off;
saveas(fig, 'plots/lab1_train_test_49.png');

% Plotting the training and test errors with LB1269
fig = figure;
hold on;
plot(model_orders, train_errors, 'b-', 'LineWidth', 2);
plot(model_orders, test_69_errors, 'r-', 'LineWidth', 2);
xlabel('Model Order (Q)');
ylabel('RMS Error (ADC Units)');
title('Training and Test RMS Errors vs Model Order');
subtitle('Training Data: LB1229, Test Data: LB1269');
legend('Train Error', 'Test Error');
grid on;
hold off;
saveas(fig, 'plots/lab1_train_test_69.png');
