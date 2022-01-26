clear
clc
close all
load('P_fa_32.mat')
load('P_fa_64.mat')
load('P_d_32.mat')
load('P_d_64.mat')
load('P_fa_128.mat')
load('P_d_128.mat')
load('P_fa_32_f.mat')
load('P_fa_64_f.mat')
load('P_d_32_f.mat')
load('P_d_64_f.mat')

threshold=0:0.02:1;

P_fa_32_f(P_fa_32_f<1e-3)=0;
P_fa_32(P_fa_32<1e-3)=0;

P_fa_32_f(22:23,1)=0;
P_fa_32_f(42,2)=0;
P_d_32(32,3)=0;

hold on
yyaxis left

semilogy(threshold,P_fa_32_f(:,1),'-d')
semilogy(threshold,P_fa_32(:,3),'-o')
semilogy(threshold,P_fa_32_f(:,2),'-<')
semilogy(threshold,P_fa_32(:,5),'-h')

set(gca,'yscale','log')

[hc4,ht4,hcl4] = nice_plot(gcf);
ylabel('P_{FA}')

yyaxis right

semilogy(threshold,P_d_32_f(:,1),'--d')
semilogy(threshold,P_d_32(:,3),'--o')
semilogy(threshold,P_d_32_f(:,2),'--<')
semilogy(threshold,P_d_32(:,5),'--h')

grid on
set(gca,'yscale','log')

plot([0.43 0.43],[1e-3 1],'--k');
txt = '\leftarrow \gamma = 0.43';

% hold on
[hc5,ht5,hcl5] = nice_plot(gcf);
text(0.43,1.5e-2,txt,'Fontsize',10)

xlabel('\gamma')
ylabel('P_{D}')

legend('L_0=32, SNR=0dB, with \Deltap',...
    'L_0=32, M=0dB, no \Deltap',...
    'L_0=32, SNR=10dB, with \Deltap',...
    'L_0=32, M=10dB, no \Deltap','location','southeast')

hold off