function [N_fa,N_D] = false_alarm_probability_fractional_delay(detection_board,p_preamble,M,N_win,rho_container,threshold)

[L_th,n_win]=size(detection_board);
fa_board=zeros(L_th,n_win);
N_D=zeros(L_th,1);
N_D1=zeros(L_th,1);
N_fa=zeros(L_th,1);
[value,pos]=max(rho_container);
flag_D=0;
if pos==p_preamble
    flag_D=1;
end

for k=1:L_th
    fa=0;
    for m=1:n_win
        if flag_D==1
            if value>=threshold(1,k)
                N_D(k,1)=1;
            end
        end
        if detection_board(k,p_preamble)==1
            N_D1(k,1)=1;
        end
        if detection_board(k,m)==1 && fa<2*M-2
            fa=fa+1;
        else
            fa=0;
        end
        if fa==1
            fa_board(k,m)=fa;
        end
    end
end
% disp(fa_board)
for k=1:L_th
    N_fa(k,1)=sum(fa_board(k,:))-N_D1(k,1);
    if N_fa(k,1)>ceil(N_win/(2*M-1))-1
        N_fa(k,1)=ceil(N_win/(2*M-1))-1;
    end
end  

            









