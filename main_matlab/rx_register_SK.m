function rx_shift_register = rx_register_SK(K,rx,win,rx_shift_register)
% win: window number
% rec shift register for single K

N=length(rx);
if win==0 % first window
    for m=K:N-1
        rx_shift_register(m+1)=rx(m-K+1)*conj(rx(m+1));
    end
else
    rx_shift_register(1)=[];
    rx_shift_register=[rx_shift_register conj(rx(end))*rx(end-K)];    
end