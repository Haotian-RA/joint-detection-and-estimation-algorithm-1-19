function ps=srrc_fractional_delay(L,beta,T,ts,t_off)
% Generate a Square-Root Raised Cosine Pulse
%      'L' is 1/2 the length of srrc pulse in symbol durations
%      'beta' is the rolloff factor: beta=0 gives the sinc function
%      'T' is the symbol period (unit: second)
%      't_off' is the phase (or timing) offset
%      'ts' is the sample interval (unit: second)

if nargin==4, t_off=0; end;                       % if unspecified, offset is 0
k=-L*T+1e-8+t_off:ts:L*T+1e-8+t_off;           
if (beta==0), beta=1e-8; end;                     % numerical problems if beta=0
ps=4*beta/sqrt(T)*(cos((1+beta)*pi*k/T)+...        % calculation of srrc pulse
  sin((1-beta)*pi*k/T)./(4*beta*k/T))./...
  (pi*(1-16*(beta*k/T).^2));