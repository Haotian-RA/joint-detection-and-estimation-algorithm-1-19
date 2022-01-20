function ps=srrc(L,beta,M,t_off)
% Generate a Square-Root Raised Cosine Pulse
%      'L' is 1/2 the length of srrc pulse in symbol durations
%      'beta' is the rolloff factor: beta=0 gives the sinc function
%      'T' is the symbol period (unit: second)
%      't_off' is the phase (or timing) offset
%      'ts' is the sample interval (unit: second)

if nargin==3, t_off=0; end;                       % if unspecified, offset is 0
k=-L*M+1e-8+t_off:L*M+1e-8+t_off;           
if (beta==0), beta=1e-8; end;                     % numerical problems if beta=0
ps=4*beta/sqrt(M)*(cos((1+beta)*pi*k/M)+...        % calculation of srrc pulse
  sin((1-beta)*pi*k/M)./(4*beta*k/M))./...
  (pi*(1-16*(beta*k/M).^2));