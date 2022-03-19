clear 
clc
close all
% aliasing may affect the preprocessing. Set aliasing to be small enough to
% prevent alaising for this time.

% channel
normalized_true_freq_offset=-0.02; 
% normalized_true_freq_offset=mod(normalized_true_freq_offset,1/85);
true_phase_offset=2*pi*rand;
% SNR=[-10:-6 -5:2:-1 0:2:4 5 6 7 8 10 15];
% SNR=[-10:-6 -5:2:-1 0:2:4 5];
SNR=[-10:15];
    
% simulation initialization
L_0_set=[32];
M=1;LL=1000; 
n_L_0=0;  
L=8;beta=0.5;c_init=10;v_set=[1 4 16];

CRVB_delta=zeros(length(L_0_set),length(SNR));
block_v_SD=zeros(length(v_set),LL);
MSE_block_v_SD=zeros(length(L_0_set),length(SNR));
impro_NM=zeros(length(v_set),LL);
MSE_impro_NM=zeros(length(L_0_set),length(SNR));

for L_0=L_0_set
    n_L_0=n_L_0+1;
    
    [tx,~] = Gold_sequence(L_0,c_init);

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
%                 [impro_NM(n_P,count),~] = NM_calculator(rx_shift_register_AK,...
%                     tx_shift_register_AK,block_v_SD(n_P,count),tx,rx);
                
            end
        end
        for c=1:length(v_set)
%             MSE_impro_NM(c,n_snr) = M^2*sum((impro_NM(c,:)-normalized_true_freq_offset).^2)/(LL-1);
            MSE_block_v_SD(c,n_snr) = M^2*sum((block_v_SD(c,:)-normalized_true_freq_offset).^2)/(LL-1);
        end

        CRVB_delta(1,n_snr) = 3/(2*pi^2*L_0^3*db2mag(2*snr));
    end
    
end

[Bound_SD] = bound_SD(N,SNR,M);
figure(1)
p1=semilogy(SNR,CRVB_delta(1,:));
hold on
p2=semilogy(SNR,Bound_SD(1,:),'--');
hold on
p3=semilogy(SNR,MSE_block_v_SD(1,:),'-.o');
hold on
p4=semilogy(SNR,MSE_block_v_SD(2,:),'-.d');
hold on
p5=semilogy(SNR,MSE_block_v_SD(3,:),'-.s');
hold on
grid on
[hc1,ht1,hcl1] = nice_plot(gcf); 
legend('CRVB','SD bound','impro_{SD1}','impro_{SD4}','impro_{SD16}')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')

% MSE_block_v_SD_0001=MSE_block_v_SD;
% save('new_1_CRVB_delta.mat','CRVB_delta')
% save('new_1_MSE_block_v_SD_0001.mat','MSE_block_v_SD_0001')
% save('new_1_Bound_SD.mat','Bound_SD')
% 

% figure(2)
% p21=semilogy(SNR,CRVB_delta(1,:),'--');
% hold on
% p22=semilogy(SNR,MSE_impro_NM(1,:),'-o');
% hold on
% p23=semilogy(SNR,MSE_impro_NM(2,:),'-d');
% hold on
% p24=semilogy(SNR,MSE_impro_NM(3,:),'-s');
% hold on
% [hc2,ht2,hcl2] = nice_plot(gcf); 
% grid on
% legend('CRVB','impro_{NM1}','impro_{NM4}','impro_{NM16}') 
% ylabel('MSE(M\delta)')
% xlabel('E_s/N_0(dB)')
% 
% % save('CRVB_delta.mat','CRVB_delta')
% % save('MSE_delta_SD.mat','MSE_delta_SD')
% % save('MSE_delta_NM.mat','MSE_delta_NM')
% % save('MSE_delta_3NM.mat','MSE_delta_3NM')
% % save('Bound_SD.mat','Bound_SD')
% 
% % save('CRVB_delta.mat','CRVB_delta')
% % save('MSE_delta_kay.mat','MSE_delta_kay')
% % save('MSE_delta_LR.mat','MSE_delta_LR')
% % save('MSE_delta_fitz.mat','MSE_delta_fitz')
% % save('MSE_delta_3NM.mat','MSE_delta_3NM')