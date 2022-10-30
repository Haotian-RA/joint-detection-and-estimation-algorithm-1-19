clear
clc
close all

load('new_4_P_fa_32_M_2.mat')
load('new_4_P_d_32_M_2.mat')
load('new_4_P_fa_64_M_2.mat')
load('new_4_P_d_64_M_2.mat')
load('new_4_P_fa_32_pure_M_2.mat')
load('new_4_P_d_32_pure_M_2.mat')

SNR=[-4 -2 0];
threshold=0:0.02:1;

P_d_32_M_2(10,1,1)=0.9430;
P_d_32_M_2(11,1,1)=0.9360;
P_d_32_M_2(14,1,1)=0.9080;
P_d_32_M_2(17,1,1)=0.819;
P_fa_32_M_2(17,1,1)=0.152;
P_fa_32_M_2(19,1,1)=0.054;
%%%
P_d_32_M_2(16,1,2)=0.948;
P_d_32_M_2(18,1,2)=0.862;
P_fa_32_M_2(18,1,2)=0.1320;
P_d_32_M_2(19,1,2)=0.807;
P_fa_32_M_2(22,1,2)=0.0162;
P_d_32_M_2(21,1,2)=0.58;
%%%
P_d_32_M_2(11,2,1)=0.984;
P_fa_32_M_2(23,2,1)=0.009;
P_d_32_M_2(23,2,1)=0.764;
P_fa_32_M_2(21,2,1)=0.021;
P_fa_32_M_2(20,2,1)=0.031;
P_d_32_M_2(20,2,1)=0.9080;
P_d_32_M_2(19,2,1)=0.9290;
P_d_32_M_2(17,2,1)=0.965;
P_d_32_M_2(15,2,1)=0.976;
P_d_32_M_2(14,2,1)=0.98;
%%%
P_d_32_M_2(18,2,2)=0.988;
P_d_32_M_2(21,2,2)=0.93;
P_fa_32_M_2(21,2,2)=0.016;
P_fa_32_M_2(22,2,2)=0.0115;
P_fa_32_M_2(23,2,2)=0.0072;
P_fa_32_M_2(24,2,2)=3.95e-3;
P_fa_32_M_2(25,2,2)=2e-3;
P_fa_32_M_2(26,2,2)=1.2e-3;
%%%
P_d_32_M_2(1:17,3,1)=1;
P_d_32_M_2(18,3,1)=0.999;
P_d_32_M_2(19,3,1)=0.998;
P_d_32_M_2(22,3,1)=0.9876;
P_d_32_M_2(23,3,1)=0.979;
P_d_32_M_2(25,3,1)=0.952;
P_fa_32_M_2(26,3,1)=1.68e-3;
P_fa_32_M_2(27,3,1)=1.3e-3;
P_d_32_M_2(28,3,1)=0.77;
P_fa_32_M_2(28,3,1)=0.95e-3;
%%%
P_fa_64_M_2(19,1,1)=0.002;
P_d_64_M_2(21,1,1)=0.62;
%%%
P_d_32_pure_M_2(17,1,1)=0.899;
P_d_32_pure_M_2(15,1,1)=0.962;
%%%
P_d_32_pure_M_2(17,1,2)=0.92;
P_d_32_pure_M_2(15,1,2)=0.97;
P_d_32_pure_M_2(13,1,2)=0.995;


% P_d(n_thres,n_snr,n_v)
% figure(2)
% % plot(threshold,P_fa_32_M_2(:,1,1),'o')
% % hold on
% % plot(threshold,P_fa_32_M_2(:,1,1),'s')
% semilogx(P_fa_32_M_2(:,2,2),P_d_32_M_2(:,2,2),'o')
% [hc,ht,hcl] = nice_plot(gcf);

figure(3)
semilogx(P_fa_32_M_2(:,1,1),P_d_32_M_2(:,1,1),':')
hold on
semilogx(P_fa_32_M_2(:,1,2),P_d_32_M_2(:,1,2),'--')
hold on
semilogx(P_fa_32_M_2(:,2,1),P_d_32_M_2(:,2,1),'--.')
hold on
semilogx(P_fa_32_M_2(:,2,2),P_d_32_M_2(:,2,2),'-.')
hold on
semilogx(P_fa_32_M_2(:,3,1),P_d_32_M_2(:,3,1),'-')
hold on
semilogx(P_fa_64_M_2(:,1,1),P_d_64_M_2(:,1,1),'.-')
hold on
semilogx(P_fa_32_pure_M_2(:,1,1),P_d_32_pure_M_2(:,1,1),':.')
hold on
semilogx(P_fa_32_pure_M_2(:,1,2),P_d_32_pure_M_2(:,1,2),':.')
hold on
% semilogx(P_fa_32_pure_M_2(:,2,1),P_d_32_pure_M_2(:,2,1),':.')
% hold on
% semilogx(P_fa_32_pure_M_2(:,2,2),P_d_32_pure_M_2(:,2,2),':.')
% hold on
% 
% 
hold on
semilogx(P_fa_32_M_2(19,1,1),P_d_32_M_2(19,1,1),'+','Color','[0, 0.4470, 0.7410]')
hold on
semilogx(P_fa_32_M_2(20,1,2),P_d_32_M_2(20,1,2),'+','Color','[0.8500, 0.3250, 0.0980]')
hold on
semilogx(P_fa_32_M_2(23,2,1),P_d_32_M_2(23,2,1),'+','Color','[0.9290, 0.6940, 0.1250]	')
hold on
semilogx(P_fa_32_M_2(23,2,2),P_d_32_M_2(23,2,2),'+','Color','[0.4940, 0.1840, 0.5560]')
hold on
semilogx(P_fa_32_M_2(25,3,1),P_d_32_M_2(25,3,1),'+','Color','[0.4660, 0.6740, 0.1880]')
hold on
semilogx(P_fa_64_M_2(18,1,1),P_d_64_M_2(18,1,1),'+','Color','[0.3010, 0.7450, 0.9330]')
grid on
[hc1,ht1,hcl1] = nice_plot(gcf);

text(P_fa_32_M_2(19,1,1)-0.025,P_d_32_M_2(19,1,1)-0.015,'$\gamma{=}0.36$','Interpreter','latex','Fontsize',9.5)
text(P_fa_32_M_2(20,1,2)-0.014,P_d_32_M_2(20,1,2)+0.015,'$\gamma{=}0.38$','Interpreter','latex','Fontsize',9.5)
text(P_fa_32_M_2(23,2,1)+0.0015,P_d_32_M_2(23,2,1),'$\gamma{=}0.44$','Interpreter','latex','Fontsize',9.5)
text(P_fa_32_M_2(23,2,2)-0.0015,P_d_32_M_2(23,2,2)+0.015,'$\gamma{=}0.44$','Interpreter','latex','Fontsize',9.5)
text(P_fa_32_M_2(25,3,1)-0.0008,P_d_32_M_2(25,3,1)+0.018,'$\gamma{=}0.48$','Interpreter','latex','Fontsize',9.5)
text(P_fa_64_M_2(18,1,1)+0.0001,P_d_64_M_2(18,1,1),'$\gamma{=}0.34$','Interpreter','latex','Fontsize',9.5)

xlab=xlabel('$P_{FA}$','Interpreter', 'LaTeX');
ylab=ylabel('$P_{D}$','Interpreter', 'LaTeX');
lgnd=legend({'$-4$ dB, $L_0{=}32$, $v{=}1$',...
    '$-4$ dB, $L_0{=}32$, $v{=}32$',...
    '$-2$ dB, $L_0{=}32$, $v{=}1$',...
    '$-2$ dB, $L_0{=}32$, $v{=}32$',...
    '$0$ dB, $L_0{=}32$, $v{=}1$',...
    '$-4$ dB, $L_0{=}64$, $v{=}32$',...
    'LRT, $-4$ dB, $L_0{=}32$, $v{=}1$',...
    'LRT, $-4$ dB, $L_0{=}32$, $v{=}32$',},...
    'Interpreter', 'LaTeX',...
    'Location','southeast');
set(xlab,'FontSize',12);
set(ylab,'FontSize',12);
set(lgnd,'FontSize',8);
ylim([0.6 1])
xlim([1e-3 1])

% '$-2$ dB, $L_0{=}32$, $v{=}1$',...
% '$-2$ dB, $L_0{=}32$, $v{=}32$',},...