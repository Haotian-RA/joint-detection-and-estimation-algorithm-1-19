function impro_SD = improved_SD_calculator(rx,tx,P)

K=floor(2*length(rx)/3/P);

AutoC_register=rx.*conj(tx);

L=length(rx)/P;

u=zeros(1,L);
for l=0:L-1
    for p=l*P:(l+1)*P-1
        u(l+1)=u(l+1)+AutoC_register(p+1);
    end
end

impro_SD=0;
for l=K:L-1
    impro_SD=impro_SD+u(l-K+1)*conj(u(l+1));
end
impro_SD=-angle(impro_SD)/(2*pi*K*P);

