function delta_LR = LR_est(z,L_0,T)
% calculate Kay estimator

N=L_0/2; % N is the design parameter and achieve the best performance at half length of the preamble.
delta_LR=0;
for m=1:N
    r_m=0;
    for k=m:L_0-1
        r_m=r_m+z(k+1)*conj(z(k-m+1));
    end
    r_m=1/(L_0-m)*r_m;
    delta_LR=delta_LR+r_m;
end
delta_LR=1/(pi*T*(N+1))*angle(delta_LR);