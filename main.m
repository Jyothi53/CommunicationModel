bits = [0,0,0,0,0,1,1,0];
% bits = adc();
a = 1;
Ts = 2;
ak_s = encoder(bits,a,Ts);
% disp(ak_s);

Fs = 1e4;
t = 0:1/Fs:Ts;
t1 = 0:1/Fs:Ts*length(bits)/2;
ttx = -Ts*length(bits)/2:1/Fs:Ts*length(bits)/2;
p_t1 = zeros(size(ttx));
p_t2 = zeros(size(ttx));
% rect
for idx=1:length(ttx)
    if ttx(idx) <= Ts && ttx(idx) >= 0
        p_t1(idx) = 1;
    end
end
% BW1
% plot(real(fftshift(fft(p_t1))));
% title('dffffffx')
figure;
% raised cosine
span = length(bits);
rolloff = 0.5;
for i = 1:length(ttx)
    tt = ttx(i);  % Corrected variable name from ttx to t
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

% p_t2 = (mod(tt,Ts) ~= 0).*(sin(pi*tt/Ts)./tt *Ts/pi.*cos(pi*rolloff*tt/Ts)./(1-4*(rolloff^2)*tt.^2/(Ts^2))) + 1.* (tt ==0) + 0.* (mod(tt,Ts) == 0);
plot(ttx,p_t2);
title("raised");

figure;
plot(ttx,p_t1);
title("rect")

figure;
subplot(2,1,1);
stem(1:length(bits)/2,ak_s(1:end,1));
title('mod aks');
subplot(2,1,2);
stem(1:length(bits)/2, ak_s(1:end,2));
title('mod bks')

x3_t = linecoding (ak_s, p_t2, t1, Fs,Ts);

figure;
plot(t1,x3_t(1,1:end));
title('mod  ak*pt')
figure;
plot(t1,x3_t(2,1:end));
title('mod  bk*pt')


wc = 1e5;
x4_t = modulation(x3_t, t1, Ts, wc);
figure;
plot(t1, x4_t);


N0 = 2;
standard_deviation = N0/2; 
noise = sqrt(standard_deviation) * randn(size(x4_t));


y4_t = x4_t + noise;

y3_t = demodulation(y4_t, wc , Fs,0.5,t1);
figure;
plot(t1,y3_t(1,1:end))
title("ak*p-t")

figure;
plot(t1,y3_t(2,1:end))
title("bk*p-t")

y2_t = linedecoding(y3_t,Fs,Ts,p_t2,t1);
figure;
subplot(2,1,1);
stem(1:length(bits)/2,y2_t(1,1:end));
title('aks');
subplot(2,1,2);
stem(1:length(bits)/2, y2_t(2,1:end));
title('bks')

y1_t = decoder (y2_t,a,Ts,Fs,t1);

figure;
hold on;
stem(1:length(y1_t), y1_t);
stem(1:length(bits),bits);
hold off;
legend('y1_t','bits');

prob = sum(y1_t ~= bits)/length(bits)

