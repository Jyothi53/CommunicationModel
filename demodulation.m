function y3_t = demodulation(x4_t, wc , Fs, BW, t)
        
        y3_t = zeros(2,length(x4_t));
        signal = x4_t.* cos(wc.*t);
        % figure;
        % plot(real(fftshift(fft(signal))));
        % title('x*cos"');
        fl = 2/Fs;
        fh = ( BW) / Fs * 2;
        filter_coeff = fir1(100,fh);
        y3_t(1,:) = 2*filter(filter_coeff,1,signal);
        signal = x4_t.* sin(wc.*t);
        % figure;
        % plot(real(fftshift(fft(signal))));
        % title('x*sin"');
        y3_t(2,:) =2* filter(filter_coeff,1,signal);

end