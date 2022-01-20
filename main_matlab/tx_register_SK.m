function tx_shift_register = tx_register_SK(K,tx)
% K: sample difference for SD estimator.
% tx shift register for single K.
 
N=length(tx);
tx_shift_register=zeros(1,N-K);
for m=K:N-1
    tx_shift_register(m+1)=conj(tx(m-K+1))*tx(m+1);
end
