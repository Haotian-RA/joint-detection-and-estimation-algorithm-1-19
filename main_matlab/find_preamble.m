function [reg_rx,reg_delta,reg_rho,flag,flag_rho] = find_preamble(rho,rx,delta_SD,threshold,flag_rho,flag,reg_rho,reg_rx,reg_delta)

if rho>=threshold
    if flag_rho==1
        reg_rho=rho;
        flag_rho=2;
        reg_rx=rx;
        reg_delta=delta_SD;
    end
end

if flag_rho==2
    if rho>=reg_rho
        reg_rho=rho;
        reg_rx=rx;
        reg_delta=delta_SD;
    else 
        reg_rho=0;
        flag=1;
    end
end
