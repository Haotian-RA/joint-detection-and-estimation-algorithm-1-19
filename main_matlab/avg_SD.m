function [avg_kSD] = avg_SD(K,N,M,delta_SD)
% automatically generate 3-cases SD estimator
% dumby but efficient for plotting comparison of different SD

if length(delta_SD)==3
    w_weight1=1/(K^2*(N-K)*(K+M)^2*(N-K-M));
    w_weight2=1/((K-M)^2*(N-K+M)*(K+M)^2*(N-K-M));
    w_weight3=1/(K^2*(N-K)*(K-M)^2*(N-K+M));
    w_weight=w_weight1+w_weight2+w_weight3;
    w_set2=1/w_weight*[w_weight1 w_weight2 w_weight3];
    avg_kSD = w_set2*delta_SD'; % 3-avg SD
end

if length(delta_SD)==5
    w_weight1=1/(K^2*(N-K)*(K+M)^2*(N-K-M)*(K-M)^2*(N-K+M)*(K+2*M)^2*(N-K-2*M));
    w_weight2=1/(K^2*(N-K)*(K+M)^2*(N-K-M)*(K-2*M)^2*(N-K+2*M)*(K+2*M)^2*(N-K-2*M));
    w_weight3=1/((K-2*M)^2*(N-K+2*M)*(K+M)^2*(N-K-M)*(K-M)^2*(N-K+M)*(K+2*M)^2*(N-K-2*M));
    w_weight4=1/(K^2*(N-K)*(K-2*M)^2*(N-K+2*M)*(K-M)^2*(N-K+M)*(K+2*M)^2*(N-K-2*M));
    w_weight5=1/(K^2*(N-K)*(K+M)^2*(N-K-M)*(K-M)^2*(N-K+M)*(K-2*M)^2*(N-K+2*M));
    w_weight=w_weight1+w_weight2+w_weight3+w_weight4+w_weight5;
    w_set3=1/w_weight*[w_weight1 w_weight2 w_weight3 w_weight4 w_weight5];
    avg_kSD = w_set3*delta_SD'; % 5-avg SD
end