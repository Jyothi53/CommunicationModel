function x4_t = modulation (x3_t, t, Tb, wc)
    x4_t = zeros(1,length(t));
    cos_t = cos(wc*t);
    sin_t = sin(wc*t);
    % idx2 = 1; idx3 = 1;
    % for idx = 1:length(t)
    %     % disp([x3_t(idx2,1,idx3), x3_t(idx2,2,idx3)])
    %     x4_t(idx) = x3_t(idx2,1,idx3) .* cos_t(idx);
    %     x4_t(idx) = x4_t(idx) + x3_t(idx2,2,idx3) .* sin_t(idx);
    %     idx3 = idx3 + 1;
    %     if t(idx) == idx2 * Tb
    %         idx2 = idx2 + 1;
    %         idx3 = 1;
    %     end
    % end
    for idx=1:length(t)
        x4_t(idx) = x3_t(1,idx) .* cos_t(idx);
        x4_t(idx) = x4_t(idx) + x3_t(2,idx) .* sin_t(idx);
    end
end