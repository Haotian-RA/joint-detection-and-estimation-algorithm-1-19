function delta_kay = kay_est(z,L_0,T)
% calculate Kay estimator

delta_kay=0;
for k=1:L_0-1
    delta_kay=delta_kay+6*k*(L_0-k)/(L_0*(L_0^2-1))*angle(z(k+1)*conj(z(k)));
end
delta_kay=1/(2*pi*T)*delta_kay;