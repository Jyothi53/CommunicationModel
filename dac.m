function dac(binary_vector, upsample_factor)

    fs = 48000;

    output_file = "out.wav";
    binary_matrix = reshape(binary_vector, [],8).'; % Reshape back to matrix
    audio_integers = bin2dec_cus(binary_matrix); % Convert binary strings to decimal
    audio_downsampled_inverse = typecast(uint8(audio_integers), 'int8');

    audio_downsampled_inverse_double = double(audio_downsampled_inverse);
    
    % Upsample the signal
    upsampled_signal = interp1(1:length(audio_downsampled_inverse_double), audio_downsampled_inverse_double, 1:1/upsample_factor:length(audio_downsampled_inverse_double));
    upsampled_signal = upsampled_signal./127;
    figure;
    subplot(2,1,1)
    plot(audio_downsampled_inverse);
    title('audio downsampledinverse')
    subplot(2,1,2)
    plot(upsampled_signal);
    title('upsampled signal')
    
    % Save the reconstructed audio
    audiowrite(output_file, upsampled_signal, fs);
    
end