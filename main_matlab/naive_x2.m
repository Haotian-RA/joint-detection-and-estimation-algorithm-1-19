function [x2] = naive_x2(L_0,c_init,Nc)
% Generate sequence x2
x2 = zeros(1,L_0+Nc);
for k=0:30
    x2(k+1) = bitshift(1*(c_init & bitshift(1,k)),-k);   
end       
for n=32:L_0+Nc 
    x2(n)= xor(xor(xor(x2(n-31),x2(n-30)),x2(n-29)),x2(n-28));
end
x2=x2(Nc+1:end);