%% Initial setting 
clc;clear;
addpath('../mcode/') ;

% initial id
id.DT = 1; 
[np,iptmp] = getRateParams();
id.inputPid = [18 22 52 1]; % experiment

id.inputvPid = [10,30:32]; % np
id.inputvP = [10;np([30:32])*.1];

id.output ={'IKK','IRF3ns','NFkBn'};
id.dose = 50;
id.sim_time = 240*3;
cell_number = 500; 

%% 1. both vary

id.genotype = 'wt';
fdelay = zeros(cell_number,1);
fm = zeros(cell_number,1);
ft = zeros(cell_number,1);
flps = zeros(cell_number,1);

mu=0;sigma=0.2;sigma2=0.5;

figure 

for i = 1:cell_number
    disp(i)
    fdelay(i) = 10^(normrnd(mu,sigma)); 
    fm(i) = 10^(normrnd(mu,sigma)); 
    ft(i) = 10^(normrnd(mu,sigma));     
    flps(i) = 10^(normrnd(mu,sigma2));     
    id.inputP  = [iptmp(18)*fm(i)  iptmp(22)*ft(i) 1 iptmp(1)*flps(i)];
    id.inputvP(1) = 10 * fdelay(i); 
    
    simData = getSimData(id);
    
    % save species in struct mko
    both_vary.ikk{i}      = simData(1,:);
    both_vary.irf{i}      = simData(2,:);
    both_vary.nfkb{i}     = simData(3,:);
    
    subplot 311
    plot(both_vary.ikk{i},'r');
    hold on 
    xlim([0 720])
    set(gca,'xtick',0:60:720,'xticklabel',0:12)
    
    drawnow

    subplot 312
    plot(both_vary.irf{i},'g');
    xlim([0 720])
    set(gca,'xtick',0:60:720,'xticklabel',0:12)

    hold on 
    drawnow
    subplot 313
    plot(both_vary.nfkb{i},'b');
    xlim([0 720])
    set(gca,'xtick',0:60:720,'xticklabel',0:12)

    hold on 
    drawnow
end
both_vary.fdelay = fdelay;
both_vary.fm = fm;
both_vary.ft = ft;
both_vary.flps = flps;


both_vary.mean = [mean(cell2mat(both_vary.ikk')); ...
                  mean(cell2mat(both_vary.irf'));mean(cell2mat(both_vary.nfkb'))];

for i = 1:3
subplot(3,1,i) 
plot(both_vary.mean(i,:),'k','linewidth',2)
xlim([0 720])
set(gca,'xtick',0:60:720,'xticklabel',0:12)
end 
saveas(gca,'single_cell_50_lognormal_delay_mt_scale1_lps.fig')
saveas(gca,'single_cell_50_lognormal_delay_mt_scale1_lps.pdf')


save('./simData/single_cell_50_lognormal_delay_mt_scale1_lps.mat','both_vary')


fig5_plot(both_vary)