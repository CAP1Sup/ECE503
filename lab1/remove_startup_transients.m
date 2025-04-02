function seq = remove_startup_transients(seq, transient_samples)
    % Removes a given number of transients from the beginning of the sequence
    % Input:
    %   seq - the sequence to process
    %   transient_samples - number of samples to remove from the beginning
    % Output:
    %   seq - the sequence with transients removed

    % Ensure we don't remove more samples than available
    if length(seq) <= transient_samples
        error('Not enough samples to remove transients.');
    end

    % Remove the first 'transient_samples' from the sequence
    seq = seq(transient_samples + 1:length(seq));
end
