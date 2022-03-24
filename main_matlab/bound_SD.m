function [Bound_SD] = bound_SD(N,SNR,M,v,delta)
% calculate bound for SD that is derived from paper.

derichlet=sin(pi*delta*v)/sin(pi*delta);
k=floor(2/3*N);
mag_SNR=db2mag(2*SNR);
Bound_SD=(v*M/4+derichlet^2*mag_SNR)*v*M./(4*pi^2*k^2*(N-k)/v*(mag_SNR).^2*derichlet^4);


% Bound_SD=M^3./(4*pi^2*k^2*(N-k)*mag_SNR);
