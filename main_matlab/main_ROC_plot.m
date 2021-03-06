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

P_fa_32(P_fa_32<1e-3)=0;
P_fa_64(P_fa_64<1e-3)=0;
P_fa_128(P_fa_128<1e-3)=0;
P_d_32(32,3)=0;

hold on
yyaxis left

% figure(1)
% semilogy(threshold,P_fa_32(:,1),'-o')
% hold on
% semilogy(threshold,P_fa_32(:,2),'-s')
% hold on
semilogy(threshold,P_fa_32(:,3),'-d')
% hold on
semilogy(threshold,P_fa_32(:,4),'-<')
% hold on
semilogy(threshold,P_fa_32(:,5),'-*')
% hold on
% semilogy(threshold,P_fa_64(:,1),'--o')
% hold on
% semilogy(threshold,P_fa_64(:,2),'--s')
% hold on
% semilogy(threshold,P_fa_64(:,3),'--d')
% hold on


semilogy(threshold,P_fa_64(:,4),'-o')
% hold on
% semilogy(threshold,P_fa_64(:,5),'-h')
set(gca,'yscale','log')

% grid on
% yyaxis left
[hc1,ht1,hcl1] = nice_plot(gcf);
ylabel('P_{FA}')
% xlabel('\gamma')
% legend('L_0=32,SNR=-5dB',...
%     'L_0=32,SNR=-2dB',...
%     'L_0=32,SNR=0dB',...
%     'L_0=32,SNR=5dB',...
%     'L_0=32,SNR=10dB',...
%     'L_0=64,SNR=-5dB',...
%     'L_0=64,SNR=-2dB',...
%     'L_0=64,SNR=0dB',...
%     'L_0=64,SNR=5dB',...
%     'L_0=64,SNR=10dB')
% legend('L=32, 0dB SNR',...
%     'L=32, 5dB SNR',...
%     'L=32, 10dB SNR',...
%     'L=64, 5dB SNR',...
%     'L=64, 10dB SNR')

% figure(2)
% semilogy(threshold,P_d_32(:,1),'-o')
% hold on
% semilogy(threshold,P_d_32(:,2),'-s')
% hold on



yyaxis right

semilogy(threshold,P_d_32(:,3),'--d')
% hold on
semilogy(threshold,P_d_32(:,4),'--<')
% hold on
semilogy(threshold,P_d_32(:,5),'--*')
% hold on
% semilogy(threshold,P_d_64(:,1),'--o')
% hold on
% semilogy(threshold,P_d_64(:,2),'--s')
% hold on
% semilogy(threshold,P_d_64(:,3),'--d')
% hold on
semilogy(threshold,P_d_64(:,4),'--o')
% hold on
% semilogy(threshold,P_d_64(:,5),'--h')
grid on
set(gca,'yscale','log')

plot([0.43 0.43],[1e-3 1],'--k');
txt = '\leftarrow \gamma = 0.43';

% hold on
[hc2,ht2,hcl2] = nice_plot(gcf);
text(0.43,4e-3,txt,'Fontsize',10)

% yyaxis right
xlabel('\gamma')
ylabel('P_{D}')

% legend('L_0=32, 0dB SNR',...
%     'L_0=32, 5dB SNR',...
%     'L_0=32, 10dB SNR',...
%     'L_0=64, 5dB SNR',...
%     'L_0=64, 10dB SNR','location','southeast')
legend('L_0=32, 0dB SNR',...
    'L_0=32, 5dB SNR',...
    'L_0=32, 10dB SNR',...
    'L_0=64, 5dB SNR','location','southeast')

hold off






txt = '\leftarrow \gamma = 0.28';

figure(3)
semilogx([1e-3 1],[1e-3 1],'--')
hold on
% semilogx(P_fa_32(:,1),P_d_32(:,1),'-h')
% hold on
semilogx(P_fa_32(:,2),P_d_32(:,2),'-s')
hold on
semilogx(P_fa_32(:,3),P_d_32(:,3),'-d')
hold on
% semilogx(P_fa_32(:,4),P_d_32(:,4),'-<')
% hold on
% loglog(P_fa_32(:,5),P_d_32(:,5),'-*')
% hold on
semilogx(P_fa_64(:,1),P_d_64(:,1),'-*')
hold on
semilogx(P_fa_64(:,2),P_d_64(:,2),'-o')
hold on
semilogx(P_fa_128(:,1),P_d_128(:,1),'-h')
hold on
semilogx(P_fa_128(:,2),P_d_128(:,2),'-<')
% hold on
% semilogx(P_fa_32(15,3),P_d_32(15,3),'rs','MarkerSize',20)
% semilogx(P_fa_64(:,3),P_d_64(:,3),'-h')
% hold on
grid on
% loglog(P_fa_64(:,4),P_d_64(:,4),'--<')
% hold on
% loglog(P_fa_64(:,5),P_d_64(:,5),'--*')
% hold on
[hc3,ht3,hcl3] = nice_plot(gcf);
hold on
semilogx(P_fa_32(15,3),P_d_32(15,3),'rs','MarkerSize',20,'lineWidth',2)
text(P_fa_32(15,3),P_d_32(15,3),txt,'Fontsize',10)
xlabel('p_{FA}')
ylabel('p_{D}')
% legend('L_0=32,SNR=-5dB',...
%     'L_0=32,SNR=-2dB',...
%     'L_0=32,SNR=0dB',...
%     'L_0=32,SNR=5dB',...
%     'L_0=32,SNR=10dB',...
%     'L_0=64,SNR=-5dB',...
%     'L_0=64,SNR=-2dB',...
%     'L_0=64,SNR=0dB',...
%     'L_0=64,SNR=5dB',...
%     'L_0=64,SNR=10dB')
legend('random classifier',...
    'L_0=32, -2dB SNR',...
    'L_0=32, 0dB SNR',...
    'L_0=64, -5dB SNR',...
    'L_0=64, -2dB SNR',...
    'L_0=128, -8dB SNR',...
    'L_0=128, -5dB SNR','location','southeast')




