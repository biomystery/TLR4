%% Initial setting 
clc;clear;
addpath('../mcode/') ;

% initial id
id.DT = 1; 
[~,iptmp] = getRateParams();
id.inputPid = [18 22]; % experiment

id.output ={'IKK','IRF3ns','NFkBn'};
id.dose = 100;
id.sim_time = 240;

%% 1. both vary

id.genotype = 'wt';
fm = zeros(1000,1);ft=fm;

for i = 1:1000
    disp(i)
    fm(i) = rand; ft(i) =rand;
    id.inputP  = [iptmp(18)*fm(i)  iptmp(22)*ft(i)];  % input parameters
    simData = getSimData(id);
    
    % save species in struct mko
    both_vary.ikk{i}      = simData(1,:);
    both_vary.irf{i}      = simData(2,:);
    both_vary.nfkb{i}     = simData(3,:);
end
both_vary.fm = fm;
both_vary.ft = ft;
save('./simData/both_vary.mat','both_vary')


%% 2. fm vary
for i = 1:1000
    disp(i)
    fm(i) = rand; ft(i) =rand;
    id.inputP  = [iptmp(18)*fm(i)  iptmp(22)];  % input parameters
    simData = getSimData(id);
    
    % save species in struct mko
    fm_vary.ikk{i}      = simData(1,:);
    fm_vary.irf{i}      = simData(2,:);
    fm_vary.nfkb{i}     = simData(3,:);
end
fm_vary.fm = fm;
fm_vary.ft = ft;
save('./simData/fm_vary.mat','fm_vary')

%% 2. ft vary
for i = 1:1000
    disp(i)
    fm(i) = rand; ft(i) =rand;
    id.inputP  = [iptmp(18)  iptmp(22)*ft(i)];  % input parameters
    simData = getSimData(id);
    
    % save species in struct mko
    ft_vary.ikk{i}      = simData(1,:);
    ft_vary.irf{i}      = simData(2,:);
    ft_vary.nfkb{i}     = simData(3,:);
end
ft_vary.fm = fm;
ft_vary.ft = ft;
save('./simData/ft_vary.mat','ft_vary')


