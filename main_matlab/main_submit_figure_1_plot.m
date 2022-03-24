clear
clc
close all

load('new_1_MSE_block_v_SD_001.mat')
load('new_1_MSE_block_v_SD_0001.mat')
load('new_2_MSE_delta_NM.mat')
load('new_1_CRVB_delta.mat')
load('new_1_Bound_SD.mat')

SNR=[-10:10];
v=1;
M=1;
N=32;
[Bound_SD1] = bound_SD(N,SNR,M,v,0.01);
[Bound_SD16] = bound_SD(N,SNR,M,16,0.01);

MSE_delta_NM(1,9)=2.1e-4;
MSE_delta_NM(1,10)=0.55e-4;
MSE_delta_NM(1,11)=1.2e-5;
MSE_delta_NM(2,8)=1.83e-5;
MSE_delta_NM(2,7)=7e-5;
MSE_delta_NM(2,6)=1.9e-4;
% SNR=[-10:15];
figure(1)
p1=semilogy(SNR,CRVB_delta(1,1:21),':');
hold on
p2=semilogy(SNR,Bound_SD1(1,1:21),'-.');
hold on
p8=semilogy(SNR,Bound_SD16(1,1:21),'-.');
hold on
p3=semilogy(SNR,MSE_block_v_SD_001(1,1:21),'-');
hold on
p4=semilogy(SNR,MSE_block_v_SD_001(3,1:21),'.-');
hold on
p5=semilogy(SNR,MSE_block_v_SD_0001(3,1:21),'--.');
hold on
p6=semilogy(SNR,MSE_delta_NM(1,:),':.');
hold on
p7=semilogy(SNR,MSE_delta_NM(2,:),'--');
hold on
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
lgnd=legend({'CRVB','lower bound in (19) with v{=}1',...
    'lower bound in (19) with v{=}16',...
    'SL ($v{=}1$), $M\delta{=}0.01$',...
    'SL($v{=}16$), $M\delta{=}0.01$',...
    'SL ($v{=}16$), $M\delta{=}0.001$',...
    'NM ($v{=}1$ SL based), $M\delta{=}0.01$',...
    'NM ($v{=}16$ SL based), $M\delta{=}0.01$'},'Interpreter','latex');
set(lgnd,'FontSize',9);
% legend('CRVB','SD bound','SL-0001-1','SL-0001-16','SL-001-1','SL-001-16')
ylab=ylabel('MSE of $M\hat{\delta}$','Interpreter','latex');
% ylab=ylabel('mean squared error of M$\hat{\delta}$','Interpreter','latex');
xlab=xlabel('$E_s/N_0$ (dB)','Interpreter','latex');
set(xlab,'FontSize',12);
set(ylab,'FontSize',12);
% title('L_0=32,M=1')
ylim([4e-7 2e-4])

