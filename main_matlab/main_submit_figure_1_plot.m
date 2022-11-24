clear
clc
close all

load('new_1_MSE_block_v_SD_001_M_2.mat')
load('new_1_MSE_block_v_SD_0001_M_2.mat')
load('new_1_MSE_delta_NM_M_2.mat')
load('new_1_CRVB_delta.mat')
% load('new_1_Bound_SD.mat')

SNR=[-10:10];

M=2;
N=32*M;
[Bound_SD1] = bound_SD(N,SNR,M,1,0.01/M);
[Bound_SD32] = bound_SD(N,SNR,M,32,0.01/M);

MSE_delta_NM_M_2(2,10)=6.5e-6;


figure(1)
p1=semilogy(SNR,CRVB_delta(1,1:21),'k:');
hold on
% p2=semilogy(SNR,Bound_SD1(1,1:21),'-.');
% hold on
% p8=semilogy(SNR,Bound_SD32(1,1:21),'-.');
% hold on
p3=semilogy(SNR,MSE_block_v_SD_001_M_2(1,1:21),'b--');
hold on
p4=semilogy(SNR,MSE_block_v_SD_001_M_2(2,1:21),'b-');
hold on
p5=semilogy(SNR,MSE_block_v_SD_0001_M_2(2,1:21),'g--.');
hold on
p6=semilogy(SNR,MSE_delta_NM_M_2(1,:),'r--');
hold on
p7=semilogy(SNR,MSE_delta_NM_M_2(2,:),'r-');
hold on
% p8=semilogy(linspace(-5,SNR(10),100),MSE_block_v_SD_001_M_2(1,10)*ones(1,100));
annotation('textarrow',[0.48,0.325],[0.656,0.656],'String','4dB gain','FontSize',10,'Linewidth',1,'LineStyle','--')

% p6=semilogy([-10:2 4:2:10],MSE_delta_NM(1,[1:13 15:2:21]),'o');
% hold on
% p7=semilogy([-10:2 4:2:10],MSE_delta_NM(2,[1:13 15:2:21]),'s');
% hold on
% p4=semilogy(SNR,MSE_block_v_SD_0001(2,:),'-.d');
% hold on
% p5=semilogy(SNR,MSE_block_v_SD_0001(3,:),'-.d');
% hold on
% p6=semilogy(SNR,MSE_block_v_SD_001(1,:),':o');
% hold on
% p7=semilogy(SNR,MSE_block_v_SD_001(2,:),':d');
% hold on
% p8=semilogy(SNR,MSE_block_v_SD_001(3,:),':s');
% hold on
grid on
[hc1,ht1,hcl1] = nice_plot(gcf); 
% lgnd=legend({'CRVB','lower bound in (19) with v{=}1',...
%     'lower bound in (19) with v{=}16',...
%     'SL ($v{=}1$), $M\delta{=}0.01$',...
%     'SL($v{=}16$), $M\delta{=}0.01$',...
%     'SL ($v{=}16$), $M\delta{=}0.001$',...
%     'NM ($v{=}1$ SL based), $M\delta{=}0.01$',...
%     'NM ($v{=}16$ SL based), $M\delta{=}0.01$'},'Interpreter','latex');
lgnd=legend({'CRVB',...
    'SL ($v{=}1$, $M\delta{=}0.01$)',...
    'SL ($v{=}32$, $M\delta{=}0.01$)',...
    'SL ($v{=}32$, $M\delta{=}0.001$)',...
    'NM ($v{=}1$ SL based, $M\delta{=}0.01$)',...
    'NM ($v{=}32$ SL based, $M\delta{=}0.01$)'},'Interpreter','latex','location','southwest');
% lgnd=legend({'CRVB','var[$\hat{\delta}^{(\nu)}_{SL}(k_v)$] in (18) ($v{=}1$, $M\delta{=}0.01$)',...
%     'var[$\hat{\delta}^{(\nu)}_{SL}(k_v)$] in (18) ($v{=}32$, $M\delta{=}0.01$)',...
%     'SL ($v{=}1$, $M\delta{=}0.01$)',...
%     'SL ($v{=}32$, $M\delta{=}0.01$)',...
%     'SL ($v{=}32$, $M\delta{=}0.001$)',...
%     'NM ($v{=}1$ SL based, $M\delta{=}0.01$)',...
%     'NM ($v{=}32$ SL based, $M\delta{=}0.01$)'},'Interpreter','latex');
set(lgnd,'FontSize',8.65);
% legend('CRVB','SD bound','SL-0001-1','SL-0001-16','SL-001-1','SL-001-16')
ylab=ylabel('MSE of $M\hat{\delta}$','Interpreter','latex');
% ylab=ylabel('mean squared error of M$\hat{\delta}$','Interpreter','latex');
xlab=xlabel('$E_s/N_0$ (dB)','Interpreter','latex');
set(xlab,'FontSize',12);
set(ylab,'FontSize',12);
% title('L_0=32,M=1')
ylim([4e-7 2e-4])

% var[\hat{\delta}^(\nu)(k_v)]