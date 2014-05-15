clear; close all; 
load ./simData/dose_scan.mat
figure('position',[680   447   311   531])

colors={[0 0 1],[0 1 0],[1 0 0]};
mulips={[1 1 0],[1 0 1],[0 1 1]};
colGrad = linspace(0.75,0,n);
times = 0:id.DT:240; 


for k = 1:2 % different genotypes     
    subplot(2,1,k)
    for j = 1:3
        for i=1:100
            plot(times,sim{j,i}(k,:),'color',colors{j}+mulips{j}*colGrad(i))
            hold on ;
        end
    end
    xlim([0 240])
    set(gca,'fontsize',16,'xtick',0:60:240,'xticklabel','','yticklabel','')
    title(id.output{k})
end

saveas(gca,'fig2s_NFkBvsIKK.fig') 
saveas(gca,'fig2s_NFkBvsIKK.pdf') 