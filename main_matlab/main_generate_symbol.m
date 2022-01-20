clear
clc
close all

% L_0=32;
% a=2*randi([0,3],[1,L_0])+1;
% symbol32=exp(1i*pi*a/4);
% plot(abs(xcorr(symbol32))/max(abs(xcorr(symbol32))))
% 
% save('symbol32.mat','symbol32')

L_0=64;
a=2*randi([0,3],[1,L_0])+1;
symbol64=exp(1i*pi*a/4);
plot(abs(xcorr(symbol64))/max(abs(xcorr(symbol64))))

save('symbol64.mat','symbol64')