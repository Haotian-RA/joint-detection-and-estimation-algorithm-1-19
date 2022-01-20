function detection_board = detect_preamble(threshold,rho)
% detection board: including false alarm and real detection.

n_th=0;
detection_board=zeros(length(threshold),1);
for th=threshold
    n_th=n_th+1;
    if rho>=th
        detection_board(n_th)=1;
    end
end