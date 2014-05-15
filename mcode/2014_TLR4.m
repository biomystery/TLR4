%  TLR4 WORK , Spring 2014. Focus is on NFkB response filters (some small  component is 
% Sets to use: base dose response
% #16 - 500pg/mL LPS
% #53 - 1ng/mL LPS
% #54 - 5ng/mL LPS
% #55 - 20ng/mL LPS
% #56 - 35ng/mL LPS
% #15 - 500ng/mL LPS
% #69 - 1ug/mL LPS (+0.4ng/mL IL-4, non-physiological/no effect)
% #14 - 5ug/mL LPS

% Set environment
clear java
clc; close all
if ismac; basedir = '/Users/Brooks/Dropbox/'; %OSX
else basedir = '/home/brooks/Dropbox/'; end
savedir = [basedir,'Writing/TLR4/figs/'];

% Load NFkB trajectories
nfkbname = [basedir,'Code/UCSDcellTrack/Visualization/nfkb.mat'];
if ~exist(nfkbname,'file')
    ids_5ug = [16, 53, 54, 55, 56, 15, 69, 14];
    doses  = [.5 1 5 20 50 500 1000 5000];
    nfkb = struct;
    for i =1:length(ids_5ug)
        [graph] = visualizeID(ids_5ug(i),0);
        nfkb(i).data = nan(size(graph.var));
        % Smooth data slightly
        for rw = 1:size(graph.var,1)
            inFrames = graph.celldata(rw,3):min((graph.celldata(rw,4)-9),size(graph.var,2)); % Omit last 45min of frames
            nfkb(i).data(rw,inFrames) = graph.var(rw,inFrames);
        end
        nfkb(i).data = graph.var;
        nfkb(i).dose = doses(i);
        nfkb(i).doses = doses;
    end
    save(nfkbname,'nfkb')
    clear graph info i ids
else
    load(nfkbname)
end
clear nfkbname
colors.green = [0 195 169]/255;
colors.blue = [29 155 184]/255;
colors.dark_blue = [62 107 133]/255;


%% 2A. single-cell NFkB response to LPS 4 dose heatmaps, 200 cells/ea
doses = [1 3 5 8];
mod_colormap = divergingmap(0:1/1023:1,[12 12 77]/255,[158 4 0]/255);
mod_colormap(1,:) = [0.1 0.1 0.1];
fig1 = figure('Position',[490   710   402   650],'PaperPositionMode','auto');
ha = tight_subplot(4,1);colormap(mod_colormap)

for i =1:length(doses)
    data1 = nfkb(doses(i)).data;
    order1 = hierarchial(data1,0);
    data1 = data1(order1,:);
    imagesc(data1(round(linspace(1,size(data1,1),200)),1:109),'Parent',ha(i))
    set(ha(i),'CLim',[-0.1 2],'XTick',[1 37 73 109 145],'YTick',[],'XTickLabel',{},'Box','off','TickDir','out') 
    if i ==length(doses)
           set(ha(i),'XTickLabel',{'0', '3', '6', '9', '12'})
    end
end
%print(fig1,[savedir,'subfig_2a.eps'], '-depsc')


%% 2B. Small multiples at low and high doses
% 5ug/mL dose

t = 0:(1/12):12;

% xy4,#5 (143)
% xy3,#37(85)
% xy5,#66(201)
% xy12,#25(533)
% xy4,#29(137)
% xy2,#23(47)
% xy12,#69(557)
% xy5, #39 (189)
ids_5ug = [143 85 201 557 533 189 137 47];
fig = figure('Position',[37, 50, 200, 70*numel(ids_5ug)],'PaperPositionMode','auto');
ha = tight_subplot(numel(ids_5ug),1,0.01);
for i = 1:length(ids_5ug)
    plot(ha(i),t,nfkb(8).data(ids_5ug(i),:),'LineWidth',2,'Color',colors.green)
    set(ha(i),'XLim',[min(t),max(t)],'YLim',[-.3 2],'XTickLabel',{},'YTickLabel',{});
end
print(fig,[savedir,'subfig_2b(1).eps'], '-depsc')

% 5ng/mL dose
% 17,#20 (159)
% xy23,#19(383)
% xy18,#15(196)
% xy19,#9(223)
% xy17,#29(166)
% xy16,#21(118)
% xy19,#20(231)
% xy24, #41 (446)
ids_5ng = [196 118 383 159 231 223 446 166];
fig = figure('Position',[37, 50, 200, 70*numel(ids_5ng)],'PaperPositionMode','auto');
ha = tight_subplot(numel(ids_5ng),1,0.01);
for i = 1:length(ids_5ng)
    plot(ha(i),t,nfkb(3).data(ids_5ng(i),:),'LineWidth',2,'Color',colors.dark_blue)
    set(ha(i),'XLim',[min(t),max(t)],'YLim',[-.3 2],'XTickLabel',{},'YTickLabel',{});
end
print(fig,[savedir,'subfig_2b(2).eps'], '-depsc')


%% 2C. Single-cell oscillations: Fourier small multiples 
doses = [1 2 3 4 5 6 7 8];
fig = figure('name', 'Fourier Transform','Position',[37, 50, 200, 80*numel(doses)]);
set(gcf,'PaperPositionMode','auto')
ha = tight_subplot(numel(doses),1,0.01);
fig2 = figure('Position',[37, 50, 200, 80*numel(doses)],'PaperPositionMode','auto','Visible','off');
ha_lines = tight_subplot(numel(doses),1,0.01);
tot = 20;
for i =1:length(doses)
    idx = doses(i);
    metrics = nfkbMetrics(nfkb(idx).data);
    flicker_strength  = mean(metrics.fourier(:,2)*metrics.freq(2))
    flicker = 1./repmat(metrics.freq,size(metrics.fourier,1),1)*flicker_strength;
    fft_lines =  metrics.fourier(:,1:tot)-flicker(:,1:tot);
    fft_lines(:,1) = nan;
    freqs = metrics.freq(1:tot);
    xflip = [freqs(1:end-1) fliplr(freqs)];
    yflip = [fft_lines(:,1:end-1) fliplr(fft_lines)];
    % Make line plots: transparent lines for individuals, with average superimposed
    hold(ha(i),'on')
    for j =1:size(yflip,1)
        patch(xflip, yflip(j,:), 'r', 'EdgeAlpha', 0.018, 'FaceColor', 'none','Parent',ha(i));
    end
    yflip2 = [mean(fft_lines(:,1:end-1)) fliplr(mean(fft_lines))];
    patch(xflip, yflip2, 'r', 'EdgeAlpha', 1, 'FaceColor', 'none','LineWidth',2,'EdgeColor',[250 109 92]/255,'Parent',ha(i));
    hold(ha(i),'off')
    
    
    set(ha(i),'XLim',[freqs(2) freqs(tot)],'YLim',[-0.05 0.22],'XTick',[],'YTick',[])
    set(ha_lines(i),'XLim',[freqs(2) freqs(tot)],'YLim',[-0.05 0.22],'XTick',[1e-4 2e-4 3e-4 4e-4],'YTick',[0 0.1 0.2])
    if i~=length(doses)
        set(ha_lines(i),'XTickLabel',{});
    end
    set(ha_lines(i),'YTickLabel',{'0.1','0.2','0.3'},'LineWidth',1.5);
end
print(fig,[savedir,'subfig_2c.png'], '-dpng')
print(fig2,[savedir,'subfig_2c_lines.eps'], '-deps')

%% 3A+3B. Model predictions of dynamic features
load([basedir,'Writing/TLR4/fig2/simData/dose_scan.mat'])

% Top: model figure
id.DT = 0.1; 

nfkbPeakTime = zeros(3,100);
nfkbPeak = zeros(3,100);
nfkbHalfPeakTime = zeros(3,100);
nfkbVelocity = zeros(3,100);

for j = 1:3 % wt, tko, mko     
    for i=1:100
        nfkb_vect = sim{j,i}(2,:);
        deriv_vect = [0 (nfkb_vect(3:end)-nfkb_vect(1:end-2))/2 0]/id.DT;
        [nfkbPeak(j,i), idx] = max(nfkb_vect);
        nfkbPeakTime(j,i) = idx*id.DT; 
        nfkbHalfPeakTime(j,i) = find(nfkb_vect>(max(nfkb_vect)/2),1,'first')*id.DT;  
        nfkbVelocity(j,i) = max(deriv_vect(1:idx));
    end
end

pk1_mus = zeros(size(nfkb));
pk1_stds = zeros(size(nfkb));
v_mus = zeros(size(nfkb));
v_stds = zeros(size(nfkb));
for i = 1:length(nfkb)
    metrics = nfkbMetrics(nfkb(i).data,60,1);
    pk1_mus(i) = nanmean(metrics.pk1_time);
    pk1_stds(i) = nanstd(metrics.pk1_time);
    % Smooth trajectories, then calculate derivatives
    smooth_sz = 3;
    tmp = [ones(size(nfkb(i).data,1),ceil(smooth_sz/2)),nfkb(i).data,nan(size(nfkb(i).data,1),ceil(smooth_sz/2))]';
    c = smooth(tmp(:),smooth_sz,'moving');
    smooth_nfkb = reshape(c,size(tmp,1),size(tmp,2))';
    smooth_nfkb = smooth_nfkb(:,ceil(smooth_sz/2)+1:end-ceil(smooth_sz/2));
    deriv = [zeros(size(smooth_nfkb,1),1),(smooth_nfkb(:,3:end)-smooth_nfkb(:,1:end-2))/2];
    velocity = max(deriv,[],2);
    velocity(isinf(velocity)) = nan;
    
    v_mus(i) = nanmean(velocity);
    v_stds(i) = nanstd(velocity);
end

% Look at first peak time and reaction velocity - model on top, data on bottom.
fig1 = figure('Name','1st peak time','PaperPositionMode','auto','Position',[650   824   382   416]);
set(gcf,'DefaultAxesColorOrder',[colors.blue; colors.green; colors.dark_blue])
ha = tight_subplot(2,1);

plot(ha(1),10.^alldose,nfkbPeakTime','LineWidth',2)
set(ha(1),'xscale','log','xtick',[.1 10 1000],'YLim',[15 70],'XLim',[0.1 1000],'XTickLabel',{},'YTickLabel',{})
hold(ha(2),'on')
errorbar(nfkb(1).doses, pk1_mus-10,pk1_stds,'--','Color',colors.blue,'LineWidth',2);
plot(ha(2),nfkb(1).doses, pk1_mus-10,'o','LineWidth',2,'Color',colors.blue,'MarkerSize',10,'MarkerFaceColor',[1 1 1])
hold(ha(2),'off')
set(ha(2),'xscale','log','xtick',[.5 50 5000],'YLim',[15 70],'XLim',[0.4 6000],'XTickLabel',{},'YTickLabel',{})
print(fig1,[savedir,'subfig_3a.eps'], '-depsc')


fig2 = figure('Name','Translocation Velocity','PaperPositionMode','auto','Position',[650   824   382   416]);
set(gcf,'DefaultAxesColorOrder',[colors.blue; colors.green; colors.dark_blue])
ha = tight_subplot(2,1);

plot(ha(1),10.^alldose,nfkbVelocity','LineWidth',2)
set(ha(1),'xscale','log','xtick',[.1 10 1000],'YLim',[2e-3 0.02],'XLim',[0.1 1000],'XTickLabel',{},'YTickLabel',{})
hold(ha(2),'on')
errorbar(nfkb(1).doses, v_mus,v_stds,'--','Color',colors.blue,'LineWidth',2);
plot(ha(2),nfkb(1).doses, v_mus,'o','LineWidth',2,'Color',colors.blue,'MarkerSize',10,'MarkerFaceColor',[1 1 1])
hold(ha(2),'off')
set(ha(2),'xscale','log','xtick',[.5 50 5000],'YLim',[0 0.5],'XLim',[0.4 6000],'XTickLabel',{},'YTickLabel',{})
print(fig2,[savedir,'subfig_3b.eps'], '-depsc')



%% 3C. duration scaling in single cells
fig1 = figure('Position',[ 490   1113  440  240], 'PaperPositionMode','auto');
duration_sum = zeros(100,length(nfkb));
vect = 0:1.2/99:1.2;
for i = 1:length(nfkb)
    nfkb1 = nfkb(i).data+0.2;

    for j = 1:length(duration_sum)
        duration_sum(j,i) = (nansum(nfkb1(:)>vect(j)))/sum(~isnan(nfkb1(:)));
    end
end
linecolors = linspecer(length(nfkb),'sequential');
set(gcf,'DefaultAxesColorOrder',linecolors)
plot(vect,duration_sum,'LineWidth',2),axis([min(vect) max(vect) 0 1])
set(gca,'XTickLabel',{},'YTickLabel',{})
get(gca,'XTick')
print(gcf,[savedir,'subfig_3c.eps'], '-depsc')
%% 3D. integral scaling in single cells
integrals = cell(size(nfkb));
for i = 1:numel(integrals)
    metrics = nfkbMetrics(nfkb(i).data,140,1);
    integrals{i} = metrics.integral-metrics.pk1_integral;
end                

doses = log10(nfkb(1).doses);
width = 0.6;
show_bins = 0;
y_range = [-3 60];
bin_scale = 1.0;

% Make violin-based graph from a distribution. Bins are defined beforehand, but can be adjusted.    
vio_colors = cell(size(integrals));
for i = 1:length(integrals)
    vio_colors{i} = colors.green;
end
spaceviolin(integrals,doses,vio_colors,y_range,show_bins,width,bin_scale)
set(gca,'YTickLabel',{[]},'XTickLabel',{[]})
print(gcf,[savedir,'subfig_3d.eps'], '-depsc')

%% 4A. 1st-peak saturation in single cells
maxes = cell(size(nfkb));
for i = 1:numel(maxes)
    metrics = nfkbMetrics(nfkb(i).data,80,1);
    maxes{i} = metrics.pk1_amp;
end                

doses = log10(nfkb(1).doses);
width = 0.5;
show_bins = 0;
y_range = [-0.15 2.8];
bin_scale = 0.8;

% Make violin-based graph from a distribution. Bins are defined beforehand, but can be adjusted.    
vio_colors = cell(size(maxes));
for i = 1:length(maxes)
    vio_colors{i} = colors.dark_blue;
end
spaceviolin(maxes,doses,vio_colors,y_range,show_bins,width,bin_scale)
set(gca,'YTickLabel',{[]},'XTickLabel',{[]})
print(gcf,[savedir,'subfig_4a.eps'], '-depsc')



%% 4B. peak IKK activity in MyD88 vs TRIF KO
doses = log10([0.1 1 10 100]);
trifko = [3 13 58 60];
myd88ko = [5 8 26 34];

fig1 = figure('Position',[500, 1030, 600, 300],'PaperPositionMode','auto');
hold on
plot(doses,trifko,'--o', 'Color',colors.dark_blue,'LineWidth',2,'MarkerSize',10,'MarkerFaceColor',[1 1 1])
plot(doses,myd88ko,'--o','Color',colors.green,'LineWidth',2,'MarkerSize',10,'MarkerFaceColor',[1 1 1])

hold off
set(gca,'XTickLabel',{},'YTickLabel',{})
print(fig1,[savedir,'subfig_4b.eps'], '-depsc')



%% 4E. Model simulations: IKK activity and peak NFkB level
% Calculate dynamic features from saved response curves
load([basedir,'Writing/TLR4/fig3/simData/simData.mat'])
hillCoef = hillCoeffient;
for k = 1:numel(hillCoef)
    for j = 1:2 % cycle genotypes 
        for i = 1:n %
            [tmpMax tmpMaxInd] = max(shuttleData{k}{j,i}(1,:));
            [tmpMax2 tmpMaxInd2] = max(shuttleData{k}{j,i}(2,:));
            ikkPeakVal(j,i) = tmpMax; 
            nfkbPeakVal(j,i) = tmpMax2; 
        end
    end
    ikkPeak{k} = ikkPeakVal;
    nfkbPeak{k} = nfkbPeakVal;
end
desat_rate = 10; % Speed of color desaturation
desat = desat_rate.^(linspace(0,1,numel(hillCoef))); % Desaturation function
fig1 = figure('position',[480   910   992   360],'PaperPositionMode','auto');
ha = tight_subplot(1,2,0.1);

% Plot max IKK activity as a function of Hill coefficient
hold(ha(1),'on')
for i = 2:numel(hillCoef)
    if hillCoef(i)==3
        plot(ha(1),alldose,ikkPeak{i}(2,1:20),'Color',colors.blue/desat(i-1),'LineWidth',2.4)
    else
        plot(ha(1),alldose,ikkPeak{i}(2,1:20),'Color',colors.blue/desat(i-1),'LineWidth',1.2)
    end
end
plot(ha(1),alldose,ikkPeak{1}(1,1:20),'LineWidth',2.4,'Color',colors.green)
hold(ha(1),'off')
set(ha(1),'XScale','log','XTick',[1e-2 1 1e+2],'XLim',[1e-2 1e+2],'YLim',[0 0.033],'LineWidth',1.5)

% Plot max NFkB levels as a function of Hill coefficient
hold(ha(2),'on')
for i = 2:numel(hillCoef)
    if hillCoef(i)==3
        plot(ha(2),alldose,nfkbPeak{i}(2,1:20),'Color',colors.blue/desat(i-1),'LineWidth',2.4)
    else
        plot(ha(2),alldose,nfkbPeak{i}(2,1:20),'Color',colors.blue/desat(i-1),'LineWidth',1.2)
    
    end
end
plot(ha(2),alldose,nfkbPeak{1}(1,1:20),'LineWidth',2.4,'Color',colors.green)
hold(ha(2),'off')
set(ha(2),'XScale','log','XTick',[1e-2 1 1e+2],'XLim',[1e-2 1e+2],'YLim',[0.014 0.125],'LineWidth',1.5)
print(fig1,[savedir,'subfig_4e.eps'], '-depsc')

% Make colorbar for Hill coefficient
cmap1 = zeros(length(hillCoef)-1,3);
for i =1:length(cmap1)
    cmap1(i,:) = colors.blue/desat(i);
end
fig2 = figure('Position',[838   669    80   650],'PaperPositionMode','auto');
imagesc((1:length(hillCoef)-1)'),colormap(cmap1)
set(gca,'XTick',[],'YTick',[])
print(fig2,[savedir,'subfig_4e(bar).eps'], '-depsc')



%%

subplot(2,2,3)
plot(alldose,nfkbHalfPeakTime,'linewidth',1.5)
ylim([0 60])    
set(gca,'ytick',0:20:60,'fontsize',16,'xtick',-1:2,'xticklabel',[.1,1,10,100]) 
xlabel('LPS dose (ng/ml)')
ylabel('Half Peak-time (min)')
title('Quickness of the response','color','r')

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

% get nfkb peak
figure 
plot(alldose,nfkbPeak)


for i = 2:numel(hillCoef)
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
legend(num2str(hillCoeffient))


subplot(2,2,2) % plot the doses responses curves.


for i = 2:numel(hillCoef)
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






%% - - - - - - - - - METHODOLOGY - - - - - - - - - 
% a) Normalizing NFkB signal  
id = 15;

[graph,info,measure] = visualizeID(id,0);
nfkb_cyto = measure.NFkBCytoplasm(info.keep,:);
nfkb_cyto = nfkb_cyto./repmat(nanmean(nfkb_cyto(:,1:3),2),1,size(nfkb_cyto,2));

nfkb_nuc = measure.NFkBNuclear(info.keep,:);
nfkb_nuc = nfkb_nuc./repmat(nanmean(nfkb_nuc(:,1:3),2),1,size(nfkb_nuc,2));


nfkb_corr = graph.var;

t = 0:1/12:(size(nfkb_nuc,2)-1)/12;
t2 = 0:1/12:(size(nfkb_corr,2)-1)/12;


mod_colormap = divergingmap(0:1/1023:1,[12 12 77]/255,[158 4 0]/255);

figure(1),imagesc(nfkb_cyto), colormap(mod_colormap)
figure(2), imagesc(nfkb_nuc), colormap(mod_colormap)

figure(3)
plot(t, nanmean(nfkb_nuc),'LineWidth',2,'Color',colors.blue)
hold on
plot(t,nanmean(nfkb_cyto),'LineWidth',2,'Color',colors.green)
plot(t2,nanmean(nfkb_corr),'LineWidth',2,'Color',colors.red)
hold off
%%

ordr = randperm(size(nfkb_corr,1),5);
figure(4)
plot(t2',nfkb_corr(ordr,:)','-','LineWidth',2)
hold on
plot(t',nfkb_nuc(ordr,:)','.','LineWidth',2)
hold off

%%

data = measure.NFkBNuclear(info.keep,1:144);
local_std = stdfilt(data,ones(1,7));
target_windows = local_std<repmat(prctile(local_std,25,2),1,size(local_std,2));
tmp = data;
tmp(~target_windows) = nan;
tmp(:, 1:24) = nan;
base_vals = prctile(tmp,25,2);
start_vals = nanmean(data(:,1:3),2);

for i =1:size(data,1)
    data(i,1:24) = data(i,1:24) - linspace(start_vals(i)-base_vals(i),0,24);
end

data = data./repmat(nanmean(data(:,1:3),2),1,size(data,2));

ordr = randperm(size(data,1),8);
t = 0:1/12:(size(data,2)-1)/12;
plot(t,data(ordr,:)','.')
%%

figure,imagesc(stdfilt(data,ones(1,7)),[0 2000])





%% b) Behavior vs RelA brightness
id = 14;
[graph,info,measure] = visualizeID(id,0);

metrics = nfkbMetrics(graph.var,96,1);
colors = setcolors;
% Total integrated activity (8 hrs) vs brightness
x_var = prctile(measure.NFkBNuclear(info.keep,1:8),18.75,2);
y_var = metrics.integral;
r = corrcoef(x_var,y_var);
figure,plot(x_var,y_var,'.','MarkerSize',20, 'Color',colors.green), title(['r = ',num2str(round(r(1,2)*100)/100)])
xlabel('Starting nuclear RelA (a.u.)')
ylabel('Integrated translocation activity')
axis([0 40 0 190])
% print(gcf,[basedir,'brightness_vs_activity(pk1).eps'], '-depsc')

% First-peak amplitude vs brightness
x_var = prctile(measure.NFkBNuclear(info.keep,1:8),18.75,2);
y_var = metrics.pk1_integral;
drops = isnan(x_var)|isnan(y_var);
r = corrcoef(x_var(~drops),y_var(~drops));
figure,plot(x_var,y_var,'.','MarkerSize',20, 'Color',colors.green), title(['r = ',num2str(round(r(1,2)*100)/100)])
xlabel('Starting nuclear RelA (a.u.)')
ylabel('First peak integral')
axis([0 40 0 40])
% print(gcf,[basedir,'brightness_vs_activity(pk1).eps'], '-depsc')

%% 
num_bins = 40;
x_range = [0.-.1 2.5];
metrics = nfkbMetrics(nfkb(ind).data,120,0);
for ind = 1:9
    mod_colormap = divergingmap(0:1/(num_bins-1):1,[12 12 77]/255,[158 4 0]/255);
    x = min(x_range):diff(x_range)/(num_bins-1):max(x_range);
    all_hists = zeros(num_bins,80);
    for i = 1:80
           n = hist(metrics.vab(:,i),x);
           all_hists(end:-1:1,i) = n./sum(n);
    end

    figure,imagesc(all_hists,[0 .15]),colormap(mod_colormap)
end
set(gcf,'Position',  [283   824   908   134])






% The base TLR response is oscillatory, but single cells are desynchronized

% a) Fourier signatures, by subpopulation (- 1/f noise)
id = 9;
var1 = nfkb(id).data;
num_clst = 1;

graph.t = 0:1/12:144/12;

metrics = nfkbMetrics(var1,30,1);
Gaussian.Dist = gmdistribution.fit(metrics.pk1_integral,num_clst); % 2 subpopulations
% Order Gaussian mixture components by mean and cluster
[~,sortind] = sort(Gaussian.Dist.mu,'ascend');
[~, sortorder] = sort(sortind,'ascend');
Gaussian.Cluster = cluster(Gaussian.Dist,metrics.integral);
tmpcol = Gaussian.Cluster;
tmpcol(~isnan(tmpcol)) = sortorder(tmpcol(~isnan(tmpcol)));
Gaussian.Cluster = tmpcol;

colors1 = [colors.blue; colors.green];
for clst = 1:num_clst
    subpop1 = metrics.vab(Gaussian.Cluster==clst,:);
    idx = 2*(clst-1)+1;
    figure
    set(gcf,'Position',[563   907   984   427],'PaperPositionMode','auto')
    hold on
    for i = 1:size(subpop1,1)
        fill([graph.t,graph.t(end:-1:1)],[subpop1(i,:),zeros(1,size(subpop1,2))],colors1(clst,:)/(1+i/100),...
            'FaceAlpha',0.025,'EdgeColor','none')
    end
    hold off
    set(gca,'XLim',[0 12],'YLim',[-.01 3])
    set(gca,'Visible','off')
    %print(gcf,[basedir,nfkb(id).name,'-traces(clst',num2str(clst),').eps'], '-depsc')

    % Bar graph
    figure
    set(gcf,'Position',[ 418         904        1094         431],'PaperPositionMode','auto')
    % Take a guess at 1/f noise based on 2nd value...

    % NOTE: may be better to do this on a cell-by-cell basis. Try both!!!

    avg_fft = mean(metrics.fourier(Gaussian.Cluster==clst,:));
    flicker = 1./metrics.freq*avg_fft(2)*metrics.freq(2);

    bar(metrics.freq,avg_fft-flicker,...
        'FaceColor',colors1(clst,:),'BarWidth',0.9,'LineStyle','none')
    set(gca,'YTickLabel',{[]})
    ylabel('|H(f)|')
    xlabel('Frequency (Hz)')
    set(gca,'XLim',[0 8e-4],'YLim',[0 0.2])
   %print(gcf,[basedir,nfkb(id).name,'-fourier(clst',num2str(clst),').eps'], '-depsc')
end

%% Oscillations: behavior vs brightness
id = 70;
[graph,info,measure] = visualizeID(id,0);

metrics = nfkbMetrics(graph.var,100,1);
brightness = nanmedian(measure.NFkBCytoplasm(info.keep,1:3),2);
areas = nanmean(measure.Area(info.keep,1:3),2);

x_var = brightness;
y_var = metrics.pk1_integral;

r = corrcoef(x_var,y_var);
figure,plot(x_var,y_var,'.','MarkerSize',20, 'Color',colors.green), title(['r = ',num2str(round(r(1,2)*100)/100)])
xlabel('Cytoplasmic RelA (a.u.)')
ylabel('First peak translocation activity')
axis([0 45 0 40])
print(gcf,[basedir,'brightness_vs_activity(pk1).eps'], '-depsc')

x_var = brightness;
y_var = metrics.integral;

r = corrcoef(x_var,y_var);
figure,plot(x_var,y_var,'.','MarkerSize',20, 'Color',colors.green), title(['r = ',num2str(round(r(1,2)*100)/100)])
xlabel('Cytoplasmic RelA (a.u.)')
ylabel('Total translocation activity')
axis([0 45 0 100])
print(gcf,[basedir,'brightness_vs_activity(tot).eps'], '-depsc')




%% Looking at average behavior: dynamic features evident in population response
mod_colormap = divergingmap(0:1/(length(nfkb)-1):1,[12 12 77]/255,[158 4 0]/255);
figure
for i =1:length(nfkb)
    %metrics =  nfkbMetrics(nfkb(i).data,120,0);
    mean_activation = nanmean(nfkb(i).data);
    plot(0:1/12:(12*12)/12, mean_activation(1:145),'Color',mod_colormap(i,:),'LineWidth',2)
    hold on
end
hold off
xlabel('Time'),ylabel('Mean value above baseline')

figure
for i =1:length(nfkb)
    %metrics =  nfkbMetrics(nfkb(i).data,120,0);
     mean_activation = nanmean(nfkb(i).data);
    plot(0:1/12:51/12, mean_activation(3:54),'Color',mod_colormap(i,:),'LineWidth',2)
    hold on

    if (i ==7) || (i==3)
        plot([0 .5 1 2 4], mean_activation([3, 9, 15, 27, 50]),'.','MarkerSize',40,'Color',mod_colormap(i,:))
    end
end
hold off
xlabel('Time'),ylabel('Mean value above baseline')
axis([0 4.5 0 1.5])


%% - - - - Summary plot: 1st peak vs later activity - - - -
doses = nfkb(1).doses;
idxs = 1:length(nfkb);
mus = zeros(length(nfkb),2);
stds = zeros(length(nfkb),2);

for i = 1:length(nfkb)
    idx = idxs(i);
    metrics = nfkbMetrics(nfkb(idx).data,80,1);
    mus(i,1) = mean(metrics.pk1_integral);
    stds(i,1) = std(metrics.pk1_integral);
    mus(i,2) = mean(metrics.integral);
    stds(i,2) = std(metrics.integral);

end

stds(:,1) = stds(:,1);
stds(:,2) = stds(:,2);
x = 1;

figure
hold on;
set(gca,'ColorOrder',[colors.blue;colors.green]/x,'XTick',[0 2 4],'XTickLabel',{'1','100','10000'})
plot(log10(doses),mus,'.','MarkerSize',25);
errorbar(log10(doses),mus(:,1),stds(:,1),'--','Color',colors.blue/x,'LineWidth',2);
errorbar(log10(doses),mus(:,2),stds(:,2),'--','Color',colors.green/x,'LineWidth',2);
hold off
axis([-1 4 -1 60])
legend({'Primary activity','Total activity'})
%print(gcf,['/home/brooks/Dropbox/Presentations/ps+ai/2014-03_labmtg/primary-secondary.eps'], '-depsc')