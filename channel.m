function r_t = channel (s_t, type, t1, Ts, Fs)
    standard_deviation = 1;
    if (type == "Memoryless")
        r_t = s_t + sqrt(standard_deviation) * randn(size(s_t));
    elseif (type == "Memory")
        a = 0.3;
        b = 1;
        h_t = a * (t1 == 0) + (1 - a) * (t1 == b*Fs*Ts);
        rx_t = conv(h_t, s_t);
        r_t = rx_t + sqrt(standard_deviation) * randn(size(rx_t));
        r_t = r_t(1:length(t1));
    else
        disp('Invalid argument type');
    end
end