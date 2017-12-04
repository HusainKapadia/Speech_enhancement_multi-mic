function Y = stft(x, win, frame_len, overlap, mic, fs)
     Y = zeros(size(x));
     L = frame_len*fs/1000;                %frame length                         %percent overlap
     D = (1 - 0.01*overlap)*L;             %start index for overlap
     K = 1 + floor((length(x)-L)/D);       %number of sections

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
         n1 = 1;                           %start index
         for i=1:K
             xw(n1:n1+L-1, j) = x(n1:n1+L-1, j).*w/norm(w);
             Y(n1:n1+L-1, j) = Y(n1:n1+L-1, j) + fft(xw(n1:n1+L-1, j), L);
             n1 = n1 + D;
         end
     end

end