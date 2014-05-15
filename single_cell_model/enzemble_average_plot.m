%% Initial setting 
clc;clear;
addpath('../mcode/') ;
filenames = {'./simData/single_cell_.5_lognormal_delay_mt_scale1.mat', ...
             './simData/single_cell_1_lognormal_delay_mt_scale1.mat',...
            './simData/single_cell_5_lognormal_delay_mt_scale1.mat',...
            './simData/single_cell_20_lognormal_delay_mt_scale1.mat',...
            './simData/single_cell_35_lognormal_delay_mt_scale1.mat',...
            './simData/single_cell_500_lognormal_delay_mt_scale1.mat',...
            './simData/single_cell_1000_lognormal_delay_mt_scale1.mat',...
            './simData/single_cell_5000_lognormal_delay_mt_scale1.mat'}

doses = [.5,1,5,20,35,500,1000,5000];

h= figure('units','inch','position',[ 9.4306    9.1944   13.9722 ...
                    4.2639])

colors = colormap(jet(8));

for j = 1:8
    load(filenames{j})
    plot(both_vary.mean(3,:),'color',colors(j,:),'linewidth',2)
    hold on 
    drawnow
end
title('Enzemble average of 100 single cell simulations')
xlim([0 60*12])
set(gca,'xtick',0:60:60*12,'xticklabel',0:12)



hcb= colorbar; 
set(hcb,'YTick',1:8,'YTicklabel',doses)
ylabel(hcb,'LPS (ng/ml)') 


 set(h,'Units','Inches');
 pos = get(h,'Position');
 set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), ...
                     pos(4)])
 saveas(h,'enzemble_average_delay_10_30to32_.1_dosescan_lower_scale_1.fig')
 print(h,'enzemble_average_delay_10_30to32_.1_dosescan_lower_scale_1.pdf','-dpdf','-r0')
open 'enzemble_average_delay_10_30to32_.1_dosescan_lower_scale_1.pdf'
 