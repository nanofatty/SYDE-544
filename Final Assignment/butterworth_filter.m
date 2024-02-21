function emg_rect_filt = butterworth_filter(emg, fs, fc)

    % Define filter parameters
    [b, a] = butter(4, fc / (fs/2));  % 4th order Butterworth filter

    emg_rect_filt = zeros(size(emg));
    for i = 1:size(emg', 3)
        emg_rect = abs(emg(:, i));  % Full-wave rectification
        emg_filt = filtfilt(b, a, emg_rect);  % Zero-phase Butterworth filtering
        emg_rect_filt(:, i) = emg_filt;
    end
end