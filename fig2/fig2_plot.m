clear;close all;
addpath('../mcode')
load ./simData/dose_scan.mat

colors={[0 0 1],[0 1 0],[1 0 0]};
mulips={[1 1 0],[1 0 1],[0 1 1]};
colGrad = linspace(0.75,0,n);

time_seq = 0:.1:240;
figure('position',[30 30 900 900]) % fig Endo TC for IKK
subplot(2,2,1)
for j = 1:3 % different genotypes     
    for i=1:100
        plot(time_seq,sim{j,i}(2,:),'color',colors{j}+mulips{j}*colGrad(i))
        hold on ;
    end
end
plot([0 240],[0.05 0.05],'--k','linewidth',2)
xlim([0 240]);ylim([0 0.125]);
set(gca,'fontsize',16,'xtick',0:60:240)
xlabel('Time (mins)')
ylabel('NFkBn (uM)')
title('NFkBn','color','r')


%%
id.DT = 0.1; 
id.timespan = 0:.1:240; 

nfkbPeakTime = zeros(3,100);
nfkbPeak = zeros(3,100);
nfkbHalfPeakTime = zeros(3,100);


for j = 1:3 % different genotypes     
    for i=1:100
        [pt,hpt]=findPeakHalf(sim{j,i}(2,:),id);
        nfkbPeakTime(j,i) = pt; 
        nfkbHalfPeakTime(j,i) = hpt;
        [pval,~]=max(sim{j,i}(2,:));
        nfkbPeak(j,i) = pval; 
            
    end
end

subplot(2,2,3)
plot(alldose,nfkbHalfPeakTime,'linewidth',1.5)
ylim([0 60])    
set(gca,'ytick',0:20:60,'fontsize',16,'xtick',-1:2,'xticklabel',[.1,1,10,100]) 
xlabel('LPS dose (ng/ml)')
ylabel('Half Peak-time (min)')
title('Quickness of the response','color','r')


%%

ikklastTime = zeros(3,100);
nfkblastTime = zeros(3,100);

for j = 1:3
     for i = 1:n
        ind = find(sim{j,i}(1,:)>=1);
        ikklastTime(j,i) = length(ind)*id.DT;
        ind = find(sim{j,i}(2,:)>=0.05);
        nfkblastTime(j,i) = length(ind)*id.DT;
     end
 end

subplot(2,2,2)
plot(alldose,nfkblastTime,'linewidth',1.5)

ylim([0 240])
set(gca,'xscale','linear','ytick',0:60:240,'fontsize',16,'xtick',-1: ...
        2,'xticklabel',[.1,1,10,100]) 

xlabel('LPS dose (ng/ml)')
ylabel('Response duration (min)')
title('Response duration','color','r')
    
% peak time
subplot(2,2,4)
plot(alldose,nfkbPeakTime,'linewidth',1.5)
ylim([0 60])
set(gca,'xscale','linear','ytick',0:20:60,'fontsize',16,'xtick',-1:2,'xticklabel',[.1,1,10,100]) 

xlabel('LPS dose (ng/ml)')
ylabel('Peak time (min)')
title('Time of the maxmium response','color','r')

%%save
saveas(gca,'fig2.fig')
saveas(gca,'fig2.pdf')


%% get nfkb peak

figure 
plot(alldose,nfkbPeak)