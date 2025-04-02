function [e, f] = trainFIR(e_rms, f_rms, torque, tol, Q)
    % trainFIR - Trains FIR filter coefficients for a given system.
    %
    % Syntax:
    %   [e, f] = trainFIR(e_rms, f_rms, torque, tol, Q)
    %
    % Inputs:
    %   e_rms   - Vector of RMS values for the extensor signal.
    %   f_rms   - Vector of RMS values for the flexor signal.
    %   torque  - Vector of measured actual torque values (output signal).
    %   tol     - Tolerance for the pseudo-inverse computation.
    %   Q       - Order of the FIR filter (number of previous samples to consider).
    %
    % Outputs:
    %   e       - FIR filter coefficients for the extensor input signal (e_rms).
    %   f       - FIR filter coefficients for the flexor input signal (f_rms).
    %
    % Description:
    %   This function computes the FIR filter coefficients for a system with two
    %   input signals (e_rms and f_rms) and one output signal (torque). It removes
    %   transient samples from the beginning and end of the input and output data,
    %   constructs a regression matrix (A) using the current and previous Q samples
    %   of the input signals, and solves for the filter coefficients using a
    %   pseudo-inverse approach with a specified tolerance.

    % Transient samples (to be removed from beginning and end of data)
    transient_samples = 41; % Number of samples to ignore at the beginning and end

    % Drop the transients
    e_rms = remove_transients(e_rms, transient_samples);
    f_rms = remove_transients(f_rms, transient_samples);
    torque = remove_transients(torque, transient_samples);

    N = length(e_rms);

    % Build the A matrix
    A = zeros(N - Q, 2 * (Q + 1));

    for i = 1:N - Q
        % Create a row of the A matrix using the current and previous Q samples
        A(i, :) = [flip(e_rms(i:i + Q)), flip(f_rms(i:i + Q))];
    end

    % Compute the b vector
    b = pinv(A, tol * norm(A)) * torque(Q + 1:N)';

    % Extract the coefficients for e and f
    e = b(1:Q + 1)';
    f = b(Q + 2:2 * Q + 2)';

end
