function y1_t = decoder (y2_t,a,Ts,Fs,t1)
    function bits = QPSKdemap(ak, bk, a)
        if ak > a/2 && -a/2 < bk && bk < a/2
            bits = [0, 0];
        elseif -a/2 < ak && ak < a/2 && bk > a/2
            bits = [0, 1];
        elseif ak < -a/2 && -a/2 < bk && bk < a/2
            bits = [1, 1];
        elseif -a/2 < ak && ak < a/2 && bk < -a/2
            bits = [1, 0];
        else
            bits = [1, 1]; 
        end
    end

    ak_s = y2_t(1,1:end);
    bk_s = y2_t(2,1:end);
    y1_t = zeros(1,2*(length(t1)-1)/Ts/Fs);
    for idx = 1:(length(t1)-1)/Ts/Fs
        ak = ak_s(idx);
        bk = bk_s(idx);
        y1_t(2*idx-1:2*idx)= QPSKdemap(ak,bk,a);
    end
end
