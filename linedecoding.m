function y2_t = linedecoding(y3_t, Fs, Ts, p_t, t)
    
        y2_t = zeros(2, (length(t)-1)/Ts/Fs);
        lk = length(t);
        for i = 1:length(t)/Ts/Fs
            signal1 = y3_t(1, (i-1)*Fs*Ts+1:i*Fs*Ts);
            signal1 = signal1 .* p_t(lk-1:lk-1+Fs*Ts-1);
            signal2 = y3_t(2, (i-1)*Fs*Ts+1:i*Fs*Ts);
            signal2 = signal2 .* p_t(lk-1:lk-1+Fs*Ts-1);
            y2_t(1, i) = trapz(signal1) * (1/Fs);
            y2_t(2, i) = trapz(signal2) * (1/Fs);
        end
        
end
