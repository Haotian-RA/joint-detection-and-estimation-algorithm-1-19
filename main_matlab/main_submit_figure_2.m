clear
clc
close all

% channel
% M=2;
M=1;
normalized_true_freq_offset=0.025/M;  % do not approach CRB at 0.01
true_phase_offset=2*pi*rand;
SNR=[-10:1:10];

% simulation initialization
L_0_set=[32];
% M=2;
% LL=5000; 
LL=1;
n_L_0=0;  
L=8;beta=0.5;c_init=10;v_set=[1 16];

CRVB_delta=zeros(length(L_0_set),length(SNR));
block_v_SD=zeros(length(v_set),LL);
delta_NM=zeros(1,LL);
delta_NM_ideal=zeros(1,LL);
delta_kay=zeros(1,LL);
delta_LR=zeros(1,LL);
delta_fitz=zeros(1,LL);

MSE_block_v_SD=zeros(length(L_0_set),length(SNR));
MSE_delta_NM=zeros(length(L_0_set),length(SNR));
MSE_delta_NM_ideal=zeros(length(L_0_set),length(SNR));
MSE_delta_kay=zeros(length(L_0_set),length(SNR));
MSE_delta_LR=zeros(length(L_0_set),length(SNR));
MSE_delta_fitz=zeros(length(L_0_set),length(SNR));

for L_0=L_0_set
    n_L_0=n_L_0+1;
        
    [tx,~] = Gold_sequence(L_0,c_init);
%     [tx,~] = Gold_sequence(L_0,c_init,M,L,beta);
    
    N=length(tx);
    tx_shift_register_AK = tx_register_AK(tx);
    sig = sig_generator(tx,normalized_true_freq_offset,true_phase_offset);
    
    n_snr=0; % # of L_0_set (for counting) 
    for snr=SNR
        n_snr=n_snr+1;

        for count=1:LL
            rx = rx_generator(sig,snr);
            rx_shift_register_AK = rx_register_AK(rx);

            n_P=0;
            for v=v_set
                n_P=n_P+1;

                [block_v_SD(n_P,count),~] = Block_v_SD_calculator(rx,tx,v);
                [delta_NM(n_P,count),~] = NM_calculator(rx_shift_register_AK,...
                    tx_shift_register_AK,block_v_SD(n_P,count),tx,rx);
            end
            
%             [delta_NM_ideal(1,count),~] = NM_calculator(rx_shift_register_AK,...
%                     tx_shift_register_AK,normalized_true_freq_offset,tx,rx);
            z=rx.*conj(tx); % unit energy is decreased by M^2 
            delta_kay(1,count) = kay_est(z,L_0,1); 
            delta_LR(1,count) = LR_est(z,L_0,1); 
            delta_fitz(1,count) = fitz_est(z,L_0,1); 
        end

        for c=1:length(v_set)
            MSE_delta_NM(c,n_snr) = M^2*sum((delta_NM(c,:)-normalized_true_freq_offset).^2)/(LL-1);
            MSE_block_v_SD(c,n_snr) = M^2*sum((block_v_SD(c,:)-normalized_true_freq_offset).^2)/(LL-1);
        end
%         MSE_delta_NM_ideal(n_L_0,n_snr) = M^2*sum((delta_NM_ideal-normalized_true_freq_offset).^2)/(LL-1);
        MSE_delta_kay(n_L_0,n_snr) = sum((delta_kay-normalized_true_freq_offset).^2)/((LL-1));
        MSE_delta_LR(n_L_0,n_snr) = sum((delta_LR-normalized_true_freq_offset).^2)/((LL-1));
        MSE_delta_fitz(n_L_0,n_snr) = sum((delta_fitz-normalized_true_freq_offset).^2)/((LL-1));
        CRVB_delta(n_L_0,n_snr) = 3/(2*pi^2*L_0^3*db2mag(2*snr));
    end
end

figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,MSE_delta_NM(1,:));
hold on
p3=semilogy(SNR,MSE_delta_NM(2,:));
hold on
% p4=semilogy(SNR,MSE_delta_NM_ideal(1,:),'-<');
% hold on
p5=semilogy(SNR,MSE_delta_kay(1,:));
hold on
p6=semilogy(SNR,MSE_delta_LR(1,:));
hold on
p7=semilogy(SNR,MSE_delta_fitz(1,:));
hold on
grid on
[hc,ht,hcl] = nice_plot(gcf); 
legend('CRVB','1-NM','16-NM','kay','LR','fitz')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')

% save('new_2_CRVB_delta.mat','CRVB_delta')
% % save('new_2_MSE_delta_NM_ideal.mat','MSE_delta_NM_ideal')
% save('new_2_MSE_delta_NM.mat','MSE_delta_NM')
% save('new_2_MSE_delta_kay.mat','MSE_delta_kay')
% save('new_2_MSE_delta_LR.mat','MSE_delta_LR')
% save('new_2_MSE_delta_fitz.mat','MSE_delta_fitz')

            
            