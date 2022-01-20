function [tx] = sample_loader(L_0)
% load sample based on various length of preamble

if L_0==32
    load('tx32_4M.mat')
%     load('o_tx32_4M.mat')
%     o_tx=o_tx32_4M;
    tx=tx32_4M;
elseif L_0==64
    load('tx64_4M.mat')
%     load('o_tx64_4M.mat')
%     o_tx=o_tx64_4M;
    tx=tx64_4M;
elseif L_0==128
    load('tx128_4M.mat')
%     load('o_tx128_4M.mat')
%     o_tx=o_tx128_4M;
    tx=tx128_4M;
else
    load('tx256_4M.mat')
%     load('o_tx256_4M.mat')
%     o_tx=o_tx256_4M;
    tx=tx256_4M;
end