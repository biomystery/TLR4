%% Initial setting 
clc;clear;
addpath('../mcode/') ;

% initial id
id.DT = 1; 
[np,iptmp] = getRateParams();
id.inputPid = [18 22]; % experiment

id.inputvPid = [10,30:32]; % np
id.inputvP = [10;np([30:32])*.1];

id.output ={'IKK','IRF3ns','NFkBn'};
id.dose = 100*5;
id.sim_time = 240*3;
cell_number = 100; 

%% 1. both vary

id.genotype = 'wt';
fm = zeros(cell_number,1);ft=fm;

figure 
title('5 nM LPS, single cell simulations') 
for i = 1:cell_number
    disp(i)
    fm(i) = 10^(rand-0.5)*2; ft(i) =10^(rand-0.5)*2;
    id.inputP  = [iptmp(18)*fm(i)  iptmp(22)*ft(i)];  % input parameters
    simData = getSimData(id);
    
    % save species in struct mko
    both_vary.ikk{i}      = simData(1,:);
    both_vary.irf{i}      = simData(2,:);
    both_vary.nfkb{i}     = simData(3,:);
    
    subplot 311
    plot(both_vary.ikk{i},'r');
    hold on 
    drawnow
    subplot 312
    plot(both_vary.irf{i},'g');
    hold on 
    drawnow
    subplot 313
    plot(both_vary.nfkb{i},'b');
    hold on 
    drawnow
end
both_vary.fm = fm;
both_vary.ft = ft;
save('./simData/both_vary_single_cell_500ng.mat','both_vary')


fig5_plot(both_vary)