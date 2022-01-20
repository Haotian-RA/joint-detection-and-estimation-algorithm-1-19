function sig = sig_generator(tx,f_offset,p_offset,pload,n_zeros)
% generate preamble obtained from channel
if nargin>=4
    tx=[tx pload];
end
N=length(tx);
sig=zeros(1,N);
for k=0:N-1
    sig(1,k+1)=tx(1,k+1)*exp(1i*2*pi*f_offset*k)*exp(1i*p_offset);
end
if nargin==5
    sig=[zeros(1,n_zeros) sig];
end