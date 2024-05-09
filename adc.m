function binary_row_vector = adc (file)
    [audio, fs] = audioread(file);
    audio = mean(audio, 2);
    audio_normalized = int8(audio * 127); 
    
    downsample_factor = 100; 
    audio_downsampled = downsample(audio_normalized, downsample_factor);
    
    audio_binary = dec2bin(typecast(audio_downsampled(:), 'uint8'), 8); 
    binary_vector = audio_binary(:)';
    disp(length(binary_vector));

    binary_row_vector = zeros(1,length(binary_vector));
    for idx = 1:length(binary_row_vector)
        if binary_vector(idx) == '0'
            binary_row_vector(idx) = 0;
        else
            binary_row_vector(idx) = 1;
        end
    end
    plot(audio_downsampled);
    sound(audio, fs); % Play original audio
    pause(length(audio)/fs + 1); % Wait for audio to finish plus a little extra

end