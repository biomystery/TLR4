clear; clc; close all;
addpath('../mcode/')
addpath(genpath('~/Dropbox/matlab'))


genotypes = {'wt','mko','tko'};
mutantName = {'Constituive','ligand-induce-LPS','ligand-induce'}; %shuttling mode
mutantValue = {[14, 15],[12:13],[2:3 12:13]};

n = 100;
alldose = linspace(-1,2,n); 
alldose = 10.^alldose;
ikklastTime = zeros(3,n);
nfkblastTime = zeros(3,n);

% 1. low dose, wt
% define the mutants in the shuttling module. 
timer = 1;
id.DT = 1;
id.sim_time =240; 

%%
for k = 2:size(mutantName,2)
    % reset block 
    id.inputP  = [zeros(numel(mutantValue{k}),1)];  % input parameters
    id.inputPid = [mutantValue{k}];
    id.inputvP = [];
    id.inputvPid = [];

    for j = 1:3 % different genotypes 
        id.genotype = genotypes{j};
        for i = 1:n
            id.dose = alldose(i); %'0.1 to 100','100' 
            id.output ={'IKK','NFkBn'};%{'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'
            sim{j,i}  = getSimData(id); %row vector
            
            indIkk = find(sim{j,i}.simData{1}>=1);
            indNfkb = find(sim{j,i}.simData{2}>=0.05);        
            ikklastTime(j,i) = length(indIkk);
            nfkblastTime(j,i) = length(indNfkb);
            timer = (timer + 1);
            disp(timer/(n*3*size(mutantName,2))); 
        end
    end
    shuttleData{k} = sim ;
end 
save ./simData/shuttleModule.mat shuttleData




