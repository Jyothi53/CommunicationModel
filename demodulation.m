function y3_t = demodulation(y4_t, wc , Fs, BW, t)
        
        y3_t = zeros(2,length(y4_t));
        signal = y4_t.* cos(wc.*t);
        % figure;
        % plot(real(fftshift(fft(signal))));
        % title('x*cos"');
        fl = 2/Fs;
        fh = ( BW) / Fs * 2;
        filter_coeff = fir1(100,fh);
        y3_t(1,:) = 2*filter(filter_coeff,1,signal);
        signal = y4_t.* sin(wc.*t);
        % figure;
        % plot(real(fftshift(fft(signal))));
        % title('x*sin"');
        y3_t(2,:) =2* filter(filter_coeff,1,signal);

end