clear
clc
close all

% channel 
% M=4;
M=1;
normalized_true_freq_offset=0.01/M; % \delta*T_s
normalized_true_phase_offset=2*pi*rand;
SNR=0;

threshold=0:0.02:1;
L_0_set=32;
n_L_0=0;
LL=1;v_set=[1];
L=8;beta=0.5;c_init=10;n_zeros=250;n_pload=250;
pload=zeros(1,n_pload);rho_container=zeros(length(v_set),n_zeros+n_pload);

for L_0=L_0_set
    % prepare sig
    n_L_0=n_L_0+1;
    
%     [tx,~] = Gold_sequence(L_0,c_init,M,L,beta);
    [tx,~] = Gold_sequence(L_0,c_init);

    N=length(tx);
    sig = sig_generator(tx,normalized_true_freq_offset,normalized_true_phase_offset,pload,n_zeros);
    
    n_snr=0;detection_board=zeros(length(threshold),length(sig)-N+1);
    for snr=SNR
        
        n_snr=n_snr+1;
        for count=1:LL
            % generate rec for different trials and certain SNR.
            rec = rx_generator(sig,snr);
            
            for win=0:length(rec)-N
                % obtain function of detector versus index of rec
                rx=rec(1,win+1:N+win);
                
                n_P=0;
                for v=v_set
                    n_P=n_P+1;
                    
                    [block_v_SD,phasor_v_SD] = Block_v_SD_calculator(rx,tx,v);
                    rho = rho_calculator(tx,rx,block_v_SD,phasor_v_SD);
                    rho_container(n_P,win+1)=rho;
                end
            end
        end
    end
end

txt = '\leftarrow $\bar{p}$=251';

figure(4)
plot(rho_container(1,:))
hold on
% plot(rho_container(2,:),'--')
% hold on
plot(n_zeros+1-M:n_zeros+1+M,rho_container(1,n_zeros+1-M:n_zeros+1+M),'o')
hold on
plot([n_zeros+1 n_zeros+1],[0 rho_container(1,n_zeros+1)],'--');
[hc,ht,hcl] = nice_plot(gcf);
text(251,0.15,'\leftarrow','Fontsize',12)
text(272,0.15,'$$\bar{p}=251$$', 'Interpreter', 'LaTeX','Fontsize',12)
xlabel('p')
ylabel('\rho(p)')
grid on
legend('v=1,0dB','v=32,0dB')
xlim([0 500])

[p1,v1]=max(rho_container(1,:))
% [p2,v2]=max(rho_container(2,:))
rho_container_1=rho_container(1,:);

sum(tx.*conj(tx))
save('new_3_rho_container_1.mat','rho_container_1')
