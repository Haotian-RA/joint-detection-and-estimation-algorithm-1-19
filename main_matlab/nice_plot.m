function [hc,ht,hcl] = nice_plot(gcf)
% handle to current figure and axes (no legend)

FS = 'FontSize';fs = 12;FN = 'FontName';fn = 'Calibri';
LW = 'LineWidth';lw = 2;MS = 'MarkerSize';ms = 10;
Children = {'Title', 'XLabel', 'YLabel', 'ZLabel'};
ha = get(gcf,'Children');

for hc = ha'
   set(hc, FS, fs);
   set(hc, FN, fn);
   set(hc, LW, lw);
   
   for kk=1:length(Children)
       ht = get(hc,Children{kk});
       set(ht, FS, fs);
       set(ht, FN, fn);
   end
   
   hcl = get(hc,'Children');
   for kk=1:length(hcl)
       pp = get(hcl(kk));
       if (isfield(pp,LW) || isfield(pp, lower(LW)))
           set(hcl(kk), LW, lw);
           set(hcl(kk), MS, ms);
       end
   end
end