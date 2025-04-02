function RMS_error = testFIR(e_rms, f_rms, torque, e_coeff, f_coeff)
    % testFIR - Computes the Root Mean Square (RMS) error between the actual torque
    %           and the estimated torque using FIR filter coefficients.
    %
    % Syntax:
    %   RMS_error = testFIR(e_rms, f_rms, torque, e_coeff, f_coeff)
    %
    % Inputs:
    %   e_rms    - Array of RMS values for the extensor signal.
    %   f_rms    - Array of RMS values for the flexor signal.
    %   torque   - Array of measured actual torque values.
    %   e_coeff  - Coefficients for the FIR filter applied to the extensor signal (e_rms).
    %   f_coeff  - Coefficients for the FIR filter applied to the flexor signal (f_rms).
    %
    % Outputs:
    %   RMS_error - The Root Mean Square error between the actual torque and the
    %               estimated torque.
    %
    % Description:
    %   This function calculates the RMS error between the actual torque and the
    %   estimated torque. The estimation is performed using FIR filter coefficients
    %   applied to the input signals (e_rms and f_rms). The function removes transient
    %   samples from the beginning and end of the input data to ensure accurate
    %   calculations. The estimated torque is computed by convolving the input signals
    %   with their respective FIR filter coefficients.
    %
    % Example:
    %   e_rms = [1.2, 1.3, 1.4, ...]; % Example RMS values for signal e
    %   f_rms = [0.8, 0.9, 1.0, ...]; % Example RMS values for signal f
    %   torque = [10, 12, 14, ...];   % Example actual torque values
    %   e_coeff = [0.1, 0.2, 0.3];    % Example FIR coefficients for e_rms
    %   f_coeff = [0.4, 0.5, 0.6];    % Example FIR coefficients for f_rms
    %   RMS_error = testFIR(e_rms, f_rms, torque, e_coeff, f_coeff);

    % Transient samples (to be removed from beginning and end of data)
    transient_samples = 41 * 5; % Number of samples to ignore at the beginning and end
    Q = length(e_coeff) - 1;

    % Drop the startup transients
    e_rms = remove_startup_transients(e_rms, transient_samples - Q);
    f_rms = remove_startup_transients(f_rms, transient_samples - Q);
    torque = remove_startup_transients(torque, transient_samples - Q);

    N = length(e_rms);

    % Estimate the torque using the coefficients
    estimated_torque = zeros(1, N - Q);

    for i = 1:N - Q
        % Calculate the estimated torque for each sample using the coefficients
        estimated_torque(1, i) = sum(e_coeff .* flip(e_rms(i:i + Q))) + sum(f_coeff .* flip(f_rms(i:i + Q)));
    end

    RMS_error = sqrt(mean((torque(Q + 1:N) - estimated_torque) .^ 2));
end
