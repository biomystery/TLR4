clear; clc; close all; 
addpath('../mcode/')
genotypes = {'mko','tko'};

n = 20;
alldose = linspace(-4,4,n); 
alldose = 10.^alldose;


hillCoeffient = [1 2:0.1:3.2];
hillCoeffient = 3; %[1 2:0.1:3.2];

timer = 1;
id.DT = .1;
id.sim_time = 240;

ikkPeakTmp = zeros(2,n);


for k = 1:numel(hillCoeffient)
    % reset block 
    id.inputP  = [hillCoeffient(k)]  % input parameters
    id.inputPid =  [19]; % experiment

    for j = 1:2 % different genotypes 
        id.genotype = genotypes{j};
        for i = 1:n
            id.dose = alldose(i); %'0.1 to 100','100' 
            id.output ={'IKK','NFkBn'};%{'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'
            sim{j,i}  = getSimData(id); %row vector
            [tmp b] = max(sim{j,i}(1,:));
            ikkPeakTmp(j,i) = tmp; 
            timer = (timer + 1);
            disp(timer/(n*2*numel(hillCoeffient))); 
        end
    end
    ikkPeak{k} = ikkPeakTmp;

    shuttleData{k} = sim;
end

%% 
save ./simData/simData.mat
fig3_plot