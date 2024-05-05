function binary_data = adc ()

    % Load the .wav file
    [y, Fs] = audioread('project.wav');
    
    % Ensure y is a col vector
    y = y(:);
    
    % Convert the audio data to binary
    binary_data = reshape(dec2bin(typecast(int16(y * 32768), 'uint16'), 16).' - '0', 1, []);

end