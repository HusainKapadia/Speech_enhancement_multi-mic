clc;
close all;

%% initializations
fs = 16000;                     %sampling frequency
N = 100000;                     %length of speech
m = 2;                          %number of mics
y = 0.01*Data(1:N,1:m);         %noisy speech
s = 0.01*Clean;                 %clean speech
L = 20;                         %frame length in ms
o = 50;                         %percent overlap

%% STFT with overlap add
Y = stft(y, 3, L, o, m, fs);

%% Estimation


%% STIFT
y_n = stift(Y, 3, L, o, m, fs);
%plot(y_n);
%sound(y_n(:,2),fs);


