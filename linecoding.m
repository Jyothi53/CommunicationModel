function x3_t = linecoding (ak_s, p_t, t, Fs, Ts)
    x3_t = zeros(2,length(t));
    % tmp_p_t = p_t(length(t):end);
    tmp = length(t);
    for idx = 1:size(ak_s,1)
        for idx2 = 1:length(t)
            % disp([tmp+idx2-1, tmp, idx, idx2])
            x3_t(1,idx2) = x3_t(1,idx2) + ak_s(idx,1) * p_t(tmp+idx2-1);
            x3_t(2,idx2) = x3_t(2,idx2) + ak_s(idx,2) * p_t(tmp+idx2-1);
        end
        tmp = tmp - Fs*Ts -1;
        % disp(tmp);
    end
end