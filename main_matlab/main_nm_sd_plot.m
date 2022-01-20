clear
clc
close all

load('CRVB_delta.mat','CRVB_delta')
load('MSE_delta_SD.mat')
load('MSE_delta_NM.mat')
load('MSE_delta_3NM.mat')
load('Bound_SD.mat')

CRVB_delta=[CRVB_delta(1,1) CRVB_delta(1,3) CRVB_delta(1,5) CRVB_delta(1,7) CRVB_delta(1,9) CRVB_delta(1,10:end)];
MSE_delta_NM=[MSE_delta_NM(1,1) MSE_delta_NM(1,3) MSE_delta_NM(1,5) MSE_delta_NM(1,7) MSE_delta_NM(1,9) MSE_delta_NM(1,10:end)];
MSE_delta_NM(2)=1.5e-3;
MSE_delta_NM(4)=3.3e-6;

SNR=[0:10];
% MSE_delta_NM(1)=5e-2;
% MSE_delta_NM(2)=1.2e-2;
% MSE_delta_NM(3)=1e-3;
% MSE_delta_NM(4)=2.8e-5;
% MSE_delta_NM(5)=2.8e-6;

figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,MSE_delta_SD(1,:),'-o');
hold on
p3=semilogy(SNR,MSE_delta_NM(1,:),'-s');
hold on
p4=semilogy(SNR,MSE_delta_3NM(1,:),'-p');
hold on
p5=semilogy(SNR,Bound_SD(1,:));
grid on
[hc,ht,hcl] = nice_plot(gcf); 
legend('CRVB','the SD estimator','the NM estimator','3-SD improved NM estimator','lower bound for SD from (20)')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')