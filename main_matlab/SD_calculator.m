function [delta_SD,phasor_SD] = SD_calculator(tx_shift_register,rx_shift_register,K,rx,tx)
% calculate frequency and phase of SD estimator

delta_SD=0;
for k=1:length(tx_shift_register)
    delta_SD=delta_SD+tx_shift_register(k)*rx_shift_register(k);
end
delta_SD=-angle(delta_SD)/(2*pi*K);

phasor_SD=0;
for n=0:length(tx)-1
    phasor_SD=phasor_SD+rx(1,n+1)*conj(tx(1,n+1))*exp(-1i*2*pi*delta_SD*n);
end
phasor_SD=phasor_SD/norm(tx)^2;