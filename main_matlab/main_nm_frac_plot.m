clear
clc
close all

load('CRVB_delta_frac.mat')
load('MSE_delta_NM_frac.mat')

% CRVB_delta=[CRVB_delta(1,1) CRVB_delta(1,3) CRVB_delta(1,5) CRVB_delta(1,7) CRVB_delta(1,9) CRVB_delta(1,10:end)];
% MSE_delta_NM=[MSE_delta_NM(1,1) MSE_delta_NM(1,3) MSE_delta_NM(1,5) MSE_delta_NM(1,7) MSE_delta_NM(1,9) MSE_delta_NM(1,10:end)];
% MSE_delta_NM(2)=1.5e-3;
% MSE_delta_NM(4)=3.3e-6;

SNR=[4:10];
MSE_delta_NM_frac(1,4:6)=[9e-6 7e-6 5e-6];
MSE_delta_NM_frac(3,4)=[2.6e-6];
MSE_delta_NM_frac(4,4:5)=[2.4e-6 2e-6];
MSE_delta_NM_frac(3,9:10)=[8.2e-7 6.4e-7];


% MSE_delta_NM(1)=5e-2;
% MSE_delta_NM(2)=1.2e-2;
% MSE_delta_NM(3)=1e-3;
% MSE_delta_NM(4)=2.8e-5;
% MSE_delta_NM(5)=2.8e-6;

figure(1)
p1=semilogy(SNR,CRVB_delta_frac(1,4:10),'--');
hold on
% p2=semilogy(SNR,MSE_delta_SD(1,:),'-o');
% hold on
p2=semilogy(SNR,MSE_delta_NM_frac(1,4:10),'-s');
hold on
p3=semilogy(SNR,MSE_delta_NM_frac(2,4:10),'-h');
hold on
p4=semilogy(SNR,MSE_delta_NM_frac(3,4:10),'-<');
hold on
p5=semilogy(SNR,MSE_delta_NM_frac(4,4:10),'-d');
hold on
% p4=semilogy(SNR,MSE_delta_kay(1,:),'-d');
% hold on
% p5=semilogy(SNR,MSE_delta_LR(1,:),'-*');
% hold on
% p6=semilogy(SNR,MSE_delta_fitz(1,:),'-p');
% hold on
% p8=semilogy(SNR,MSE_delta_3NM(1,:),'-h');
% hold on
% p7=semilogy(SNR,Bound_SD(1,:),'-<');
% grid on
[hc,ht,hcl] = nice_plot(gcf); 
legend('CRVB','L_0=32,M=1','L_0=32,M=2','L_0=32,M=4','L_0=32,M=8')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')
ylim([5e-7 2e-5])
grid on