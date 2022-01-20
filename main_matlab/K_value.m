function K = K_value(N,delta_m)
% N: length of preamble
% delta_m: pre-assumed max delta.

if 1/(2*delta_m)>floor(2*N/3)
    K=floor(2*N/3);
else
    K=ceil(1/(2*delta_m)-1);
end