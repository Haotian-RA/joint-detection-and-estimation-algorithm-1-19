clear
clc
close all

load('new_4_P_fa.mat')
load('new_4_P_d.mat')
load('new_4_P_fa_64.mat')
load('new_4_P_d_64.mat')

SNR=[-5 -4 -2 0];
threshold=0:0.02:1;

P_d(3,2,2)=1;
P_d(7,2,2)=1;
P_d(11,2,2)=1;
P_d(12,2,2)=1;
P_d(13,2,2)=1;
P_d(16,2,2)=0.9988;
P_d(17,2,2)=0.9970;
P_fa(26,2,2)=0.0226;
P_fa(28,2,2)=0.0083;
P_d(18,2,2)=0.9910;
P_d(23,2,2)=0.9090;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_d(15,2,1)=0.961;
P_d(21,2,1)=0.899;
P_d(19,2,1)=0.934;
P_d(22,2,1)=0.873;
P_d(23,2,1)=0.8460;
P_d(24,2,1)=0.799;
P_d(25,2,1)=0.748;
P_fa(26,2,1)=0.0183;
P_fa(27,2,1)=0.0098;
P_fa(28,2,1)=0.006;
%%%%%%%%%%%%%%%%%%%%%%%%%
P_d(23,3,2)=0.9920;
P_d(24,3,2)=0.9870;
P_d(25,3,2)=0.9790;
P_d(27,3,2)=0.9490;
P_fa(27,3,2)=0.0089;
P_fa(28,3,2)=0.004;
P_d(28,3,2)=0.914;
P_d(29,3,2)=0.880;
P_d(30,3,2)=0.831;
P_d(31,3,2)=0.728;
%%%%%%%%%%%%%%%%%%%%%%%%
P_d(22,3,1)=0.9836;
P_d(24,3,1)=0.9701;
P_d(25,3,1)=0.9591;
P_d(26,3,1)=0.9410;
P_fa(25,3,1)=0.0255;
P_fa(26,3,1)=0.0115;
P_fa(27,3,1)=0.0048;
P_d(27,3,1)=0.9120;
P_d(28,3,1)=0.8800;
P_fa(28,3,1)=0.0025;
P_fa(29,3,1)=1.2e-3;
%%%%%%%%%%%%%%%%%%%%%%%%
P_d(1:23,4,1)=1;
P_d(25,4,1)=0.999;


% figure(1)
% semilogy(threshold,P_fa_64(:,1,1))
% hold on
% semilogy(threshold,P_d_64(:,1,1),'--')
% hold on
% semilogy(threshold,P_fa_64(:,1,2))
% hold on
% semilogy(threshold,P_d_64(:,1,2),'--')
% hold on

% P_d(n_thres,n_snr,n_v)
% figure(2)
% plot(threshold,P_d(:,3,1),'o')
% hold on
% plot(threshold,P_fa(:,3,2),'s')
% semilogx(P_fa([1:15],4,1),P_d([1:15],4,1),'o')
% [hc,ht,hcl] = nice_plot(gcf);

figure(3)
semilogx(P_fa(:,2,1),P_d(:,2,1),':')
hold on
semilogx(P_fa(:,2,2),P_d(:,2,2),'--')
hold on

semilogx(P_fa(:,3,1),P_d(:,3,1),'--.')
hold on
semilogx(P_fa(:,3,2),P_d(:,3,2),'-.')
hold on

semilogx(P_fa(:,4,1),P_d(:,4,1),'-')
hold on
% semilogx(P_fa(:,4,2),P_d(:,4,2),'--')
% hold on

semilogx(P_fa_64(:,1,1),P_d_64(:,1,1),'.-')
hold on
% semilogx(P_fa_64(:,1,2),P_d_64(:,1,2),'--')
% hold on

% % semilogx([1e-3 1],[1e-3 1],':')
% % hold on

hold on
semilogx(P_fa(26,2,1),P_d(26,2,1),'+','Color','[0, 0.4470, 0.7410]')
hold on
semilogx(P_fa(27,2,2),P_d(27,2,2),'x','Color','[0.8500, 0.3250, 0.0980]')
% 
% hold on
% semilogx(P_fa([25 27 28 29],3,1),P_d([25 27 28 29],3,1),'s','Color','[0.9290, 0.6940, 0.1250]	')
% hold on
% semilogx(P_fa([25 27 28 29],3,2),P_d([25 27 28 29],3,2),'o','Color','[0.4940, 0.1840, 0.5560]')

semilogx(P_fa([26 29],3,1),P_d([26 29],3,1),'x','Color','[0.9290, 0.6940, 0.1250]	')
hold on
semilogx(P_fa([27 29],3,2),P_d([27 29],3,2),'+','Color','[0.4940, 0.1840, 0.5560]')
% 
hold on
semilogx(P_fa(28,4,1),P_d(28,4,1),'x','Color','[0.4660, 0.6740, 0.1880]')
% hold on
% semilogx(P_fa(28,4,2),P_d(28,4,2),'o','Color','[0.3010, 0.7450, 0.9330]')
hold on
semilogx(P_fa_64(22,1,1),P_d_64(22,1,1),'x','Color','[0.3010, 0.7450, 0.9330]')

 
grid on
[hc1,ht1,hcl1] = nice_plot(gcf);

% text(P_fa(21,2,2)+0.05,P_d(21,2,2),'$\gamma_{16}{=}0.4$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(21,2,1)+0.04,P_d(21,2,1),'$\gamma_{1}{=}0.4$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(23,2,2)+0.02,P_d(23,2,2),'$\gamma_{16}{=}0.44$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(23,2,1)+0.01,P_d(23,2,1),'$\gamma_{1}{=}0.44$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(25,2,2)+0.005,P_d(25,2,2),'$\gamma_{16}{=}0.48$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(25,2,1)+0.004,P_d(25,2,1),'$\gamma_{1}{=}0.48$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(26,2,2)-0.0125,P_d(26,2,2),'$\gamma_{16}{=}0.5$','Interpreter','latex','Fontsize',9.5)
text(P_fa(26,2,1)+0.003,P_d(26,2,1),'$\gamma{=}0.5$','Interpreter','latex','Fontsize',9.5)
text(P_fa(27,2,2)-0.007,P_d(27,2,2),'$\gamma{=}0.52$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(27,2,1)+0.001,P_d(27,2,1)+0.005,'$\gamma_{1}{=}0.52$','Interpreter','latex','Fontsize',9.5)
% 
% text(P_fa(25,3,2)+0.005,P_d(25,3,2),'$\gamma_{16}{=}0.48$','Interpreter','latex','Fontsize',9.5)
text(P_fa(26,3,1)+0.0015,P_d(26,3,1),'$\gamma{=}0.5$','Interpreter','latex','Fontsize',9.5)
text(P_fa(27,3,2)-0.0015,P_d(27,3,2)+0.015,'$\gamma{=}0.52$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(27,3,1)+0.0005,P_d(27,3,1),'$\gamma_{1}{=}0.52$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(28,3,2)-0.0024,P_d(28,3,2),'$\gamma_{16}{=}0.54$','Interpreter','latex','Fontsize',9.5)
% text(P_fa(28,3,1)+0.0003,P_d(28,3,1),'$\gamma_{1}{=}0.54$','Interpreter','latex','Fontsize',9.5)
text(P_fa(29,3,2)-0.0008,P_d(29,3,2)+0.018,'$\gamma{=}0.56$','Interpreter','latex','Fontsize',9.5)
text(P_fa(29,3,1)+0.0001,P_d(29,3,1),'$\gamma{=}0.56$','Interpreter','latex','Fontsize',9.5)
% 
% text(P_fa(28,4,2),P_d(28,4,2)-0.01,'$\gamma_{16}{=}0.54$','Interpreter','latex','Fontsize',9.5)
text(P_fa(28,4,1),P_d(28,4,1)-0.01,'$\gamma{=}0.54$','Interpreter','latex','Fontsize',9.5)

text(P_fa_64(22,1,1),P_d_64(22,1,1)-0.01,'$\gamma{=}0.42$','Interpreter','latex','Fontsize',9.5)

xlab=xlabel('$P_{FA}$','Interpreter', 'LaTeX');
ylab=ylabel('$P_{D}$','Interpreter', 'LaTeX');
lgnd=legend({'$-4$ dB, $L_0{=}32$, $v{=}1$',...
    '$-4$ dB, $L_0{=}32$, $v{=}16$',...
    '$-2$ dB, $L_0{=}32$, $v{=}1$',...
    '$-2$ dB, $L_0{=}32$, $v{=}16$',...
    '$0$ dB, $L_0{=}32$, $v{=}1$',...
    '$-4$ dB, $L_0{=}64$, $v{=}16$',},'Interpreter', 'LaTeX',...
    'Location','southeast');
set(xlab,'FontSize',12);
set(ylab,'FontSize',12);
set(lgnd,'FontSize',9.5);
ylim([0.6 1])
xlim([1e-3 1])
