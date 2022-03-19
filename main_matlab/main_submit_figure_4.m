clear
clc
close all
% an important m-file. test for the detection algorithm.

% channel 
normalized_true_freq_offset=0.01; 
normalized_true_phase_offset=2*pi*rand;
% SNR=[-5 -4 -2 0];
SNR=[-4];

threshold=0:0.02:1;

L_0_set=[64];
n_L_0=0;
LL=5000;

v_set=[16 32];L=8;beta=0.5;c_init=10;M=1;

n_zeros=L_0_set*M;
n_pload=L_0_set*M;

pload=zeros(1,n_pload);rho_container=zeros(length(v_set),n_zeros+n_pload);

% simulation result vector initialization
P_d=zeros(length(threshold),length(SNR),length(v_set));
P_fa=zeros(length(threshold),length(SNR),length(v_set));

[tx,~] = Gold_sequence(L_0_set,c_init);
N=length(tx);
sig = sig_generator(tx,normalized_true_freq_offset,normalized_true_phase_offset,pload,n_zeros);

n_v=0;
for v=v_set
    n_v=n_v+1;
    n_thres=0;
    for thres=threshold
        n_thres=n_thres+1;    
        n_snr=0;
        for snr=SNR
            n_snr=n_snr+1;
            n_d=0;n_fa=0;
            for count=1:LL
                % generate rec for different trials and certain SNR.
                rec = rx_generator(sig,snr);

                win=0;done=0;flag_rho=1;flag=0;reg_rho=0;reg_delta=0;reg_rx=zeros(1,length(tx));
                while done==0

                    rx=rec(1,win+1:N+win);
                    [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v);
                    rho = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                    [reg_rx,reg_delta,reg_rho,flag,flag_rho] = find_preamble(rho,rx,block_v_SD,thres,flag_rho,flag,reg_rho,reg_rx,reg_delta);
                    win=win+1;

                    if flag==1 || win==length(rec)-N+1
                        if win-1==M*L_0_set+1
                            n_d=n_d+1;
                        elseif win~=(length(rec)-N+1)
                            n_fa=n_fa+1;
                            
                            rx=rec(1,M*L_0_set+1:M*L_0_set+N);
                            [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v);
                            rho = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                            if rho>=thres
                                n_d=n_d+1;
                            end 
                        end
%                         win_container(1,count)=win-1;
                        done=1;
                    end
                end
            end
            P_d(n_thres,n_snr,n_v)=n_d/LL; % (threshold,snr,v)
            P_fa(n_thres,n_snr,n_v)=n_fa/LL;
        end
    end
end

% for n_v=1:length(v_set)
%     for n_s=1:length(SNR)
%         N_aa1(n_v,n_s)=sum(win_container(n_v,:,n_s)==256)
%                 N_aa2(n_v,n_s)=sum(win_container(n_v,:,n_s)==257)
% 
%                         N_aa3(n_v,n_s)=sum(win_container(n_v,:,n_s)==258)
%         N_aa4(n_v,n_s)=sum(win_container(n_v,:,n_s)==512)
% 
%     end
% end

% figure(1)
% semilogy(threshold,P_fa(:,1,1))
% hold on
% semilogy(threshold,P_d(:,1,1),'--')
% hold on
% semilogy(threshold,P_fa(:,2,1))
% hold on
% semilogy(threshold,P_d(:,2,1),'--')
% hold on
% semilogy(threshold,P_fa(:,3,1))
% hold on
% semilogy(threshold,P_d(:,3,1),'--')
% hold on
% semilogy(threshold,P_fa(:,1,2))
% hold on
% semilogy(threshold,P_d(:,1,2),'--')
% hold on
% semilogy(threshold,P_fa(:,2,2))
% hold on
% semilogy(threshold,P_d(:,2,2),'--')
% hold on
% semilogy(threshold,P_fa(:,3,2))
% hold on
% semilogy(threshold,P_d(:,3,2),'--')
% hold on
% [hc,ht,hcl] = nice_plot(gcf);
% xlabel('\gamma')
% ylabel('P_{FA},P_{d}')
% legend('-5dB,v=1,p_{fa}','-5dB,v=1,p_{d}',...
%     '-2dB,v=1,p_{fa}','-2dB,v=1,p_{d}',...
%     '0dB,v=1,p_{fa}','0dB,v=1,p_{d}',...
%     '-5dB,v=16,p_{fa}','-5dB,v=16,p_{d}',...
%     '-2dB,v=16,p_{fa}','-2dB,v=16,p_{d}',...
%     '0dB,v=16,p_{fa}','0dB,v=16,p_{d}',...
%     'Location','southeast')
% title('\delta=0.01,L_0=32,M=1')
% 
% 
% figure(3)
% semilogx(P_fa(:,1,1),P_d(:,1,1))
% hold on
% semilogx(P_fa(:,2,1),P_d(:,2,1))
% hold on
% semilogx(P_fa(:,3,1),P_d(:,3,1))
% hold on
% semilogx(P_fa(:,1,2),P_d(:,1,2),'--')
% hold on
% semilogx(P_fa(:,2,2),P_d(:,2,2),'--')
% hold on
% semilogx(P_fa(:,3,2),P_d(:,3,2),'--')
% hold on
% [hc1,ht1,hcl1] = nice_plot(gcf);
% xlabel('p_{fa}')
% ylabel('p_{d}')
% legend('-5dB,v=1','-2dB,v=1',...
%     '0dB,v=1',...
%     '-5dB,v=16','-2dB,v=16',...
%     '0dB,v=16',...
%     'Location','southeast')
% title('\delta=0.01,L_0=32,M=1')
% 
P_fa_64=P_fa;
P_d_64=P_d;

save('new_4_P_fa_64.mat','P_fa_64')
save('new_4_P_d_64.mat','P_d_64')



