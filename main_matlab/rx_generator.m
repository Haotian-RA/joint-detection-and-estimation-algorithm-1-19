function rx = rx_generator(sig,snr)
% noise is AWGN

N=length(sig);
mag_SNR=db2mag(2*snr); 
sigma=mag_SNR^(-1);
noise=sqrt(sigma/2)*(randn(1,N)+1i*randn(1,N));
rx=sig+noise;
