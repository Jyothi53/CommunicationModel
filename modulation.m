function x4_t = modulation (x3_t, t, wc)
    x4_t = zeros(1,length(t));
    cos_t = cos(wc*t);
    sin_t = sin(wc*t);
    for idx=1:length(t)
        x4_t(idx) = x3_t(1,idx) .* cos_t(idx);
        x4_t(idx) = x4_t(idx) + x3_t(2,idx) .* sin_t(idx);
    end
end