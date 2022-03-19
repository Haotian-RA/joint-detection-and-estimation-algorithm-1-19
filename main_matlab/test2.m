clear
clc
close all
% an important m-file. test for the detection algorithm.

% channel 
normalized_true_freq_offset=0.001; 
normalized_true_phase_offset=2*pi*rand;
SNR=[-2 0 5 10];
% SNR=[0 5 10];
% SNR=[0];

threshold=0:0.02:1;
L_0_set=[32];
n_L_0=0;
LL=100;v_set=[1 8];
M=1;L=8;beta=0.5;c_init=10;
% n_zeros=L_0_set*M;n_pload=L_0_set*M;
n_zeros=250;n_pload=250;
pload=zeros(1,n_pload);rho_container=zeros(length(v_set),n_zeros+n_pload);

% simulation result vector initialization
P_d=zeros(length(threshold),length(SNR),length(v_set));
P_fa=zeros(length(threshold),length(SNR),length(v_set));

% [tx,~] = Gold_sequence(L_0_set,c_init,M,L,beta);
[tx,~] = Gold_sequence(L_0_set,c_init);
N=length(tx);
sig = sig_generator(tx,normalized_true_freq_offset,normalized_true_phase_offset,pload,n_zeros);

n_v=0;
for v=v_set
    n_v=n_v+1;
    n_thres=0;
    for thres=threshold
        n_thres=n_thres+1;    
        n_snr=0;
        for snr=SNR
            n_snr=n_snr+1;
            n_d=0;n_fa=0;
            for count=1:LL
                % generate rec for different trials and certain SNR.
                rec = rx_generator(sig,snr);

                win=0;done=0;flag_rho=1;flag=0;reg_rho=0;reg_delta=0;reg_rx=zeros(1,length(tx));
                while done==0

                    rx=rec(1,win+1:N+win);
%                     block_v_SD=normalized_true_freq_offset;
%                     phasor_v_SD=exp(1i*normalized_true_phase_offset);
                    [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v);
                    rho = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                    [reg_rx,reg_delta,reg_rho,flag,flag_rho] = find_preamble(rho,rx,block_v_SD,thres,flag_rho,flag,reg_rho,reg_rx,reg_delta);
                    win=win+1;

                    if flag==1 || win==length(rec)-N+1
                        if win-1==250+1
                            n_d=n_d+1;
                        elseif win~=(length(rec)-N+1)
                            n_fa=n_fa+1;
                        end
                        done=1;
                    end
                end
            end
            P_d(n_thres,n_snr,n_v)=n_d/LL; % (threshold,snr,v)
            P_fa(n_thres,n_snr,n_v)=n_fa/LL;
        end
    end
end

figure(1)
semilogy(threshold,P_fa(:,1,1))
hold on
semilogy(threshold,P_fa(:,2,1))
hold on
semilogy(threshold,P_fa(:,3,1))
hold on
semilogy(threshold,P_fa(:,4,1))
hold on
semilogy(threshold,P_fa(:,1,2),'--')
hold on
semilogy(threshold,P_fa(:,2,2),'--')
hold on
semilogy(threshold,P_fa(:,3,2),'--')
hold on
semilogy(threshold,P_fa(:,4,2),'--')
hold on
[hc1,ht1,hcl1] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{FA}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
legend('L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-2dB,v=8','L_0=32,SNR=0dB,v=8','L_0=32,SNR=5dB,v=8','L_0=32,SNR=10dB,v=8','Location','southwest')
title('\delta=0.001')

figure(2)
semilogy(threshold,P_d(:,1,1))
hold on
semilogy(threshold,P_d(:,2,1))
hold on
semilogy(threshold,P_d(:,3,1))
hold on
semilogy(threshold,P_d(:,4,1))
hold on
semilogy(threshold,P_d(:,1,2),'--')
hold on
semilogy(threshold,P_d(:,2,2),'--')
hold on
semilogy(threshold,P_d(:,3,2),'--')
hold on
semilogy(threshold,P_d(:,4,2),'--')
hold on

[hc2,ht2,hcl2] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{d}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
% legend('L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32','Location','southwest')
legend('L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-2dB,v=8','L_0=32,SNR=0dB,v=8','L_0=32,SNR=5dB,v=8','L_0=32,SNR=10dB,v=8','Location','southwest')
title('\delta=0.001')

% figure(3)
% semilogx(P_fa(:,1,1),P_d(:,1,1))
% hold on
% semilogx(P_fa(:,2,1),P_d(:,2,1))
% hold on
% semilogx(P_fa(:,3,1),P_d(:,3,1))
% hold on
% semilogx(P_fa(:,1,2),P_d(:,1,2),'--')
% hold on
% semilogx(P_fa(:,2,2),P_d(:,2,2),'--')
% hold on
% semilogx(P_fa(:,3,2),P_d(:,3,2),'--')
% hold on

% [hc3,ht3,hcl3] = nice_plot(gcf);
% xlabel('p_{fa}')
% ylabel('p_{d}')
% % legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
% legend('L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1''L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32','Location','southeast')
% title('\delta=0.001')

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

