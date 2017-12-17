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
var_emp = zeros(1, nrmics);
mse = zeros(1, nrmics);
CRLB = zeros(1, nrmics);

for i = 1:nrmics
    %% STFT with overlap
    Y = stft(y, 3, l, o, i, fs);
    
    %% Noise Covariance 
    P1 = permute(Y, [2 3 1]);
    C = cov(P1(1:100,1:i));

    %% Estimation
    a = ones(1,i);
    P = permute(Y, [3 1 2]);
    for j = 1:size(Y,2)
        Z = P(:, :, j);
        % BLUE
        B = (a*inv(C)*Z)/(a*inv(C)*a');
        % Least Squares
        %B = pinv(a)'*Z;
        % LMMSE
        
        S_e(:, j) = B.';
    end   
     
    %% Evaluation in frequency domain
    var_emp(i) = sum(sum(abs(S_e - S).^2))/(size(Y,1)*size(Y,2));
    
    CRLB(i) = real(1/(a*inv(C)*a'));
    
    %% STIFT with overlap add
    s_e = stift(S_e, 3, l, o, 1, fs);

    %% Evaluation in time domain
    mse(i) = mean((s_e - s(1:length(s_e))).^2);
end

%% Plots
figure()
subplot(3,1,1)
plot(y), title('Noisy Speech');
subplot(3,1,2)
plot(s_e), title('Corrected Speech');
subplot(3,1,3)
plot(s), title('Clean Speech');

var_emp
CRLB

figure()
stem(var_emp, 'r', 'DisplayName', 'Empirical Variance')
hold on;
stem(CRLB, 'b', 'DisplayName', 'CRLB')
title('CRLB and Empirical Variance');
legend('show');

sound(0.01*s_e, fs)
 
figure()
stem(mse), title('Mean Square Error');
