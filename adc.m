function binary_row_vector = adc (file, downsample_factor)
    [audio] = audioread(file);
    audio = mean(audio, 2);
    figure;
    subplot(3,1,1);
    plot(audio);
    title('audio');
    audio_normalized = int8(audio * 127); 
    subplot(3,1,2);
    plot(audio_normalized);
    title('audio normalized');
    
    audio_downsampled = downsample(audio_normalized, downsample_factor);
    
    audio_binary = dec2bin(typecast(audio_downsampled(:), 'uint8'), 8); 
    binary_vector = audio_binary(:)';
    % disp(length(binary_vector));

    binary_row_vector = zeros(1,length(binary_vector));
    for idx = 1:length(binary_row_vector)
        if binary_vector(idx) == '0'
            binary_row_vector(idx) = 0;
        else
            binary_row_vector(idx) = 1;
        end
    end
    subplot(3,1,3);
    plot(audio_downsampled);
    title('audio downsampled');
    % sound(audio, fs); % Play original audio
    % pause(length(audio)/fs + 1); % Wait for audio to finish plus a little extra

end