clear
clc
close all

load('CRVB_delta.mat')
load('MSE_delta_kay.mat')
load('MSE_delta_LR.mat')
load('MSE_delta_fitz.mat')
load('MSE_delta_3NM.mat')
SNR=[0:10];


figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p4=semilogy(SNR,MSE_delta_kay(1,:),'-d');
hold on
p5=semilogy(SNR,MSE_delta_LR(1,:),'-*');
hold on
p6=semilogy(SNR,MSE_delta_fitz(1,:),'-p');
hold on
p8=semilogy(SNR,MSE_delta_3NM(1,:),'-h');
hold on
grid on
[hc,ht,hcl] = nice_plot(gcf); 
legend('CRVB','Kay estimator','L&R estimator','Fitz estimator','3-SD improved NM estimator')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')