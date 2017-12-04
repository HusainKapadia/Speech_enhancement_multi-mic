function y_n = stift(X, win, frame_len, overlap, mic, fs)
    L = frame_len*fs/1000;                %frame length                         %percent overlap
    D = (1 - 0.01*overlap)*L;             %start index for overlap
    K = 1 + floor((length(X)-L)/D);       %number of sections
    y_n = zeros(size(X));

    switch win
        case 1 
             w = ones(L,1);
        case 2 
             w = hamming(L);
        case 3 
             w = hanning(L);
        case 4 
             w = bartlett(L);
        case 5 
             w = blackman(L);
    end

    for j = 1:mic
        n1 = 1;                     %start index
        for i=1:K
            Xw = X(n1:n1+L-1, j);
            Xw = [Xw; conj(Xw(end:-1:2))];
            y_n(n1:n1+L-1, j) = y_n(n1:n1+L-1, j) + real(ifft(Xw, L)).*w/norm(w);
            n1 = n1 + D;
        end
    end

end