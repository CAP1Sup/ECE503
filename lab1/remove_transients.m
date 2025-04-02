function seq = remove_transients(seq, transient_samples)
    % Removes a given number of transients from the beginning and end of the sequence
    % Input:
    %   seq - the sequence to process
    %   transient_samples - number of samples to remove from both ends
    % Output:
    %   seq - the sequence with transients removed

    % Ensure we don't remove more samples than available
    if length(seq) <= 2 * transient_samples
        error('Not enough samples to remove transients.');
    end

    % Remove the first and last 'transient_samples' from the sequence
    seq = seq(transient_samples + 1:length(seq) - transient_samples);
end
