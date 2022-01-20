function rx_shift_register_AK = rx_register_AK(rx)
% rx shift register for all K

N=length(rx);
rx_shift_register_AK=zeros(N-1,N-1);
for k=1:N-1
    for m=k:N-1
        rx_shift_register_AK(k,m)=conj(rx(m+1))*rx(m-k+1);
    end
end