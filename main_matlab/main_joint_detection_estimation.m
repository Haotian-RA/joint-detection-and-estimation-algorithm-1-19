clear 
clc
close all


% channel 
true_freq_offset=0.0025/4; 
true_phase_offset=2*pi*rand;
SNR=[0:0.5:4 5:10];

% type of preamble you want to test
L_0_set=[32 64 128 256];

% initialization
M=4;LL=1000;threshold=0.43;n_L_0=0;
delta_NM=zeros(1,LL);phi_NM=zeros(1,LL);


MSE_delta_NM=zeros(length(L_0_set),length(SNR));
MSE_phi_NM=zeros(length(L_0_set),length(SNR));
CRVB_delta=zeros(length(L_0_set),length(SNR));
CRVB_phi=zeros(length(L_0_set),length(SNR));
pload=zeros(1,50);

for L_0=L_0_set
    n_L_0=n_L_0+1;
    [tx] = sample_loader(L_0);
    N=length(tx);
    K = K_value(N,true_freq_offset);
    tx_shift_register = tx_register_SK(K,tx);
    tx_shift_register_AK = tx_register_AK(tx);
    sig = sig_generator(tx,true_freq_offset,true_phase_offset,pload,50);
    n_snr=0;
    for snr=SNR
        n_snr=n_snr+1;
        for count=1:LL
            rec = rx_generator(sig,snr);
            
            % initialization
            win=0;done=0;flag_rho=1;flag=0;rx_shift_register=zeros(1,N-K);reg_rho=0;reg_delta=0;reg_rx=zeros(1,length(tx));
            while done==0
                rx=rec(1,win+1:length(tx)+win);
                rx_shift_register = rx_register_SK(K,rx,win,rx_shift_register);
                [delta_SD,phasor_SD] = SD_calculator(tx_shift_register,rx_shift_register,K,rx,tx);
                rho = rho_calculator(tx,rx,delta_SD,phasor_SD);
                [reg_rx,reg_delta,reg_rho,flag,flag_rho] = find_preamble(rho,rx,delta_SD,threshold,flag_rho,flag,reg_rho,reg_rx,reg_delta);
                win=win+1;
                if flag==1 || win==length(rec)-N+1
                    if win~=(length(rec)-N+1)
                        delta_SD=reg_delta;rx=reg_rx;
%                         disp(['preamble is detected at p= ',num2str(win-1)]);
                    end
                    rx_shift_register_AK = rx_register_AK(rx);
                    [delta_NM(1,count),phi_NM(1,count)] = NM_calculator(rx_shift_register_AK,tx_shift_register_AK,delta_SD,tx,rx);
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
% legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
% [hc,ht,hcl] = nice_plot(gcf); %#ok<ASGLU>
% legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
% ylabel('MSE(M\delta)')
% xlabel('E_s/N_0(dB)')
% 
% figure(2)
% p1=semilogy(SNR,CRVB_phi(1,:),'--');
% hold on
% p2=semilogy(SNR,MSE_phi_NM(1,:),'-<');
% hold on
% semilogy(SNR,CRVB_phi(2,:),'--')
% hold on
% p3=semilogy(SNR,MSE_phi_NM(2,:),'-o');
% hold on
% semilogy(SNR,CRVB_phi(3,:),'--')
% hold on
% p4=semilogy(SNR,MSE_phi_NM(3,:),'-*');
% hold on
% semilogy(SNR,CRVB_phi(4,:),'--')
% hold on
% p5=semilogy(SNR,MSE_phi_NM(4,:),'-s');
% hold on
% grid on
% % legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
% [hc,ht,hcl] = nice_plot(gcf);
% legend([p1 p2 p3 p4 p5],{'CRVB','L_0=32','L_0=64','L_0=128','L_0=256'})
% ylabel('MSE(\phi)')
% xlabel('E_s/N_0(dB)')

save('MSE_phi_NM.mat','MSE_phi_NM')
save('MSE_delta_NM.mat','MSE_delta_NM')
save('CRVB_delta.mat','CRVB_delta')
save('CRVB_phi.mat','CRVB_phi')