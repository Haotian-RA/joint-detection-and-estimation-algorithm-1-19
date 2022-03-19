clear
clc
close all
% an important m-file. test for the detection algorithm.

% channel 
normalized_true_freq_offset=0.001; 
normalized_true_phase_offset=2*pi*rand;
% SNR=[-4 -2 -1 0 10];
% SNR=[-2 -1 0 5];
SNR=[-1];

% SNR=[0 5 10];
% SNR=[0];

% threshold=0:0.02:1;
threshold=0.3;

L_0_set=[32];
n_L_0=0;
LL=100;
% v_set=[1 16];
% v_set=[1 16];
v_set=[1];
L=8;beta=0.5;c_init=10;
M=4;
% M=1;
n_zeros=L_0_set*M*2;
n_pload=L_0_set*M*2;

% n_zeros=L_0_set;n_pload=L_0_set;
pload=zeros(1,n_pload);rho_container=zeros(length(v_set),n_zeros+n_pload);

% simulation result vector initialization
P_d=zeros(length(threshold),length(SNR),length(v_set));
P_fa=zeros(length(threshold),length(SNR),length(v_set));

[tx,~] = Gold_sequence(L_0_set,c_init,M,L,beta);
% [tx,~] = Gold_sequence(L_0_set,c_init);
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
%                         if win-1==2*L_0_set+1
                        if win-1==2*M*L_0_set+1
                            n_d=n_d+1;
                        elseif win~=(length(rec)-N+1)
                            n_fa=n_fa+1;
                        end
                        win_container(1,count)=win-1;
                        done=1;
                    end
                end
            end
            P_d(n_thres,n_snr,n_v)=n_d/LL; % (threshold,snr,v)
            P_fa(n_thres,n_snr,n_v)=n_fa/LL;
        end
    end
end

for n_v=1:length(v_set)
    for n_s=1:length(SNR)
        N_aa1(n_v,n_s)=sum(win_container(n_v,:,n_s)==256)
                N_aa2(n_v,n_s)=sum(win_container(n_v,:,n_s)==257)

                        N_aa3(n_v,n_s)=sum(win_container(n_v,:,n_s)==258)
        N_aa4(n_v,n_s)=sum(win_container(n_v,:,n_s)==512)

    end
end

% figure(1)
% semilogy(threshold,P_fa(:,1,1))
% hold on
% semilogy(threshold,P_fa(:,2,1))
% hold on
% semilogy(threshold,P_fa(:,3,1))
% hold on
% semilogy(threshold,P_fa(:,4,1))
% hold on
% semilogy(threshold,P_fa(:,5,1))
% hold on
% semilogy(threshold,P_fa(:,1,2),'--')
% hold on
% semilogy(threshold,P_fa(:,2,2),'--')
% hold on
% semilogy(threshold,P_fa(:,3,2),'--')
% hold on
% semilogy(threshold,P_fa(:,4,2),'--')
% hold on
% semilogy(threshold,P_fa(:,5,2),'--')
% hold on
% [hc1,ht1,hcl1] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{FA}')
% % legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
% legend('L_0=32,SNR=-4dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=-1dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=10dB,v=1',...
%     'L_0=32,SNR=-4dB,v=16','L_0=32,SNR=-2dB,v=16','L_0=32,SNR=-1dB,v=16','L_0=32,SNR=0dB,v=16','L_0=32,SNR=10dB,v=16','Location','southwest')
% title('\delta=0.001')
% 
% figure(2)
% semilogy(threshold,P_d(:,1,1))
% hold on
% semilogy(threshold,P_d(:,2,1))
% hold on
% semilogy(threshold,P_d(:,3,1))
% hold on
% semilogy(threshold,P_d(:,4,1))
% hold on
% semilogy(threshold,P_d(:,5,1))
% hold on
% semilogy(threshold,P_d(:,1,2),'--')
% hold on
% semilogy(threshold,P_d(:,2,2),'--')
% hold on
% semilogy(threshold,P_d(:,3,2),'--')
% hold on
% semilogy(threshold,P_d(:,4,2),'--')
% hold on
% semilogy(threshold,P_d(:,5,2),'--')
% hold on
% 
% [hc2,ht2,hcl2] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{d}')
% % legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
% % legend('L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32','Location','southwest')
% legend('L_0=32,SNR=-4dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=-1dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=10dB,v=1',...
%     'L_0=32,SNR=-4dB,v=16','L_0=32,SNR=-2dB,v=16','L_0=32,SNR=-1dB,v=16','L_0=32,SNR=0dB,v=16','L_0=32,SNR=10dB,v=16','Location','southwest')
% title('\delta=0.001')

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

figure(1)
semilogy(threshold,P_fa(:,1,1))
hold on
semilogy(threshold,P_d(:,1,1),'--')
hold on
semilogy(threshold,P_fa(:,2,1))
hold on
semilogy(threshold,P_d(:,2,1),'--')
hold on
semilogy(threshold,P_fa(:,3,1))
hold on
semilogy(threshold,P_d(:,3,1),'--')
hold on
semilogy(threshold,P_fa(:,4,1))
hold on
semilogy(threshold,P_d(:,4,1),'--')
hold on
% semilogy(threshold,P_fa(:,5,1))
% hold on
% semilogy(threshold,P_d(:,5,1),'--')
% hold on
[hc1,ht1,hcl1] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{FA},P_{d}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
legend('L_0=32,SNR=-2dB,v=1,p_{fa}','L_0=32,SNR=-2dB,v=1,p_{d}',...
    'L_0=32,SNR=-1dB,v=1,p_{fa}','L_0=32,SNR=-1dB,v=1,p_{d}',...
    'L_0=32,SNR=0dB,v=1,p_{fa}','L_0=32,SNR=0dB,v=1,p_{d}',...
    'L_0=32,SNR=5dB,v=1,p_{fa}','L_0=32,SNR=5dB,v=1,p_{d}',...
    'Location','southeast')
title('\delta=0.001')


figure(2)
semilogy(threshold,P_fa(:,1,2))
hold on
semilogy(threshold,P_d(:,1,2),'--')
hold on
semilogy(threshold,P_fa(:,2,2))
hold on
semilogy(threshold,P_d(:,2,2),'--')
hold on
semilogy(threshold,P_fa(:,3,2))
hold on
semilogy(threshold,P_d(:,3,2),'--')
hold on
semilogy(threshold,P_fa(:,4,2))
hold on
semilogy(threshold,P_d(:,4,2),'--')
hold on
% semilogy(threshold,P_fa(:,5,2))
% hold on
% semilogy(threshold,P_d(:,5,2),'--')
% hold on
[hc3,ht3,hcl3] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{FA},P_{d}')
% legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
legend('L_0=32,SNR=-2dB,v=16,p_{fa}','L_0=32,SNR=-2dB,v=16,p_{d}',...
    'L_0=32,SNR=-1dB,v=16,p_{fa}','L_0=32,SNR=-1dB,v=16,p_{d}',...
    'L_0=32,SNR=0dB,v=16,p_{fa}','L_0=32,SNR=0dB,v=16,p_{d}',...
    'L_0=32,SNR=5dB,v=16,p_{fa}','L_0=32,SNR=5dB,v=16,p_{d}',...
    'Location','southeast')
title('\delta=0.001')

% SNR=[-4 -2 -1 0 10];

% figure(1)
% semilogy(threshold,P_fa(:,1,1))
% hold on
% semilogy(threshold,P_d(:,1,1),'--')
% hold on
% semilogy(threshold,P_fa(:,2,1))
% hold on
% semilogy(threshold,P_d(:,2,1),'--')
% hold on
% semilogy(threshold,P_fa(:,3,1))
% hold on
% semilogy(threshold,P_d(:,3,1),'--')
% hold on
% semilogy(threshold,P_fa(:,4,1))
% hold on
% semilogy(threshold,P_d(:,4,1),'--')
% hold on
% % semilogy(threshold,P_fa(:,5,1))
% % hold on
% % semilogy(threshold,P_d(:,5,1),'--')
% % hold on
% [hc2,ht2,hcl2] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{FA},P_{d}')
% % legend('L_0=32,SNR=-5dB,v=1','L_0=32,SNR=-2dB,v=1','L_0=32,SNR=0dB,v=1','L_0=32,SNR=5dB,v=1','L_0=32,SNR=10dB,v=1','L_0=32,SNR=-5dB,v=32','L_0=32,SNR=-2dB,v=32','L_0=32,SNR=0dB,v=32','L_0=32,SNR=5dB,v=32','L_0=32,SNR=10dB,v=32')
% legend('L_0=32,SNR=-2dB,ideal,p_{fa}','L_0=32,SNR=-2dB,ideal,p_{d}',...
%     'L_0=32,SNR=-1dB,ideal,p_{fa}','L_0=32,SNR=-1dB,ideal,p_{d}',...
%     'L_0=32,SNR=0dB,ideal,p_{fa}','L_0=32,SNR=0dB,ideal,p_{d}',...
%     'L_0=32,SNR=5dB,ideal,p_{fa}','L_0=32,SNR=5dB,ideal,p_{d}',...
%     'Location','southeast')
% title('\delta=0.001')
