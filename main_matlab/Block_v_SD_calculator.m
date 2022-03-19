function [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v)

K=floor(2*length(rx)/3/v);

AutoC_register=rx.*conj(tx);

L=length(rx)/v;

% preprocessing
u=zeros(1,L);
for l=0:L-1
    for p=l*v:(l+1)*v-1
        u(l+1)=u(l+1)+AutoC_register(p+1);
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

block_v_SD=0;
for l=K:L-1
    block_v_SD=block_v_SD+u(l-K+1)*conj(u(l+1));
end

block_v_SD=-angle(block_v_SD)/(2*pi*K*v);

phasor_v_SD=0;
for n=0:length(tx)-1
    phasor_v_SD=phasor_v_SD+rx(1,n+1)*conj(tx(1,n+1))*exp(-1i*2*pi*block_v_SD*n);
end
 phasor_v_SD= phasor_v_SD/norm(tx)^2;

