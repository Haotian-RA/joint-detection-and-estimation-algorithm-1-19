function tx_shift_register_AK = tx_register_AK(tx)
% tx shift register for all K

N=length(tx);
tx_shift_register_AK=zeros(N-1,N-1);
for k=1:N-1
    for m=k:N-1
        tx_shift_register_AK(k,m)=tx(m+1)*conj(tx(m-k+1));
    end
end
