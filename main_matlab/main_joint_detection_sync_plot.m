clear
clc
close all

load('MSE_phi_NM.mat')
load('MSE_delta_NM.mat')
load('CRVB_delta.mat')
load('CRVB_phi.mat')

MSE_delta_NM(:,2)=[];
CRVB_delta(:,2)=[];

MSE_delta_NM(1,2)=1.5e-3;
MSE_delta_NM(1,3)=5.7e-4;
MSE_delta_NM(1,6)=3.3e-6;

MSE_delta_NM(2,3)=5e-6;
MSE_delta_NM(2,4)=7e-7;
MSE_delta_NM(2,5)=4.5e-7;

MSE_delta_NM(3,1)=1e-5;
MSE_delta_NM(3,3)=9e-8;

MSE_delta_NM(4,1)=6e-7;

SNR=[0:1 1.5:0.5:4 5:10];
figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,MSE_delta_NM(1,:),'-<');
hold on
semilogy(SNR,CRVB_delta(2,:),'--')
hold on
p3=semilogy(SNR,MSE_delta_NM(2,:),'-o');
hold on
semilogy(SNR,CRVB_delta(3,:),'--')
hold on
p4=semilogy(SNR,MSE_delta_NM(3,:),'-*');
hold on
semilogy(SNR,CRVB_delta(4,:),'--')
hold on
p5=semilogy(SNR,MSE_delta_NM(4,:),'-s');
hold on
grid on
[hc1,ht1,hcl1] = nice_plot(gcf); 
legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')

MSE_phi_NM(:,2)=[];
CRVB_phi(:,2)=[];

MSE_phi_NM(1,6)=4e-2;

MSE_phi_NM(2,1)=8e-1;
MSE_phi_NM(2,3)=7e-2;

MSE_phi_NM(3,1)=2e-1;
MSE_phi_NM(3,3)=1.4e-2;

MSE_phi_NM(4,1)=7.4e-2;
MSE_phi_NM(4,3)=6e-3;

figure(2)
p1=semilogy(SNR,CRVB_phi(1,:),'--');
hold on
p2=semilogy(SNR,MSE_phi_NM(1,:),'-<');
hold on
semilogy(SNR,CRVB_phi(2,:),'--')
hold on
p3=semilogy(SNR,MSE_phi_NM(2,:),'-o');
hold on
semilogy(SNR,CRVB_phi(3,:),'--')
hold on
p4=semilogy(SNR,MSE_phi_NM(3,:),'-*');
hold on
semilogy(SNR,CRVB_phi(4,:),'--')
hold on
p5=semilogy(SNR,MSE_phi_NM(4,:),'-s');
hold on
grid on
[hc2,ht2,hcl2] = nice_plot(gcf);
legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
ylabel('MSE(\phi)')
xlabel('E_s/N_0(dB)')