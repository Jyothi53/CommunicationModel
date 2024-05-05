function ak_s = encoder (bitStream)
    function outSym = QPSK (twoinBits, a) 
        % takes in 2 bits, returns corresponding [am, bm]
        % 00 - (a, 0)
        % 01 - (0, a)
        % 11 - (-a, 0)
        % 10 - (0, -a)
        % using gray coding for better error correction
        if twoinBits(1) == 0 && twoinBits(2) == 0
            outSym = [a, 0];
        elseif twoinBits(1) == 0 && twoinBits(2) == 1
            outSym = [0, a];
        elseif twoinBits(1) == 1 && twoinBits(2) == 1
            outSym = [-a, 0];
        elseif twoinBits(1) == 1 && twoinBits(2) == 0
            outSym = [0, -a];
        else
            disp("Incorrect stream of bits");
            outSym = [-1,-1];
        end
    end
    ak_s = zeros(length(bitStream)/2,2);
    Ts = 1;
    a = 1;
    idx2 = 1;
    for idx = 1:2:length(bitStream)
        p = QPSK([bitStream(idx), bitStream(idx+1)], a);
        ak_s(idx2, 1) = p(1)*sqrt(2/Ts);
        ak_s(idx2, 2) = p(2)*sqrt(2/Ts);
        idx2 = idx2 + 1;
    end
end
