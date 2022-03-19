clear
clc
close all

% channel 
normalized_true_freq_offset=0.005; 
normalized_true_phase_offset=2*pi*rand;
% SNR=[-5 -2 0 5 10];
SNR=-5;
% SNR=[-8 -5];

threshold=0:0.02:1;
% L_0_set=[32 64];
L_0_set=32;
n_L_0=0;
% LL=1000;
LL=1;
M=4;L=8;beta=0.5;c_init=10;n_zeros=250;n_pload=250;
pload=zeros(1,n_pload);rho_container=zeros(1,n_zeros+n_pload);

% simulation result vector initialization
N_D=zeros(length(threshold),LL);
N_FA=zeros(length(threshold),LL);
P_D=zeros(length(threshold),length(SNR));
P_FA=zeros(length(threshold),length(SNR));
P_d=zeros(length(threshold),length(L_0_set));
P_fa=zeros(length(threshold),length(L_0_set));

for L_0=L_0_set
    % prepare sig
    n_L_0=n_L_0+1;
    [tx] = Gold_sequence(L_0,c_init,M,L,beta);
    N=length(tx);
    K = K_value(N,normalized_true_freq_offset);
    tx_shift_register = tx_register_SK(K,tx);
    sig = sig_generator(tx,normalized_true_freq_offset,normalized_true_phase_offset,pload,n_zeros);
    
    n_snr=0;detection_board=zeros(length(threshold),length(sig)-N+1);
    for snr=SNR
        n_snr=n_snr+1;
        for count=1:LL
            % generate rec for different trials and certain SNR.
            rec = rx_generator(sig,snr);
            
            rx_shift_register=zeros(1,N-K); 
            for win=0:length(rec)-N
                % obtain function of detector versus index of rec
                rx=rec(1,win+1:N+win);
                rx_shift_register = rx_register_SK(K,rx,win,rx_shift_register);
                [delta_SD,phasor_SD] = SD_calculator(tx_shift_register,rx_shift_register,K,rx,tx);
                rho = rho_calculator(tx,rx,delta_SD,phasor_SD);
                rho_container(1,win+1)=rho;
                detection_board(:,win+1) = detect_preamble(threshold,rho);
            end
            [N_FA(:,count),N_D(:,count)] = false_alarm_probability(detection_board,n_zeros+1,M,length(rec)-N+1);
        end
        for k=1:length(threshold)
            P_FA(k,n_snr)=mean(N_FA(k,:))/(ceil((length(rec)-N+1)/(2*M-1))-1);
            P_D(k,n_snr)=mean(N_D(k,:));
        end
    end
    if L_0==32
        P_fa_32=P_FA;
        P_d_32=P_D;
    elseif L_0==64
        P_fa_64=P_FA;
        P_d_64=P_D;
    elseif L_0==128
        P_fa_128=P_FA;
        P_d_128=P_D;
    end
end

% P_fa(P_fa<1e-3)=0;
% figure(1)
% semilogy(threshold,P_fa_32)
% hold on
% semilogy(threshold,P_fa_64)
% [hc1,ht1,hcl1] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{FA}')
% legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=32,SNR=10dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB','L_0=64,SNR=10dB')
% 
% figure(2)
% semilogy(threshold,P_d_32)
% hold on
% semilogy(threshold,P_d_64)
% [hc2,ht2,hcl2] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{D}')
% legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=32,SNR=10dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB','L_0=64,SNR=10dB')

% figure(3)
% loglog(P_fa_32,P_d_32)
% hold on
% loglog(P_fa_64,P_d_64)
% [hc3,ht3,hcl3] = nice_plot(gcf);
% xlabel('p_{fa}')
% ylabel('p_{d}')
% legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB')
txt = '\leftarrow $\bar{p}$=251';

figure(4)
plot(rho_container)
hold on
plot(n_zeros+1-M:n_zeros+1+M,rho_container(1,n_zeros+1-M:n_zeros+1+M),'o')
hold on
plot([n_zeros+1 n_zeros+1],[0 rho_container(1,n_zeros+1)],'--');
[hc,ht,hcl] = nice_plot(gcf);
text(251,0.15,'\leftarrow','Fontsize',12)
text(272,0.15,'$$\bar{p}=251$$', 'Interpreter', 'LaTeX','Fontsize',12)
xlabel('p')
ylabel('\rho(p)')
xlim([0 500])

% figure(5)
% semilogy(threshold,P_fa_128)
% [hc1,ht1,hcl1] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{FA}')
% legend('L_0=128,SNR=-8dB','L_0=128,SNR=-5dB')

% figure(6)
% semilogy(threshold,P_d_128)
% [hc2,ht2,hcl2] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{D}')
% legend('L_0=128,SNR=-8dB','L_0=128,SNR=-5dB')
% 
% save('P_fa_32.mat','P_fa_32')
% save('P_fa_64.mat','P_fa_64')
% save('P_fa_128.mat','P_fa_128')
% save('P_d_128.mat','P_d_128')

% save('P_d_32.mat','P_d_32')
% save('P_d_64.mat','P_d_64')

