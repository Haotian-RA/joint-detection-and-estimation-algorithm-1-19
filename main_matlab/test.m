clear 
clc
close all




normalized_true_freq_offset=0.0025/4;  
true_phase_offset=2*pi*rand;

SNR=[-10:10];

L_0_set=[32];

% initialization
M=4;LL=10000; % # of simulation runs
n_L_0=0; % # of L_0_set (for counting) 

L=8;beta=0.5;c_init=10;P_set=[1 2 4 8 16 32 64];

CRVB_delta=zeros(length(L_0_set),length(SNR));
% delta_SD=zeros(1,LL);
impro_SD=zeros(length(P_set),LL);
% avg_3SD=zeros(1,LL);
% MSE_delta_SD=zeros(length(L_0_set),length(SNR));
MSE_impro_SD=zeros(length(L_0_set),length(SNR));
% delta_NM=zeros(1,LL);
impro_NM=zeros(length(P_set),LL);
% delta_3NM=zeros(1,LL);
% delta_kay=zeros(1,LL);
% delta_LR=zeros(1,LL);
% delta_fitz=zeros(1,LL);
% delta_MM=zeros(1,LL);
% MSE_delta_NM=zeros(length(L_0_set),length(SNR));
MSE_impro_NM=zeros(length(L_0_set),length(SNR));
% MSE_delta_kay=zeros(length(L_0_set),length(SNR));
% MSE_delta_LR=zeros(length(L_0_set),length(SNR));
% MSE_delta_fitz=zeros(length(L_0_set),length(SNR));
% MSE_delta_MM=zeros(length(L_0_set),length(SNR));
% MSE_delta_3NM=zeros(length(L_0_set),length(SNR));

for L_0=L_0_set
    n_L_0=n_L_0+1;
    tx = Gold_sequence(L_0,c_init,M,L,beta);
    N=length(tx);
%     K = K_value(N,normalized_true_freq_offset);

%     tx_shift_register = tx_register_SK(K,tx);

    
    tx_shift_register_AK = tx_register_AK(tx);
    sig = sig_generator(tx,normalized_true_freq_offset,true_phase_offset);
    n_snr=0; % # of L_0_set (for counting) 
    for snr=SNR
        n_snr=n_snr+1;
%         rx_shift_register=zeros(1,N-K); 

        for count=1:LL
            rx = rx_generator(sig,snr);
            rx_shift_register_AK = rx_register_AK(rx);
            n_P=0;
            for P=P_set
                n_P=n_P+1;

%             rx_shift_register = rx_register_SK(K,rx,0,rx_shift_register);
%             [delta_SD(1,count),phasor_SD] = SD_calculator(tx_shift_register,rx_shift_register,K,rx,tx);
                impro_SD(n_P,count) = improved_SD_calculator(rx,tx,P);
            
%             [delta_NM(1,count),~] = NM_calculator(rx_shift_register_AK,...
%                 tx_shift_register_AK,delta_SD(1,count),tx,rx);
                [impro_NM(n_P,count),~] = NM_calculator(rx_shift_register_AK,...
                    tx_shift_register_AK,impro_SD(n_P,count),tx,rx);
%             [delta_NM(1,count),~] = NM_calculator(rx_shift_register_AK,...
%                 tx_shift_register_AK,single_SD(1,count),tx,rx);
            end
           
%             delta_MM(1,count) = MM_est(z,L_0,1); 
        end
%         MSE_delta_NM(n_L_0,n_snr) = M^2*sum((delta_NM-normalized_true_freq_offset).^2)/(LL-1);
%         MSE_delta_SD(n_L_0,n_snr) = M^2*sum((delta_SD-normalized_true_freq_offset).^2)/(LL-1);
        for c=1:length(P_set)
            MSE_impro_NM(c,n_snr) = M^2*sum((impro_NM(c,:)-normalized_true_freq_offset).^2)/(LL-1);
            MSE_impro_SD(c,n_snr) = M^2*sum((impro_SD(c,:)-normalized_true_freq_offset).^2)/(LL-1);
        end
%         MSE_delta_kay(n_L_0,n_snr) = sum((delta_kay-normalized_true_freq_offset).^2)/((LL-1));
%         MSE_delta_LR(n_L_0,n_snr) = sum((delta_LR-normalized_true_freq_offset).^2)/((LL-1));
%         MSE_delta_fitz(n_L_0,n_snr) = sum((delta_fitz-normalized_true_freq_offset).^2)/((LL-1));
%         MSE_delta_MM(n_L_0,n_snr) = sum((delta_MM-normalized_true_freq_offset).^2)/((LL-1));
%         MSE_delta_3NM(n_L_0,n_snr) = M^2*sum((delta_3NM-normalized_true_freq_offset).^2)/(LL-1);
%         MSE_delta_AVD(n_L_0,n_snr) = M^2*sum((avg_SD-normalized_true_freq_offset).^2)/(LL-1);
        CRVB_delta(1,n_snr) = 3/(2*pi^2*L_0^3*db2mag(2*snr));
    end
    
end

[Bound_SD] = bound_SD(N,SNR,M);
figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,Bound_SD(1,:),'r');
hold on
p3=semilogy(SNR,MSE_impro_SD(1,:),'-o');
hold on
p4=semilogy(SNR,MSE_impro_SD(2,:),'-d');
hold on
p5=semilogy(SNR,MSE_impro_SD(3,:),'-s');
hold on
p6=semilogy(SNR,MSE_impro_SD(4,:),'-<');
hold on
p7=semilogy(SNR,MSE_impro_SD(5,:),'-h');
hold on
p8=semilogy(SNR,MSE_impro_SD(6,:),'-p');
hold on
p9=semilogy(SNR,MSE_impro_SD(7,:),'-*');
hold on
[hc1,ht1,hcl1] = nice_plot(gcf); 
legend('CRVB','SD bound','impro_{SD1}','impro_{SD2}','impro_{SD4}','impro_{SD8}','impro_{SD16}','impro_{SD32}','impro_{SD64}')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')

figure(2)
p21=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p22=semilogy(SNR,MSE_impro_NM(1,:),'-o');
hold on
p23=semilogy(SNR,MSE_impro_NM(2,:),'-d');
hold on
p24=semilogy(SNR,MSE_impro_NM(3,:),'-s');
hold on
p25=semilogy(SNR,MSE_impro_NM(4,:),'-<');
hold on
p26=semilogy(SNR,MSE_impro_NM(5,:),'-h');
hold on
p27=semilogy(SNR,MSE_impro_NM(6,:),'-p');
hold on
p28=semilogy(SNR,MSE_impro_NM(7,:),'-*');
hold on
[hc2,ht2,hcl2] = nice_plot(gcf); 
legend('CRVB','impro_{NM1}','impro_{NM2}','impro_{NM4}','impro_{NM8}','impro_{NM16}','impro_{NM32}','impro_{NM64}')
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