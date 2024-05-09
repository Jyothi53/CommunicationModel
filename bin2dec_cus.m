function decimal_values = bin2dec_cus(binary_matrix)

    % Determine the number of rows in the binary matrix
    num_rows = size(binary_matrix, 2);
    
    % Initialize an array to store the decimal values
    decimal_values = zeros(num_rows, 1);
    
    % Iterate over each row of the binary matrix
    for i = 1:num_rows
        % Initialize the decimal value for the current row
        decimal_value = 0;
        
        % Iterate over each bit in the binary number
        for j = 1:8
            % Calculate the contribution of the current bit to the decimal value
            contribution = binary_matrix(j, i) * 2^(8-j);
            
            % Add the contribution to the decimal value
            decimal_value = decimal_value + contribution;
        end
        
        % Store the decimal value for the current row
        decimal_values(i) = decimal_value;
    end
end
