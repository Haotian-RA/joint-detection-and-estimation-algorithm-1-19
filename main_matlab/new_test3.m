clear 
clc
close all

% look at 0.56 -2dB

% channel 
true_freq_offset=0.001; 
true_phase_offset=2*pi*rand;
% SNR=[-5:0.5:1 1.5:3.5 4];
% SNR=[-2 -1];
SNR=[-3 -2 -1 0 2 5];

% type of preamble you want to test
% L_0_set=[32 64 128 256];
L_0_set=[32];

% initialization
M=1;
% M=2;
LL=2000;
threshold=0.56;
% threshold=0.43;
% threshold=0.51;
n_L_0=0;T=1;ts=0.01;
% v_set=[1 16];
v_set=[1];
c_init=10;L=8;beta=0.5;
delta_NM=zeros(1,LL);phi_NM=zeros(1,LL);


MSE_delta_NM=zeros(length(v_set),length(SNR));
MSE_phi_NM=zeros(length(v_set),length(SNR));
CRVB_delta=zeros(length(v_set),length(SNR));
CRVB_phi=zeros(length(v_set),length(SNR));
n_zeros=L_0_set*2;
n_pload=L_0_set*2;

% n_zeros=L_0_set;n_pload=L_0_set;
% n_zeros=0;n_pload=0;
pload=zeros(1,n_pload);rho_container=zeros(length(v_set),n_zeros+n_pload);
% tau=-T/M/2+T/M*rand;
n_v=0;

tx = Gold_sequence(L_0_set,c_init);    
% [tx,~] = Gold_sequence(L_0_set,c_init,M,L,beta);
N=length(tx);
tx_shift_register_AK = tx_register_AK(tx);
sig = sig_generator(tx,true_freq_offset,true_phase_offset,pload,n_zeros);
win_container=zeros(length(v_set),LL,length(SNR));

for v=v_set
    n_v=n_v+1;
    
    n_snr=0;
    for snr=SNR
        
        n_snr=n_snr+1;
        for count=1:LL
            rec = rx_generator(sig,snr);
            
            % initialization
            win=0;done=0;flag_rho=1;flag=0;reg_rho=0;reg_delta=0;reg_rx=zeros(1,length(tx));
            while done==0
                
                rx=rec(1,win+1:length(tx)+win);
                block_v_SD=true_freq_offset;
                phasor_v_SD=exp(1i*true_phase_offset);
%                 [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v);
                rho = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                
                [reg_rx,reg_delta,reg_rho,flag,flag_rho] = find_preamble(rho,rx,block_v_SD,threshold,flag_rho,flag,reg_rho,reg_rx,reg_delta);
                win=win+1;
                if flag==1 || win==length(rec)-N+1
                    if win~=(length(rec)-N+1)
                        block_v_SD=reg_delta;rx=reg_rx;
%                         disp(['preamble is detected at p= ',num2str(win-1)]);
                    end
                    win_container(n_v,count,n_snr)=win-1;
                    rx_shift_register_AK = rx_register_AK(rx);
                    [delta_NM(1,count),phi_NM(1,count)] = NM_calculator(rx_shift_register_AK,tx_shift_register_AK,block_v_SD,tx,rx);
                    done=1;
                end
            end
        end
        MSE_delta_NM(n_v,n_snr)=M^2*sum((delta_NM-true_freq_offset).^2)/(LL-1);
        MSE_phi_NM(n_v,n_snr)=sum((phi_NM-true_phase_offset).^2)/(LL-1);
        CRVB_delta(n_v,n_snr)=3/(2*pi^2*L_0_set^3*db2mag(2*snr));
        CRVB_phi(n_v,n_snr)=2/(L_0_set*db2mag(2*snr));
    end
end

figure(1)
p1=semilogy(SNR,CRVB_delta(1,:),'--');
hold on
p2=semilogy(SNR,MSE_delta_NM(1,:),'-<');
hold on
% p3=semilogy(SNR,MSE_delta_NM(2,:),'-o');
% hold on
grid on
[hc1,ht1,hcl1] = nice_plot(gcf); 
% legend([p1 p2 p3],{'CRVB','L_0=32,v=1',...
%     'L_0=32,v=16'})
% legend([p1 p2 p3],{'CRVB','L_0=32,ideal'})
legend([p1 p2],{'CRVB','L_0=32,ideal'})
ylabel('MSE(M\delta)')
xlabel('E_s/N_0(dB)')
title('\delta=0.001')

figure(2)
p6=semilogy(SNR,CRVB_phi(1,:),'--');
hold on
p7=semilogy(SNR,MSE_phi_NM(1,:),'-<');
hold on
% p8=semilogy(SNR,MSE_phi_NM(2,:),'-o');
% hold on
grid on
[hc,ht,hcl] = nice_plot(gcf);
% legend([p6 p7 p8],{'CRVB','L_0=32,ideal'})
legend([p6 p7],{'CRVB','L_0=32,ideal'})
ylabel('MSE(\phi)')
xlabel('E_s/N_0(dB)')
title('\delta=0.001')

% win_container=zeros(length(v_set),LL,length(SNR));
for n_v=1:length(v_set)
    for n_s=1:length(SNR)
        N_d(n_v,n_s)=sum(win_container(n_v,:,n_s)==65);
    end
end
N_d