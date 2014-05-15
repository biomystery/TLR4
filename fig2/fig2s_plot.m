%% plot
clear; close all; 
load ./simData/dose_scan.mat

max_values = max(cell2mat(sim)');
min_values = min(cell2mat(sim)');
min_values = min(reshape(min_values,3,3)');
max_values = max(reshape(max_values,3,3)');

figure('position',[680   667   900   800])
for k = 1:3
    for j = 1:3
        
        subplot(3,3,j+(k-1)*3) 
        data = ones(n,2401);
        
        for i = 1:n
            data(i,:) = sim{j,i}(k,:); 
        end
        imagesc(data,[min_values(k) max_values(k)]);colormap(hot); ...
            colorbar;
        xlabel('Time (mins)');ylabel('LPS Dose (ng/ml)');
        set(gca,'Ydir','normal')
        title(strcat(genotypes{j},id.output{k}),'color','r')
        set(gca,'xtick',1:600:2401,'xticklabel',0:60:240,'ytick',1:33: ...
                100,'yticklabel',[0.1,1,10,100])
    end
end
saveas(gca,'figs2.fig') 
saveas(gca,'figs2.pdf')
