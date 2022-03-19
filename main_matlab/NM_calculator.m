function [delta_NM,phi_NM] = NM_calculator(rx_shift_register_AK,tx_shift_register_AK,delta_SD,tx,rx)
% calculate frequency and phase of NM estimator

N=length(tx);
F=0;
for k=1:N-1
    for m=k:N-1
        F=F+tx_shift_register_AK(k,m)*rx_shift_register_AK(k,m)*k*exp(1i*2*pi*delta_SD*k);
    end
end
F=imag(F);

dF=0;
for k=1:N-1
    for m=k:N-1
        dF=dF+tx_shift_register_AK(k,m)*rx_shift_register_AK(k,m)*1i*2*pi*k^2*exp(1i*2*pi*delta_SD*k);
    end
end
dF=imag(dF);

delta_NM=delta_SD-F/dF;

% N=length(tx);
phasor_NM=0;
for n=0:N-1
    phasor_NM=phasor_NM+rx(1,n+1)*conj(tx(1,n+1))*exp(-1i*2*pi*delta_NM*n);
end
phasor_NM=phasor_NM/norm(tx)^2;
phi_NM=angle(phasor_NM);
if phi_NM<0
    phi_NM=phi_NM+2*pi;
end
