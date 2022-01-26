function [tx] = Gold_sequence(L_0,c_init,M,L,beta,T,ts)
% L_0: number of samples of Gold sequence.
% c_init: a random number for example, 42. if c_init is fixed, gold
% sequence is fixed.
% M: oversampling factor for further pulse shaping.
% L,beta
% ts is not sampling period but time instant in srrc.

c = naive_cn(2*L_0, c_init);
if nargin==2
    tx = ((1.0 - 2.0*c(1:2:end))+1i*(1-2.0*c(2:2:end)))/sqrt(2);
elseif nargin==5
    symbol = ((1.0 - 2.0*c(1:2:end))+1i*(1-2.0*c(2:2:end)))/sqrt(2);
    ps=srrc(L,beta,M);
    ps=ps/sqrt(sum(ps.^2));
    
    os_symbol=zeros(1,L_0*M); % oversampled symbol
    os_symbol(1:M:M*L_0)=symbol;
    o_tx=conv(ps,os_symbol);

    tx=o_tx(L*M+1:M*L+length(os_symbol)); % sampling and avoid transient
    tx=sqrt(L_0)*tx/sqrt(sum(tx.*conj(tx))); % make symbol energy be 1.
else
    symbol = ((1.0 - 2.0*c(1:2:end))+1i*(1-2.0*c(2:2:end)))/sqrt(2);
    ps=srrc_fractional_delay(L,beta,T,ts);
    ps=ps/sqrt(sum(ps.^2));

    Ts=T/M;
    tau=Ts/2;
    tau=floor(tau/ts);
    os_symbol=zeros(1,L_0*T/ts); % oversampled symbol
    os_symbol(1:T/ts:L_0*T/ts)=symbol;
    o_tx=conv(ps,os_symbol);
    
    tx=o_tx(L*T/ts+1+tau:Ts/ts:L*T/ts+length(os_symbol)+tau); 
    tx=sqrt(L_0)*tx/sqrt(sum(tx.*conj(tx))); % make symbol energy be 1.
end




    

