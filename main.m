% bits = [0,0,0,0,1,0,1,1,0,0,0,0];
bits = adc();
ak_s = encoder(bits);
% disp(ak_s);
Ts = 2;
Fs = 1e1;
t = 0:1/Fs:Ts;
t1 = 0:1/Fs:Ts*length(bits)/2;
tt = -Ts*length(bits)/2:1/Fs:Ts*length(bits)/2;
p_t1 = zeros(size(tt));
% rect
for idx=1:length(tt)
    if tt(idx) <= Ts && tt(idx) >= 0
        p_t1(idx) = 1;
    end
end
% raised cosine
span = length(bits);
rolloff = 0.5;
p_t2 = rcosdesign(rolloff, span, Fs*Ts);

% figure;
% plot(tt,p_t1);
x3_t = linecoding (ak_s, p_t2, t1, Fs,Ts);
figure;
plot(t1,x3_t(1,1:end));
wc = 10;
x4_t = modulation(x3_t, t1, Ts, wc);
figure;
plot(t1, x4_t);


