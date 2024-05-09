function analog_signal = dac(binary_vector)
    output_file = "out.wav";
    binary_matrix = reshape(binary_vector, [], 8); % Reshape back to matrix
    audio_integers = bin2dec(binary_matrix); % Convert binary to decimal
    audio_reconstructed = int8(audio_integers); % Convert to int8
    audio_reconstructed_normalized = double(audio_reconstructed) / 127; % Normalize to [-1, 1]
    % Save the reconstructed audio
    audiowrite(output_file, audio_reconstructed_normalized, fs);
    sound(audio_reconstructed_normalized, fs); % Play reconstructed audio
end
