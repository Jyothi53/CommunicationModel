downsample_factor = 100;
upsample_factor = downsample_factor;
bits = adc('project.wav', downsample_factor);
% bits = [0,0,0,0,1,0,0,1,1,1,1,1,0,0];
a = 4;
Ts = 2;
Fs = 1e2;
t = 0:1/Fs:Ts;
main_t = 0:1/Fs:Ts*length(bits)/2;
temp_t = -Ts*length(bits)/2:1/Fs:Ts*length(bits)/2;


% ENCODER
ak_s = encoder(bits,a);

figure;
subplot(2,1,1);
stem(0:length(bits)/2-1,ak_s(1:end,1));
xlabel('k');
ylabel('ak');
title("ak's");
subplot(2,1,2);
stem(0:length(bits)/2-1, ak_s(1:end,2));
xlabel('k');
ylabel('bk');
title("bk's");
sgtitle('Transmitter: encoding');


% LINE CODING
p_t1 = zeros(size(temp_t));
p_t2 = zeros(size(temp_t));
% rect
for idx=1:length(temp_t)
    if temp_t(idx) < Ts && temp_t(idx) >= 0
        p_t1(idx) = 1;
    end
end
% raised cosine
rolloff = 0.5;
for i = 1:length(temp_t)
    tt = temp_t(i);
    if (mod(tt,Ts) == 0)
        if (tt == 0)
            p_t2(i) = 1;
        else
            p_t2(i) = 0;
        end
    else
        p_t2(i) = (sin(pi*tt/Ts)./tt *Ts/pi.*cos(pi*rolloff*tt/Ts)./(1-4*(rolloff^2)*tt.^2/(Ts^2)));
    end
end

figure;
plot(temp_t,p_t1);
xlabel('t');
ylabel('p(t)');
title("Rectangular pulse");

figure;
plot(temp_t,p_t2);
xlabel('t');
ylabel('p(t)');
title("Raised cosine pulse");

x3_t = linecoding (ak_s, p_t2, main_t, Fs, Ts);

figure;
subplot(2,1,1);
plot(main_t,x3_t(1,1:end));
xlabel('t');
ylabel('Val');
title('\Sigma ak*p(t-kTs)');
subplot(2,1,2);
plot(main_t,x3_t(2,1:end));
xlabel('t');
ylabel('Val');
title('\Sigma bk*p(t-kTs)');
sgtitle('Transmitter: line coding');


% MODULATION
wc = 1e6;
x4_t = modulation(x3_t, main_t, wc);

figure;
plot(main_t, x4_t);
xlabel('t');
ylabel('ak*cos(wc*t) + bk*sin(wc*t)');
title('Transmitter: Modulation');


% CHANNEL
y4_t = channel(x4_t,'Memoryless',main_t, Ts, Fs);
% y4_t = channel(x4_t,'Memory',main_t, Ts, Fs);
figure;
plot(main_t, y4_t);
xlabel('t');
ylabel('y4(t)');
title('Channel with noise');


% DEMODULATION
y3_t = demodulation(y4_t, wc, Fs, 0.5, main_t);

figure;
subplot(2,1,1);
plot(main_t,y3_t(1,1:end))
title('\Sigma ak*p(t-kTs)');
subplot(2,1,2);
plot(main_t,y3_t(2,1:end))
title('\Sigma bk*p(t-kTs)');
sgtitle('Receiver: Demodulation');


% LINE DECODING
y2_t = linedecoding(y3_t,Fs,Ts,p_t2,main_t);

figure;
subplot(2,1,1);
stem(0:length(bits)/2-1,y2_t(1,1:end));
xlabel('k');
ylabel('ak');
title("ak's");
subplot(2,1,2);
stem(0:length(bits)/2-1, y2_t(2,1:end));
xlabel('k');
ylabel('bk');
title("bk's");
sgtitle('Receiver: Line Decoding');


% DECODER
y1_t = decoder (y2_t,a,Ts,Fs,main_t);


figure;
hold on;
stem(1:length(y1_t), y1_t);
stem(1:length(bits),bits);
hold off;
legend('y1_t','bits');
xlabel('n');
ylabel('Bits');
title('Input bits and Decoded Bits');

Prob_error = sum(y1_t ~= bits)/length(bits);
disp("Probability of error = " + string(Prob_error));

dac(y1_t, upsample_factor);




% Calculate the energy of p_t2 using numerical integration
% integrand_squared = @(tt) (sin(pi*tt/Ts)./tt *Ts/pi.*cos(pi*rolloff*tt/Ts)./(1-4*(rolloff^2)*tt.^2/(Ts^2))) .^2;
% energy_p_t2 = integral(integrand_squared, -inf, inf);
% disp(energy_p_t2);



% Compute the autocorrelation functions
% autocorr_x3 = xcorr(x3_t(1,:), 'biased');
% autocorr_x4 = xcorr(x4_t, 'biased');
% autocorr_y3 = xcorr(y3_t(1,:), 'biased');
% autocorr_y4 = xcorr(y4_t, 'biased');
% 
% % Compute the Fourier transforms of the autocorrelation functions
% fft_autocorr_x3 = fft(autocorr_x3);
% fft_autocorr_x4 = fft(autocorr_x4);
% fft_autocorr_y3 = fft(autocorr_y3);
% fft_autocorr_y4 = fft(autocorr_y4);
% 
% % Compute the frequencies corresponding to the Fourier transforms
% N = length(autocorr_x3);
% Fs_autocorr = 1 / (t(2) - t(1)); % Sampling frequency for autocorrelation
% freq_autocorr = Fs_autocorr * (-N/2:N/2-1) / N;
% 
% % Plot the PSDs using autocorrelation method
% figure;
% plot((abs(fft_autocorr_x3).^2));
% xlabel('Frequency (Hz)');
% ylabel('Power/Frequency');
% title('PSD of x3(t) using Autocorrelation Method');
% 
% figure;
% plot((abs(fft_autocorr_x4).^2));
% xlabel('Frequency (Hz)');
% ylabel('Power/Frequency');
% title('PSD of x4(t) using Autocorrelation Method');
% 
% figure;
% plot(freq_autocorr, fftshift(abs(fft_autocorr_y3).^2));
% xlabel('Frequency (Hz)');
% ylabel('Power/Frequency');
% title('PSD of y3(t) using Autocorrelation Method');
% 
% figure;
% plot(freq_autocorr, fftshift(abs(fft_autocorr_y4).^2));
% xlabel('Frequency (Hz)');
% ylabel('Power/Frequency');
% title('PSD of y4(t) using Autocorrelation Method');



% Plots of input and output constellations.
% r1_t = channel(ak_s(1:end,1),'Memory',main_t,Ts,Fs);
% r2_t = channel(ak_s(1:end,2),'Memory',main_t,Ts,Fs);
% 
% figure;
% subplot(1,2,1);
% scatter(ak_s(1:end,1), ak_s(1:end,2), 'b', 'filled');
% xlabel('In-phase');
% ylabel('Quadrature');
% title('Input Constellation (QPSK)');
% axis equal;
% 
% subplot(1,2,2);
% scatter(r1_t, r2_t, 'r', 'filled');
% xlabel('In-phase');
% ylabel('Quadrature');
% title('Output Constellation (with Noise)');
% axis equal;