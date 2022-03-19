clear
clc
close all

% L_0=32,c_init=10;
% [tx,~] = Gold_sequence(L_0,c_init);
% plot(abs(xcorr(tx))/32)
L=8;beta=1;M=1;
ps=srrc(L,beta,M);
plot(ps)
