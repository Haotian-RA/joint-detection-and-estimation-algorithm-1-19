clear
clc
close all

load('new_3_rho_container.mat')
load('new_3_rho_container_1.mat')

n_zeros=250;n_pload=250;
M=4;
figure(4)
p1=plot(rho_container(1,:),'-');
hold on
plot(n_zeros-1:n_zeros+3,rho_container(1,n_zeros-1:n_zeros+3),'x','Color','[0, 0.4470, 0.7410]')
hold on
p2=plot([n_zeros+1 n_zeros+1],[0 rho_container(1,n_zeros+1)],'--r');
[hc,ht,hcl] = nice_plot(gcf);
text(252,0.013,'$p{=}251$','Interpreter','latex','Fontsize',9.5);
% text(272,0.15,'$$\bar{p}=251$$', 'Interpreter', 'LaTeX','Fontsize',12)
% xlab=xlabel('p+\Delta');
xlab=xlabel('Start position of received signal ($\tilde{p}$)', 'Interpreter', 'LaTeX');
ylab=ylabel('$\rho$($\tilde{p}$)', 'Interpreter', 'LaTeX');
set(xlab,'FontSize',12);
set(ylab,'FontSize',12);
grid on
lgnd=legend([p1 p2],{['with pulse shaping, $M{=}4$,' newline '$E_s/N_0{=}0$ dB, $L_0{=}32$,' newline '$M\delta{=}0.01$, $\hat{\delta}_{SL}^{(1)}$ is applied'],
    'position of the preamble'},'Interpreter','latex');
% xlim([125 375])
xlim([175 325])
set(lgnd,'FontSize',9.5);




ylim([0 0.52])
