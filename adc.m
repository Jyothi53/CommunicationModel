function binary_row_vector = adc (file)

    [y, Fs] = audioread(file);
    binary_data = dec2bin(typecast(y(:), 'int16'), 16);
    binary_row = reshape(binary_data.', 1, []);

    binary_row_vector = zeros(1,length(binary_row));
    for idx = 1:length(binary_row_vector)
        if binary_row(idx) == '0'
            binary_row_vector(idx) = 0;
        else
            binary_row_vector(idx) = 1;
        end
    end
    binary_row_vector = binary_row_vector(1:10000);
end