clear 
clc
close all

load('tx_conv.mat')
load('symbol_conv')
tx=tx_conv;
symbol=symbol_conv;

normalized_true_freq_offset=0.0025/4;  
true_phase_offset=2*pi*rand;

SNR=[0:10];

% type of preamble you want to test
L_0_set=[32];

% initialization
M=4;LL=100; % # of simulation runs
n_L_0=0; % # of L_0_set (for counting) 

CRVB_delta=zeros(length(L_0_set),length(SNR));
single_SD=zeros(1,LL);
avg_3SD=zeros(1,LL);
MSE_delta_SD=zeros(length(L_0_set),length(SNR));
delta_NM=zeros(1,LL);
delta_3NM=zeros(1,LL);
delta_kay=zeros(1,LL);
delta_LR=zeros(1,LL);
delta_fitz=zeros(1,LL);
delta_MM=zeros(1,LL);
MSE_delta_NM=zeros(length(L_0_set),length(SNR));
MSE_delta_kay=zeros(length(L_0_set),length(SNR));
MSE_delta_LR=zeros(length(L_0_set),length(SNR));
MSE_delta_fitz=zeros(length(L_0_set),length(SNR));
MSE_delta_MM=zeros(length(L_0_set),length(SNR));
MSE_delta_3NM=zeros(length(L_0_set),length(SNR));

for L_0=L_0_set
    n_L_0=n_L_0+1;
    tx_shift_register_AK = tx_register_AK(tx);
    sig = sig_generator(tx,normalized_true_freq_offset,true_phase_offset);
    sig_conv = sig_generator(symbol,normalized_true_freq_offset,true_phase_offset);
    N=length(tx);
    n_snr=0; % # of L_0_set (for counting) 
    for snr=SNR
        n_snr=n_snr+1;
        K = K_value(N,normalized_true_freq_offset);
        K_set=[K-M K K+M];
        for count=1:LL
            rx = rx_generator(sig,snr);
            rx_conv = rx_generator(sig_conv,snr);
            n_K = 0; % # of K_set (for counting) 
            delta_SD = zeros(1,3); 
            for K=K_set
                n_K = n_K+1;
                rx_shift_register = zeros(1,N-K);
                tx_shift_register = tx_register_SK(K,tx);
                rx_shift_register = rx_register_SK(K,rx,0,rx_shift_register);
                [delta_SD(n_K),~] = SD_calculator(tx_shift_register,rx_shift_register,K,rx,tx);
            end
            single_SD(1,count) = single_SD_est(delta_SD);
            delta_3SD = delta_SD;
            avg_3SD(1,count) = avg_SD(K,N,M,delta_3SD);
            rx_shift_register_AK = rx_register_AK(rx);
            [delta_3NM(1,count),~] = NM_calculator(rx_shift_register_AK,...
                tx_shift_register_AK,avg_3SD(1,count),tx,rx);
%             [delta_NM(1,count),~] = NM_calculator(rx_shift_register_AK,...
%                 tx_shift_register_AK,single_SD(1,count),tx,rx);
       
            z=rx_conv.*conj(symbol); % unit energy is decreased by M^2 
            delta_kay(1,count) = kay_est(z,L_0,1); 
            delta_LR(1,count) = LR_est(z,L_0,1); 
            delta_fitz(1,count) = fitz_est(z,L_0,1); 
%             delta_MM(1,count) = MM_est(z,L_0,1); 
        end
%         MSE_delta_NM(n_L_0,n_snr) = M^2*sum((delta_NM-normalized_true_freq_offset).^2)/(LL-1);
%         MSE_delta_SD(n_L_0,n_snr) = M^2*sum((single_SD-normalized_true_freq_offset).^2)/(LL-1);
        MSE_delta_kay(n_L_0,n_snr) = sum((delta_kay-normalized_true_freq_offset).^2)/((LL-1));
        MSE_delta_LR(n_L_0,n_snr) = sum((delta_LR-normalized_true_freq_offset).^2)/((LL-1));
        MSE_delta_fitz(n_L_0,n_snr) = sum((delta_fitz-normalized_true_freq_offset).^2)/((LL-1));
%         MSE_delta_MM(n_L_0,n_snr) = sum((delta_MM-normalized_true_freq_offset).^2)/((LL-1));
        MSE_delta_3NM(n_L_0,n_snr) = M^2*sum((delta_3NM-normalized_true_freq_offset).^2)/(LL-1);
%         MSE_delta_AVD(n_L_0,n_snr) = M^2*sum((avg_SD-normalized_true_freq_offset).^2)/(LL-1);
        CRVB_delta(n_L_0,n_snr) = 3/(2*pi^2*L_0^3*db2mag(2*snr));
    end
end

% [Bound_SD] = bound_SD(N,SNR,M);
figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
% p2=semilogy(SNR,MSE_delta_SD(1,:),'-o');
% hold on
% p3=semilogy(SNR,MSE_delta_NM(1,:),'-s');
% hold on
p4=semilogy(SNR,MSE_delta_kay(1,:),'-d');
hold on
p5=semilogy(SNR,MSE_delta_LR(1,:),'-*');
hold on
p6=semilogy(SNR,MSE_delta_fitz(1,:),'-p');
hold on
p8=semilogy(SNR,MSE_delta_3NM(1,:),'-h');
hold on
% p7=semilogy(SNR,Bound_SD(1,:),'-<');
% grid on
[hc,ht,hcl] = nice_plot(gcf); 
legend('CRVB','kay','LR','fitz','3NM')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')

% save('CRVB_delta.mat','CRVB_delta')
% save('MSE_delta_SD.mat','MSE_delta_SD')
% save('MSE_delta_NM.mat','MSE_delta_NM')
% save('MSE_delta_3NM.mat','MSE_delta_3NM')
% save('Bound_SD.mat','Bound_SD')

% save('CRVB_delta.mat','CRVB_delta')
% save('MSE_delta_kay.mat','MSE_delta_kay')
% save('MSE_delta_LR.mat','MSE_delta_LR')
% save('MSE_delta_fitz.mat','MSE_delta_fitz')
% save('MSE_delta_3NM.mat','MSE_delta_3NM')