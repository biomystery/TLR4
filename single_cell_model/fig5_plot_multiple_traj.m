clear; close all; 
addpath('../mcode/') ;
load('./simData/single_cell_5_lognormal_delay_mt_scale1_lps.mat')

% selected ids 
ids_5ng = [55, 18 , 58, 59 , 85, 7, 74, 86];

% setting
savedir = ['./figs/'];
colors.green = [0 195 169]/255;
colors.blue = [29 155 184]/255;
colors.dark_blue = [62 107 133]/255;

h = figure('Position',[37, 50, 200, 70*numel(ids_5ng)],'PaperPositionMode','auto');
ha = tight_subplot(numel(ids_5ng),1,0.01);

t = (0:720)/60;
for i = 1:length(ids_5ng)
    plot(ha(i),t,both_vary.nfkb{ids_5ng(i)},'LineWidth',2,'Color',colors.dark_blue)
    set(ha(i),'XLim',[min(t),max(t)],'YLim',[-.01 .11],'xtick',0:5:10,'XTickLabel',{},'YTickLabel',{});
end

print(h,[savedir,'5ng_trajs_sim.eps'], '-depsc')
 

%% parameters

h2 = figure('Position',[37, 50, 200, 70*numel(ids_5ng)],'PaperPositionMode','auto');
ha = tight_subplot(numel(ids_5ng)*2,2,0.);

for i = 1:length(ids_5ng)
    %1 
    hist(ha((i-1)*4+1),both_vary.fdelay);
    xPos = both_vary.fdelay(ids_5ng(i));
    hold( ha((i-1)*4+1))
    plot(ha((i-1)*4+1),[xPos xPos],get(ha((i-1)*4+1),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
    % 2
    hist(ha((i-1)*4+2),both_vary.fm);
        xPos = both_vary.fm(ids_5ng(i));
    hold( ha((i-1)*4+2))
    plot(ha((i-1)*4+2),[xPos xPos],get(ha((i-1)*4+2),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
    % 3
    hist(ha((i-1)*4+3),both_vary.ft);
        xPos = both_vary.ft(ids_5ng(i));
    hold( ha((i-1)*4+3))
    plot(ha((i-1)*4+3),[xPos xPos],get(ha((i-1)*4+3),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
    % 4
   hist(ha((i-1)*4+4),both_vary.flps);
       xPos = both_vary.flps(ids_5ng(i));
    hold( ha((i-1)*4+4))
    plot(ha((i-1)*4+4),[xPos xPos],get(ha((i-1)*4+4),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
end  
 
    set(ha,'XTickLabel',{},'YTickLabel',{},'box','off');
print(h2,[savedir,'5ng_trajs_pars.eps'], '-depsc')


%%
load('./simData/single_cell_5000_lognormal_delay_mt_scale1_lps.mat')

ids_5ug = [71, 29 , 21, 142 , 246, 70, 2, 1];


h = figure('Position',[37, 50, 200, 70*numel(ids_5ug)],'PaperPositionMode','auto');
ha = tight_subplot(numel(ids_5ug),1,0.01);

t = (0:720)/60;
for i = 1:length(ids_5ug)
    plot(ha(i),t,both_vary.nfkb{ids_5ug(i)},'LineWidth',2,'Color',colors.green)
    set(ha(i),'XLim',[min(t),max(t)],'YLim',[-.01 .11],'xtick',0:5:10,'XTickLabel',{},'YTickLabel',{});
end

 print(h,[savedir,'5ug_trajs_sim.eps'], '-depsc')
 
 %% pars

h2 = figure('Position',[37, 50, 200, 70*numel(ids_5ng)],'PaperPositionMode','auto');
ha = tight_subplot(numel(ids_5ng)*2,2,0.);

for i = 1:length(ids_5ug)
    %1 
    hist(ha((i-1)*4+1),both_vary.fdelay);
    xPos = both_vary.fdelay(ids_5ug(i));
    hold( ha((i-1)*4+1))
    plot(ha((i-1)*4+1),[xPos xPos],get(ha((i-1)*4+1),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
    % 2
    hist(ha((i-1)*4+2),both_vary.fm);
        xPos = both_vary.fm(ids_5ug(i));
    hold( ha((i-1)*4+2))
    plot(ha((i-1)*4+2),[xPos xPos],get(ha((i-1)*4+2),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
    % 3
    hist(ha((i-1)*4+3),both_vary.ft);
        xPos = both_vary.ft(ids_5ug(i));
    hold( ha((i-1)*4+3))
    plot(ha((i-1)*4+3),[xPos xPos],get(ha((i-1)*4+3),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
    % 4
   hist(ha((i-1)*4+4),both_vary.flps);
       xPos = both_vary.flps(ids_5ug(i));
    hold( ha((i-1)*4+4))
    plot(ha((i-1)*4+4),[xPos xPos],get(ha((i-1)*4+4),'ylim'),'r','linewidth',4); % Adapts to x limits of current axes
    hold off
end  
 
set(ha,'XTickLabel',{},'YTickLabel',{},'box','off');
print(h2,[savedir,'5ug_trajs_pars.eps'], '-depsc')

