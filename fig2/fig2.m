%% settings. 
clear; clc; close all;
addpath('../mcode/')
genotypes = {'wt','mko','tko'};

n = 100; % number of points. 
alldose = linspace(-1,3,n);

timer = 1;
id.DT = 0.1;
id.sim_time = 240;


% run the simulation 
for j = 1:3 % different genotypes
    id.genotype = genotypes{j};
    for i = 1:n
        id.dose = 10^alldose(i); %'0.1 to 100','100'
        id.output ={'IKK','NFkBn','IRF3ns'};%{'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'
        sim{j,i}  = getSimData(id); %row vector
        disp(timer/(n*3));
        timer = timer + 1;
    end
end

% save the data
save ./simData/dose_scan.mat 
%%
file_names ={'ikk_wt_dosescan.txt','ikk_mko_dosescan.txt', ...
             'ikk_tko_dosescan.txt';'nfkb_wt_dosescan.txt', ...
             'nfkb_mko_dosescan.txt','nfkb_tko_dosescan.txt'} ; 
for i = 1:2 % output ikk or nfkb
    for j = 1:3 % genotype
        fid = fopen(file_names{i,j},'w');
        k = 1; % dose
        data = [(0:240);  ones(1,241)*alldose(k); sim{j}(i,1:1/id.DT:end)];
        fprintf(fid,'%f %f %f\n',data);
        fclose(fid);
        
        fid = fopen(file_names{i,j},'a');
        for k = 2:100 % dose
            data = [(0:240);  ones(1,241)*alldose(k); sim{j}(i,1:1/id.DT:end)];
            fprintf(fid,'%f %f %f\n',data);
        end
        fclose(fid);
    end
end

% 
%!mv *.txt ./simData







%%
fig2s_plot
fig2_plot