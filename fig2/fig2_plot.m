close all
n = 100;
alldose = linspace(-1,2,n); 
colGrad = linspace(0.75,0,n);
alldose = 10.^alldose;

load ./shuttle/shuttleModule.mat
figure('position',[30 30 900 900]) % fig Endo TC for IKK


mutantName = {'wt','1','2','3','12','13','23','123'}; %shuttling

% subplot 221, time couses
% subplot 221, time couses
colors={[0 0 1],[0 1 0],[1 0 0]};
mulips={[1 1 0],[1 0 1],[0 1 1]};

k=1;
km =1
subplot(2,2,1)
for j = 1:3 % different genotypes     
    for i=1:100
        plot(shuttleData{k}{j,i}.simData{2},'color',colors{j}+mulips{j}*colGrad(i))
        hold on ;
    end
end
plot([0 240],[0.05 0.05],'--k','linewidth',2)
xlim([0 240])
set(gca,'fontsize',16,'xtick',0:60:240,'xticklabel','','yticklabel','')
%xlabel('Time (mins)')
%ylabel('NFkBn (uM)')
%title('NFkBn')
%legend('Both','TRIF pathway','MyD88 pathway','location','best') 

%%
id.DT = 1; 
id.timespan = 0:240; 

subplot(2,2,3)
nam = {'wt'};
ind = [1 3 4];
nfkbPeakTime = zeros(3,100);
nfkbHalfPeakTime = zeros(3,100);
for km =1:1
    k = ind(km);
    for j = 1:3 % different genotypes     
        for i=1:100
            [pt,hpt]=findPeakHalf(shuttleData{k}{j,i}.simData{2},id);
            nfkbPeakTime(j,i) = pt; 
            nfkbHalfPeakTime(j,i) = hpt;
        end
    end
    plot(alldose,nfkbHalfPeakTime,'linewidth',1.5)
%     ylim([0 240])
    set(gca,'xscale','linear','fontsize',16,'xscale','log'...
        ,'xtick',[.1 1 10 100],'ytick',0:30:120,'xticklabel','','yticklabel','')   
    xlim([0.1 100])
    ylim([0 120])    
    %    xlabel('LPS dose (ng/ml)')
    %    ylabel('Half Peak-time (min)')
    %    title('Quickness of the response')
end

%%
nam = {'wt','h','l'};
ind = [1 3 4];
nfkbPeakTime = zeros(3,100);
for km =1:1
    k = ind(km);
    for j = 1:3 % different genotypes     
        for i=1:100
            indIkk = find(shuttleData{k}{j,i}.simData{1}>=.002);
            indNfkb = find(shuttleData{k}{j,i}.simData{2}>=0.05);        
            ikklastTime(j,i) = length(indIkk);
            nfkblastTime(j,i) = length(indNfkb);
            [tmp b] = max(shuttleData{k}{j,i}.simData{2});
            nfkbPeakTime(j,i) = b; 
        end
    end
    subplot(2,2,2)
    plot(alldose,nfkblastTime,'linewidth',1.5)
    ylim([0 240])
    set(gca,'xscale','linear','ytick',0:30:240,'fontsize',16,'xscale','log'...
        ,'xtick',[.1 1 10 100],'xticklabel','','yticklabel','')    

    xlim([0.1 100])
    %    xlabel('LPS dose (ng/ml)')
    %    ylabel('Response duration (min)')
    %    title('Response duration')
    
    % peak time
    subplot(2,2,4)
    plot(alldose,nfkbPeakTime,'linewidth',1.5)
%     ylim([0 240])
   
    set(gca,'xscale','linear','ytick',0:30:240,'fontsize',16,'xscale','log'...
        ,'xtick',[.1 1 10 100],'ytick',0:30:120,'xticklabel','','yticklabel','')

    xlim([0.1 100])
    ylim([0 120])
    %    xlabel('LPS dose (ng/ml)')
    %    ylabel('Peak time (min)')
    %    title('Time of the maxmium response')
end


%
saveas(gca,'./shuttle/fig2.fig')
%saveas(gca,'./shuttle/nfkbnShuttle.eps','epsc')

%% plot the peak sensitivity 

