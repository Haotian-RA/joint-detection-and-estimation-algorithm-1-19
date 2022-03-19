clear
clc
close all

L=8;beta=0.5;T=0.1;ts=0.01;
ps=srrc_fractional_delay(L,beta,T,ts);

ps_conv=conv(ps,ps)/sum(ps);
tt=(-L*T+1e-8:ts:L*T+1e-8)/L;

ps_conv_f=conv(ps.*exp(1i*2*pi*0.8*tt),ps)/sum(ps);

figure(1)
plot(tt,ps)
hold on
plot(tt,ps_conv((length(ps)-1)/2+1:(length(ps)-1)/2+length(ps)))
grid on
plot(tt,real(ps_conv_f((length(ps)-1)/2+1:(length(ps)-1)/2+length(ps))))
grid on
legend('ps','ps_conv','ps_conv_f')
