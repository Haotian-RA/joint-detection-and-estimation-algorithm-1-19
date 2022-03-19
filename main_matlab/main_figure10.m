clear 
clc
close all


% channel 
true_freq_offset=0.0005; 
true_phase_offset=2*pi*rand;
SNR=[-5:-1 -0.5:0.5:4 5:10];

% type of preamble you want to test
% L_0_set=[32 64 128 256];
L_0_set=[32];

% initialization
M=4;LL=1000;threshold=0.38;n_L_0=0;T=4;ts=0.01;v_set=[32];c_init=10;L=8;beta=0.5;
delta_NM=zeros(1,LL);phi_NM=zeros(1,LL);


MSE_delta_NM=zeros(length(L_0_set),length(SNR));
MSE_phi_NM=zeros(length(L_0_set),length(SNR));
CRVB_delta=zeros(length(L_0_set),length(SNR));
CRVB_phi=zeros(length(L_0_set),length(SNR));
n_zeros=250;n_pload=250;
pload=zeros(1,n_pload);
% tau=-T/M/2+T/M*rand;

for L_0=L_0_set
    
    n_L_0=n_L_0+1;
    tx = Gold_sequence(L_0,c_init,M,L,beta);
    m_tx = Gold_sequence(L_0,c_init,M,L,beta); % tau=[-Ts/2,Ts/2]

%     m_tx = Gold_sequence(L_0,c_init,M,L,beta,T,ts,tau); % tau=[-Ts/2,Ts/2]
    
    N=length(tx);
    tx_shift_register_AK = tx_register_AK(tx);
    sig = sig_generator(m_tx,true_freq_offset,true_phase_offset,pload,n_zeros);
    
    n_snr=0;
    for snr=SNR
        n_snr=n_snr+1;
        for count=1:LL
            rec = rx_generator(sig,snr);
            
            % initialization
            win=0;done=0;flag_rho=1;flag=0;reg_rho=0;reg_delta=0;reg_rx=zeros(1,length(tx));
            while done==0
                
                rx=rec(1,win+1:length(tx)+win);
                [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v_set);
                rho = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                
                [reg_rx,reg_delta,reg_rho,flag,flag_rho] = find_preamble(rho,rx,block_v_SD,threshold,flag_rho,flag,reg_rho,reg_rx,reg_delta);
                win=win+1;
                if flag==1 || win==length(rec)-N+1
                    if win~=(length(rec)-N+1)
                        block_v_SD=reg_delta;rx=reg_rx;
%                         disp(['preamble is detected at p= ',num2str(win-1)]);
                    end
                    rx_shift_register_AK = rx_register_AK(rx);
                    [delta_NM(1,count),phi_NM(1,count)] = NM_calculator(rx_shift_register_AK,tx_shift_register_AK,block_v_SD,tx,rx);
                    done=1;
                end
            end
        end
        MSE_delta_NM(n_L_0,n_snr)=M^2*sum((delta_NM-true_freq_offset).^2)/(LL-1);
        MSE_phi_NM(n_L_0,n_snr)=sum((phi_NM-true_phase_offset).^2)/(LL-1);
        CRVB_delta(n_L_0,n_snr)=3/(2*pi^2*L_0^3*db2mag(2*snr));
        CRVB_phi(n_L_0,n_snr)=2/(L_0*db2mag(2*snr));
    end
end

figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,MSE_delta_NM(1,:),'-<');
hold on
semilogy(SNR,CRVB_delta(2,:),'--')
hold on
p3=semilogy(SNR,MSE_delta_NM(2,:),'-o');
hold on
semilogy(SNR,CRVB_delta(3,:),'--')
hold on
p4=semilogy(SNR,MSE_delta_NM(3,:),'-*');
hold on
semilogy(SNR,CRVB_delta(4,:),'--')
hold on
p5=semilogy(SNR,MSE_delta_NM(4,:),'-s');
hold on
grid on
[hc1,ht1,hcl1] = nice_plot(gcf); 
legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')
title('\delta=0.0005')

figure(2)
p6=semilogy(SNR,CRVB_phi(1,:),'--');
hold on
p7=semilogy(SNR,MSE_phi_NM(1,:),'-<');
hold on
semilogy(SNR,CRVB_phi(2,:),'--')
hold on
p8=semilogy(SNR,MSE_phi_NM(2,:),'-o');
hold on
semilogy(SNR,CRVB_phi(3,:),'--')
hold on
p9=semilogy(SNR,MSE_phi_NM(3,:),'-*');
hold on
semilogy(SNR,CRVB_phi(4,:),'--')
hold on
p10=semilogy(SNR,MSE_phi_NM(4,:),'-s');
hold on
grid on
[hc,ht,hcl] = nice_plot(gcf);
legend([p6 p7 p8 p9 p10],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
ylabel('MSE(\phi)')
xlabel('E_s/N_0(dB)')
title('\delta=0.0005')
