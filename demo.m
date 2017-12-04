clc;
close all;

%% initializations
fs = 16000;                     %sampling frequency
N = 100000;                     %length of speech
m = 2;                          %number of mics
y = 0.01*Data(1:N,1:m);         %noisy speech
s = 0.01*Clean;                 %clean speech
L = 0.02*fs;                    %20ms frame length
o = 50;                         %percent overlap
D = (1 - 0.01*o)*L;             %start index for overlap
K = 1 + floor((length(y)-L)/D); %number of sections
Y = zeros(size(y));  
y_n = zeros(size(y));

%% STFT with overlap add
for j = 1:m
    n1 = 1;                     %start index
    for i=1:K
        Y(n1:n1+L-1,j) = Y(n1:n1+L-1,j) + stft(y(:,j), 3, n1, n1+L-1);
        n1 = n1 + D;
    end
end

%% Estimation


%% STIFT
for j = 1:m
    m1 = 1;                     %start index
    for i=1:K
        y_n(m1:m1+L-1,j) = y_n(m1:m1+L-1,j) + stift(Y(:,j), m1, m1+L-1).*hanning(L);
        m1 = m1 + D;
    end
end

plot(s);
%sound(y_n(:,2),fs);


