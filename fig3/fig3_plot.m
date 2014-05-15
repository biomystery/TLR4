clear;close all; 
load ./simData/simData.mat
%% color bar
h = figure('position',[990   820   576    90])
colors={[0 0 1],[0 1 0],[1 0 0]};
mulips={[1 1 0],[1 0 1],[0 1 1]};

colGrad = linspace(0,0.75,numel(hillCoeffient));
m = numel(hillCoeffient); 
map = zeros(m,3); 
for i = 1:m
    map(i,:) = colors{3}+mulips{3}*colGrad(i); 
end
I = 1:m;
imagesc(I)
colormap(map)
set(gca,'ytick',[],'fontsize',16)
set(gca,'xtick',1:m,'xticklabel',hillCoeffient)
xlabel('Hill coefficient') 

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), ...
                     pos(4)])
saveas(h,'colorbar.fig')
print(h,'colorbar.pdf','-dpdf','-r0')



%% figure 


figure('position',[30 30 900 450]) % fig Endo TC for IKK
subplot(1,2,1) % plot the doses responses curves.

hold on ;
for i = 2:numel(hillCoeffient)
    plot(alldose,ikkPeak{i}(2,1:20),'color',colors{3}+mulips{3}*colGrad(i),...
         'linewidth',1.5)
    hold on ;
end
plot(alldose,ikkPeak{1}(1,1:20),'g','linewidth',1.5)

set(gca,'xscale','linear','fontsize',16,'xscale','log'...
        ,'xtick',[1e-2 1 1e+2])
xlim([1e-2 1e+2])
xlabel('LPS dose (ng/ml)')
ylabel('IKK peak level (\muM)')
title('Hill kinetics')

% $$$ %%
% $$$ subplot(2,2,2) % 
% $$$ 
% $$$ plot(alldose,ikkPeakTmp(1,:),'g',alldose,ikkPeakTmp(2,:),'r','linewidth',1.5)
% $$$ set(gca,'fontsize',16,'xscale','log'...
% $$$         ,'xtick',[1e-4 1 1e+2])
% $$$ 
% $$$ xlim([1e-4 1e+2])
% $$$ xlabel('LPS dose (ng/ml)')
% $$$ ylabel('IKK peak level (\muM)')
% $$$ title('Michaels-Menten kinetics')

%%
subplot(1,2,2)
expdata = [0.1,	5.36,	3.32; 
           1,	9.87,	14.64;
           10,	27.32,	58.15;
           100,	33.39,	60];
plot(expdata(:,1),expdata(:,2),'go-',expdata(:,1),expdata(:,3),'ro-','linewidth',1.5)
set(gca,'fontsize',16,'xscale','log'...
        ,'xtick',[.1 1 10 100],'ytick',0:30:120)
xlim([0.01 100])
xlabel('LPS dose (ng/ml)')
ylabel('IKK peak level (au)')
title('Experimental data')

saveas(gca,'fig3.fig')
saveas(gca,'fig3.pdf')

%% plot nfkb
for k = 1:numel(hillCoeffient)
    for j = 1:2 % different genotypes 
        for i = 1:n
            [tmpMax tmpMaxInd] = max(shuttleData{k}{j,i}(1,:));
            [tmpMax2 tmpMaxInd2] = max(shuttleData{k}{j,i}(2,:));
            ikkPeakVal(j,i) = tmpMax; 
            ikkPeakTime(j,i) = (tmpMaxInd-1)*id.DT; 
            nfkbPeakVal(j,i) = tmpMax2; 
            nfkbPeakTime(j,i) = (tmpMaxInd2-1)*id.DT; 

        end
    end
    ikkPeak{k} = ikkPeakVal;
    ikkPeakT{k} = ikkPeakTime; 
    nfkbPeak{k} = nfkbPeakVal;
    nfkbPeakT{k} = nfkbPeakTime; 
    
end


figure('position',[30 30 900 900]) % fig Endo TC for IKK

subplot(2,2,1) % plot the doses responses curves.


for i = 2:numel(hillCoeffient)
    plot(alldose,ikkPeak{i}(2,1:20),'color',colors{3}+mulips{3}*colGrad(i),...
         'linewidth',1.5)
    hold on ;
end
plot(alldose,ikkPeak{1}(1,1:20),'g','linewidth',1.5)
set(gca,'xscale','linear','fontsize',16,'xscale','log'...
        ,'xtick',[1e-2 1 1e+2])
xlim([1e-2 1e+2])
xlabel('LPS dose (ng/ml)')
ylabel('IKK peak level (\muM)')
title('IKK peak level','color','r')
%legend(num2str(hillCoeffient))


subplot(2,2,2) % plot the doses responses curves.


for i = 2:numel(hillCoeffient)
    plot(alldose,ikkPeakT{i}(2,1:20),'color',colors{3}+mulips{3}*colGrad(i),...
         'linewidth',1.5)
    hold on ;
end

plot(alldose,ikkPeakT{1}(1,1:20),'g','linewidth',1.5)
set(gca,'xscale','linear','fontsize',16,'xscale','log'...
        ,'xtick',[1e-2 1 1e+2])
xlim([1e-2 1e+2])
xlabel('LPS dose (ng/ml)')
ylabel('IKK peak Time (mins)')
title('IKK peak time','color','r')

subplot(2,2,3) % plot the doses responses curves.


for i = 2:numel(hillCoeffient)
    plot(alldose,nfkbPeak{i}(2,1:20),'color',colors{3}+mulips{3}*colGrad(i),...
         'linewidth',1.5)
    hold on ;
end
plot(alldose,nfkbPeak{1}(1,1:20),'g','linewidth',1.5)
set(gca,'xscale','linear','fontsize',16,'xscale','log'...
        ,'xtick',[1e-2 1 1e+2])
xlim([1e-2 1e+2])
xlabel('LPS dose (ng/ml)')
ylabel('NF\kappaB peak level (\muM)')
title('NF\kappaB peak level','color','r')


subplot(2,2,4) % plot the doses responses curves.


for i = 2:numel(hillCoeffient)
    plot(alldose,nfkbPeakT{i}(2,1:20),'color',colors{3}+mulips{3}*colGrad(i),...
         'linewidth',1.5)
    hold on ;
end
plot(alldose,nfkbPeakT{1}(1,1:20),'g','linewidth',1.5)
set(gca,'xscale','linear','fontsize',16,'xscale','log'...
        ,'xtick',[1e-2 1 1e+2])
xlim([1e-2 1e+2])
xlabel('LPS dose (ng/ml)')
ylabel('NF\kappaB peak Time (mins)')
title('NF\kappaB peak time','color','r')

saveas(gca,'fig3b.fig')
saveas(gca,'fig3b.pdf')