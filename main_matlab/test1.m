clear
clc
close all
% note when L_0=64, k is doubled. To prevent aliasing, delta_bar cannot be
% 0.005.

% channel 
normalized_true_freq_offset=0.001; 
normalized_true_phase_offset=2*pi*rand;
SNR=[-5 0 10];

threshold=0:0.02:1;
L_0_set=[32];
n_L_0=0;
LL=100;v_set=[32];
M=4;L=8;beta=0.5;c_init=10;n_zeros=250;n_pload=250;
pload=zeros(1,n_pload);rho_container1=zeros(1,n_zeros+n_pload);
rho_container2=zeros(1,n_zeros+n_pload);

% simulation result vector initialization
N_D1=zeros(length(threshold),LL);
N_FA1=zeros(length(threshold),LL);
P_D1=zeros(length(threshold),length(SNR));
P_FA1=zeros(length(threshold),length(SNR));
N_D2=zeros(length(threshold),LL);
N_FA2=zeros(length(threshold),LL);
P_D2=zeros(length(threshold),length(SNR));
P_FA2=zeros(length(threshold),length(SNR));
P_d=zeros(length(threshold),length(L_0_set));
P_fa=zeros(length(threshold),length(L_0_set));

for L_0=L_0_set
    % prepare sig
    n_L_0=n_L_0+1;
    [tx,~] = Gold_sequence(L_0,c_init,M,L,beta);
    N=length(tx);
    sig = sig_generator(tx,normalized_true_freq_offset,normalized_true_phase_offset,pload,n_zeros);
    
    n_snr=0;detection_board1=zeros(length(threshold),length(sig)-N+1);
    detection_board2=zeros(length(threshold),length(sig)-N+1);
    for snr=SNR
        n_snr=n_snr+1;
        for count=1:LL
            % generate rec for different trials and certain SNR.
            rec = rx_generator(sig,snr);
            
            for win=0:length(rec)-N
                % obtain function of detector versus index of rec
                rx=rec(1,win+1:N+win);
                
              
                    [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v_set);
                    
                    rho1 = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                    rho2 = rho_calculator(tx,rx,normalized_true_freq_offset,exp(1i*normalized_true_phase_offset));

                    rho_container1(1,win+1)=rho1;
                    rho_container2(1,win+1)=rho2;

                    detection_board1(:,win+1) = detect_preamble(threshold,rho1);
                    detection_board2(:,win+1) = detect_preamble(threshold,rho2);
                    

     
            end
            [N_FA1(:,count),N_D1(:,count)] = false_alarm_probability(detection_board1,n_zeros+1,M,length(rec)-N+1);
            [N_FA2(:,count),N_D2(:,count)] = false_alarm_probability(detection_board2,n_zeros+1,M,length(rec)-N+1);
        end
        for k=1:length(threshold)
            P_FA1(k,n_snr)=mean(N_FA1(k,:))/(ceil((length(rec)-N+1)/(2*M-1))-1);
            P_D1(k,n_snr)=mean(N_D1(k,:));
            P_FA2(k,n_snr)=mean(N_FA2(k,:))/(ceil((length(rec)-N+1)/(2*M-1))-1);
            P_D2(k,n_snr)=mean(N_D2(k,:));
        end
    end
    P_fa_32_1=P_FA1;
    P_d_32_1=P_D1;
    P_fa_32_2=P_FA2;
    P_d_32_2=P_D2;
    
end

P_fa_32_1(P_fa_32_1<1e-3)=0;
P_fa_32_2(P_fa_32_2<1e-3)=0;

figure(1)
semilogy(threshold,P_fa_32_1)
hold on
semilogy(threshold,P_fa_32_2,'--')
[hc1,ht1,hcl1] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{FA}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,ideal','L_0=32,SNR=-2dB,ideal','L_0=32,SNR=0dB,ideal','L_0=32,SNR=5dB,ideal','L_0=32,SNR=10dB,ideal','Location','northeast')
legend('L_0=32,SNR=-5dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=10dB,v=32','L_0=32,SNR=-5dB,ideal','L_0=32,SNR=0dB,ideal','L_0=32,SNR=10dB,ideal','Location','northeast')
title('\delta=0.001')

figure(2)
semilogy(threshold,P_d_32_1)
hold on
semilogy(threshold,P_d_32_2,'--')
[hc2,ht2,hcl2] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{d}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=2dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=2dB,v=32','L_0=32,SNR=10dB,v=32','Location','southwest')
legend('L_0=32,SNR=-5dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=10dB,v=32','L_0=32,SNR=-5dB,ideal','L_0=32,SNR=0dB,ideal','L_0=32,SNR=10dB,ideal','Location','northeast')
title('\delta=0.001')

figure(3)
semilogx(P_fa_32_1,P_d_32_1)
hold on
semilogx(P_fa_32_2,P_d_32_2,'--')
[hc3,ht3,hcl3] = nice_plot(gcf);
xlabel('p_{fa}')
ylabel('p_{d}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=2dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,ideal','L_0=32,SNR=-2dB,ideal','L_0=32,SNR=0dB,ideal','L_0=32,SNR=2dB,ideal','L_0=32,SNR=10dB,ideal','Location','southeast')
legend('L_0=32,SNR=-5dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=10dB,v=32','L_0=32,SNR=-5dB,ideal','L_0=32,SNR=0dB,ideal','L_0=32,SNR=10dB,ideal','Location','northeast')
title('\delta=0.001')

% figure(1)
% semilogy(threshold,P_fa_32)
% hold on
% semilogy(threshold,P_fa_64,'--')
% [hc1,ht1,hcl1] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{FA}')
% legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=32,SNR=10dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB','L_0=64,SNR=10dB')
% 
% figure(2)
% semilogy(threshold,P_d_32)
% hold on
% semilogy(threshold,P_d_64,'--')
% [hc2,ht2,hcl2] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{D}')
% legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=32,SNR=10dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB','L_0=64,SNR=10dB')
% 
% figure(3)
% semilogx(P_fa_32,P_d_32)
% hold on
% semilogx(P_fa_64,P_d_64,'--')
% [hc3,ht3,hcl3] = nice_plot(gcf);
% xlabel('p_{fa}')
% ylabel('p_{d}')
% legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=32,SNR=10dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB','L_0=64,SNR=10dB')


% save('P_fa_32.mat','P_fa_32')
% save('P_fa_64.mat','P_fa_64')
% save('P_fa_128.mat','P_fa_128')
% save('P_d_128.mat','P_d_128')

% save('P_d_32.mat','P_d_32')
% save('P_d_64.mat','P_d_64')

