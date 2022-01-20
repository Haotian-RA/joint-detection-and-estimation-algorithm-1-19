function [Bound_SD] = bound_SD(N,SNR,M)
% calculate bound for SD that is derived from paper.

k=floor(2/3*N);
mag_SNR=db2mag(2*SNR);
Bound_SD=M^3./(4*pi^2*k^2*(N-k)*mag_SNR);
