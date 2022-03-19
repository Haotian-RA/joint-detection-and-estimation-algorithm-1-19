clear
clc
close all
v=2;
% delta_bar=-1/v:0.01:1/v;
% y=sin(pi*delta_bar*v)./sin(pi*delta_bar);
% plot(delta_bar,y)
% v^(3/4)
delta_bar=0.005;
sin(pi*delta_bar*v)/sin(pi*delta_bar)
% delta_bar=0.15;
% sin(pi*delta_bar*v)/sin(pi*delta_bar)
% delta_bar=0.1;
% snr_in_dB=0;
% snr_in=db2mag(2*snr_in_dB);
% z=sin(pi*delta_bar*v)/sin(pi*delta_bar);
% h=z^4./(v^3./(snr_in.^2)+2*v^2*z^2./snr_in).*(2./snr_in+1./snr_in.^2);
% plot(snr_in_dB,h)