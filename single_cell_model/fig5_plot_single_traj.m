clear; close all; 

load('./simData/single_cell_5000_lognormal_delay_mt_scale1_lps.mat')

h = figure('units','normalized','outerposition',[0 0 1 1])
for i = 0: floor(numel(both_vary.nfkb)/9)
    for j = 1:9
        subplot(3,3,j)
        y=both_vary.nfkb{j+i*9};
        plot(y,'b');
        xlim([0 720]); ylim([0 0.15])
        set(gca,'xtick',0:60:720,'xticklabel',0:12)
        text(600,0.1,strcat('id = ',mat2str(j+i*9)),'fontsize',16,'color','r')
    end
    pause
end

