clear
clc
close all

% channel
normalized_true_freq_offset=0.001;  
true_phase_offset=2*pi*rand;
SNR=[-10:1:10];

% simulation initialization
L_0_set=[32];
M_set=[1 2 4 8];LL=500; 
n_M=0;  
L=8;beta=0.5;c_init=10;
v_set=[16];T=4;ts=0.01;

CRVB_delta=zeros(length(L_0_set),length(SNR));
delta_NM=zeros(1,LL);
MSE_delta_NM=zeros(length(M_set),length(SNR));

for M=M_set
    n_M=n_M+1;
    
    tx = Gold_sequence(L_0_set,c_init,M,L,beta);
    m_tx = Gold_sequence(L_0_set,c_init,M,L,beta,T,ts,T/M/2);
    
    N=length(tx);
    tx_shift_register_AK = tx_register_AK(tx);
    sig = sig_generator(m_tx,normalized_true_freq_offset,true_phase_offset);
    
    n_snr=0; % # of L_0_set (for counting) 
    for snr=SNR
        n_snr=n_snr+1;

        for count=1:LL
            rx = rx_generator(sig,snr);
            rx_shift_register_AK = rx_register_AK(rx);

           

            [block_v_SD,~]= Block_v_SD_calculator(rx,tx,v_set);
            [delta_NM(1,count),~] = NM_calculator(rx_shift_register_AK,...
                tx_shift_register_AK,block_v_SD,tx,rx);

        end
        MSE_delta_NM(n_M,n_snr) = M^2*sum((delta_NM-normalized_true_freq_offset).^2)/(LL-1);
        CRVB_delta(1,n_snr) = 3/(2*pi^2*L_0_set^3*db2mag(2*snr));
    end
end

figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,MSE_delta_NM(1,:),'-s');
hold on
p3=semilogy(SNR,MSE_delta_NM(2,:),'-<');
hold on
p4=semilogy(SNR,MSE_delta_NM(3,:),'-d');
hold on
p5=semilogy(SNR,MSE_delta_NM(4,:),'-h');
hold on
[hc,ht,hcl] = nice_plot(gcf); 
legend('CRVB','M=1,v=16','M=2,v=16','M=4,v=16','M=8,v=16')
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')