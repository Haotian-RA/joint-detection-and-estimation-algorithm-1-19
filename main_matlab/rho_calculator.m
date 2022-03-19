function rho = rho_calculator(tx,rx,delta_SD,phasor_SD)

N=length(tx);
corrected_tx=zeros(1,N);
for k=0:N-1
    corrected_tx(k+1)=tx(k+1)*exp(1i*2*pi*delta_SD*k)*phasor_SD;
end

rho=abs(dot(rx,corrected_tx))/(norm(rx)*norm(corrected_tx));