clear
clc
close all

load('new_2_CRVB_delta.mat')
load('new_2_MSE_delta_NM.mat')
load('new_2_MSE_delta_kay.mat')
load('new_2_MSE_delta_LR.mat')
load('new_2_MSE_delta_fitz.mat')
load('new_1_MSE_block_v_SD_001.mat')

SNR=[-10:1:10];

MSE_delta_NM(1,9)=2.1e-4;
MSE_delta_NM(1,10)=0.55e-4;
% MSE_delta_NM(1,11)=1.1e-5;
MSE_delta_NM(2,7)=7e-5;
MSE_delta_NM(2,6)=1.9e-4;
MSE_delta_kay(1,17)=5.2e-6;
MSE_delta_kay(1,19)=0.95e-6;

figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),':');
hold on
p2=semilogy(SNR,MSE_block_v_SD_001(1,1:21),'-');
hold on
p7=semilogy(SNR,MSE_block_v_SD_001(3,1:21),':.');
hold on
p5=semilogy(SNR,MSE_delta_LR(1,:),'-.');
hold on
p6=semilogy(SNR,MSE_delta_fitz(1,:),'--');
grid on
p3=semilogy(SNR,MSE_delta_NM(1,:),'--.');
hold on
p4=semilogy(SNR,MSE_delta_kay(1,:),'.-');
hold on
[hc,ht,hcl] = nice_plot(gcf); 
lgnd=legend({'CRVB','SL ($v{=}1$)','SL ($v{=}16$)','L\&R','Fitz','NM ($v{=}1$ SL based)','Kay'},'Interpreter','latex','Location','southwest');
ylab=ylabel('MSE of $M\hat{\delta}$','Interpreter','latex');
% ylab=ylabel('mean squared error of M$\hat{\delta}$','Interpreter','latex');
xlab=xlabel('$E_s/N_0$ (dB)','Interpreter','latex');
set(xlab,'FontSize',12);
set(ylab,'FontSize',12);
ylim([4e-7 2e-4])
set(lgnd,'FontSize',9.5);

% hold on


% p3=semilogy(SNR,MSE_delta_NM(2,:),'-<');
% hold on
% % p4=semilogy(SNR,MSE_delta_NM_ideal(1,:),'-<');
% % hold on
% p5=semilogy(SNR,MSE_delta_kay(1,:),'-d');
% hold on
% p6=semilogy(SNR,MSE_delta_LR(1,:),'-*');
% hold on
% p7=semilogy(SNR,MSE_delta_fitz(1,:),'-p');
% hold on
% grid on
% [hc,ht,hcl] = nice_plot(gcf); 
% legend('CRVB','1-NM','16-NM','kay','LR','fitz')
% ylabel('MSE(M\delta)')
% xlabel('E_s/N_0(dB)')

