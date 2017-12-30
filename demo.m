clc;
close all;

%% initializations
load('Data.mat')
fs = 16000;                     %sampling frequency
N = 100000;                     %length of speech
m = nrmics;                     %number of mics
y = Data(1:N,1:m);              %noisy speech
s = Clean(1:N);                 %clean speech
l = 20;                         %frame length in ms
o = 60;                         %percent overlap

S = stft(s, 3, l, o, 1, fs);    %Clean speech in Frequency domain
S_e = zeros(size(S));
var_emp = zeros(1, m);
mse = zeros(1, m);
CRLB = zeros(1, m);
CRLBpf = zeros(1, size(S,1));

for i = 1:m
    Cw = zeros(i);
    
    %% STFT with overlap
    Y = stft(y, 3, l, o, i, fs);
    
    %% Noise Covariance 
    P1 = permute(Y, [1 3 2]);
    for j = 1:200
        U1 = P1(:,:,j);
        Cw = (j*Cw + cov(U1))/(j+1);
    end
    
    Ct = var(S);
    mt = mean(S);
    
    %% Estimation
    %type
    %1 for BLUE / WLS / MLE
    %2 for LS
    %3 for LMMSE / MAP
    type = 3;
    S_e = estimate(Y, type, Cw, i, mt, Ct);
    
    %% Evaluation in frequency domain
    var_emp(i) = sum(sum(abs(S_e - S).^2))/(size(Y,1)*size(Y,2));
    
    a = ones(1, i);
    CRLB(i) = real(1/(a*inv(Cw)*a'));
    
    %% STIFT with overlap add
    s_e = stift(S_e, 3, l, o, 1, fs);

    %% Evaluation in time domain
    mse(i) = mean((s_e - s(1:length(s_e))).^2);
end

%% Plots
figure()
subplot(3,1,1)
plot3(y,1:N,1:m), title('Noisy Speech');
subplot(3,1,2)
plot(s_e), title('Corrected Speech');
subplot(3,1,3)
plot(s), title('Clean Speech');

figure()
stem(var_emp, 'r', 'DisplayName', 'Empirical Variance')
hold on;
stem(CRLB, 'b', 'DisplayName', 'CRLB')
title('CRLB and Empirical Variance');
legend('show');
 
figure()
stem(mse), title('Mean Square Error');

P2 = permute(Y, [3 1 2]);
for i = 1:size(Y,1)
    Cw2 = zeros(i);
    for k = 1:200
        U2 = P2(:,1:i,k);
        Cw2 = (k*Cw2 + cov(U2))/(k+1);
    end
    h = ones(1,i);
    CRLBpf(i) = real(inv(h*inv(Cw2)*h'));
end

figure()
stem(CRLBpf), title('CRLB per frequency band');

%% Sound
sound(0.1*s_e, fs)
