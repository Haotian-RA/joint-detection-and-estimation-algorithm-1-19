clear
clc
close all

% channel 
normalized_true_freq_offset=0.0025/4; 
normalized_true_phase_offset=2*pi*rand;
SNR=[-5 -2 0 5 10];
% SNR=0;

threshold=0:0.02:1;
L_0_set=[32 64];
n_L_0=0;pload=zeros(1,200);LL=1000;M=4;

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
    [tx] = sample_loader(L_0);
    N=length(tx);
    K = K_value(N,normalized_true_freq_offset);
    tx_shift_register = tx_register_SK(K,tx);
    sig = sig_generator(tx,normalized_true_freq_offset,normalized_true_phase_offset,pload,200);
    
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
%                 rho_container(1,win+1)=rho;
                detection_board(:,win+1) = detect_preamble(threshold,rho);
                
            end
            [N_FA(:,count),N_D(:,count)] = false_alarm_probability(detection_board,201,M,length(rec)-N+1);
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
    end
end

% P_fa(P_fa<1e-3)=0;
figure(1)
semilogy(threshold,P_fa_32)
hold on
semilogy(threshold,P_fa_64)
[hc1,ht1,hcl1] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{FA}')
legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB')

figure(2)
semilogy(threshold,P_fa_32)
hold on
semilogy(threshold,P_d_32)
[hc2,ht2,hcl2] = nice_plot(gcf);
xlabel('\gamma')
ylabel('P_{D}')
legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB')

figure(3)
loglog(P_fa_32,P_d_32)
hold on
loglog(P_fa_64,P_d_64)
[hc3,ht3,hcl3] = nice_plot(gcf);
xlabel('p_{fa}')
ylabel('p_{d}')
legend('L_0=32,SNR=-5dB','L_0=32,SNR=-2dB','L_0=32,SNR=0dB','L_0=32,SNR=5dB','L_0=64,SNR=-5dB','L_0=64,SNR=-2dB','L_0=64,SNR=0dB','L_0=64,SNR=5dB')

% figure(4)
% plot(rho_container)
% [hc,ht,hcl] = nice_plot(gcf);
% xlabel('discrete time n')
% ylabel('Generalized correlation')
% xlim([0 500])

save('P_fa_32.mat','P_fa_32')
save('P_fa_64.mat','P_fa_64')
save('P_d_32.mat','P_d_32')
save('P_d_64.mat','P_d_64')
