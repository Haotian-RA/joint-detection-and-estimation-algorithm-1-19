function [tx] = Gold_sequence(L_0,c_init,M,L,beta)
% L_0: number of samples of Gold sequence.
% c_init: a random number for example, 42.
% M: oversampling factor for further pulse shaping.
% L,beta

c = naive_cn(2*L_0, c_init);
if nargin==2
    tx = ((1.0 - 2.0*c(1:2:end))+1i*(1-2.0*c(2:2:end)))/sqrt(2);
else
    symbol = ((1.0 - 2.0*c(1:2:end))+1i*(1-2.0*c(2:2:end)))/sqrt(2);
    ps=srrc(L,beta,M);
    ps=ps/sqrt(sum(ps.^2));
    
    os_symbol=zeros(1,L_0*M); % oversampled symbol
    os_symbol(1:M:M*L_0)=symbol;
    o_tx=conv(ps,os_symbol);

    tx=o_tx(L*M+1:M:M*L+length(os_symbol)); % sampling and avoid transient
    tx=sqrt(L_0)*tx/sqrt(sum(tx.*conj(tx))); % make symbol energy be 1.
end




    

