function delta_fitz = fitz_est(z,L_0,T)
% calculate Fitz estimator

N=1/2*L_0; % N is the design parameter and achieve the best performance at half length of the preamble.
delta_fitz=0;
for m=1:N
    r_m=0;
    for k=m:L_0-1
        r_m=r_m+z(k+1)*conj(z(k-m+1));
    end
    r_m=1/(L_0-m)*r_m;
    delta_fitz=delta_fitz+angle(r_m)*6*m/(N*(N+1)*(2*N+1));
end
delta_fitz=1/(2*pi*T)*delta_fitz;
