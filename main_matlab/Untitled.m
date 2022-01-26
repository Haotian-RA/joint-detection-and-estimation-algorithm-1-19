clear
clc
close all

% % L=8;beta=0.5;M=16;L_0=32;
% L_0=128;
% symbol=Gold_sequence(L_0,5);
% plot(abs(xcorr(symbol)))
% % tx=Gold_sequence(32,42,4,5,0.5)
% 
% % ps=srrc(L,beta,M);
% % ps=ps/sqrt(sum(ps.^2));
% % 
% % os_symbol=zeros(1,L_0*M); % oversampled symbol
% % os_symbol(1:M:M*L_0)=symbol;
% % o_tx=conv(ps,os_symbol);
% % 
% % tx=o_tx(L*M+1:M*L+length(os_symbol)); % sampling and avoid transient
% % tx=sqrt(L_0)*tx/sqrt(sum(tx.*conj(tx))); % make symbol energy be 1.
% % 
% % plot(abs(tx))

N = 10 ;
x = 1:N ;
y = rand(N,1) ;
[val,idx] = max(y) ;
C = [x(idx) y(idx)] ;
plot(x,y) ;
hold on
R = 0.1 ;   % Radius of circle 
th = linspace(0,2*pi) ;
xc = C(1)+R*cos(th) ;
yc = C(2)+R*sin(th) ;
plot(xc,yc,'r') ;
axis equal



