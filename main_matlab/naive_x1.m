function [x1] = naive_x1(L_0,Nc)
% Generate sequence x1
x1 = zeros(1,L_0+Nc);
x1(1) = 1;
x1(2:31) = 0;
for n=32:L_0+Nc
    x1(n) = xor(x1(n-31),x1(n-28));
end
x1=x1(Nc+1:end);