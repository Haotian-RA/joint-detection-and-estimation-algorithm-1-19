function [c] = naive_cn(L_0,c_init)
% Generate samples of pseudo-random sequence
Nc=1600;
c=xor(naive_x1(L_0,Nc),naive_x2(L_0,c_init,Nc));