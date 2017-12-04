function xw = stift(X, n1, n2)
 X = X(:);
 
 if nargin == 1
     n1 = 1;
     n2 = length(X);
 end
 
 N = n2-n1+1;
 
 Xw = X(n1:n2);
 Xw = [Xw; conj(Xw(end:-1:2))];
 xw = real(ifft(Xw, N));

end