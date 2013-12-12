%% settings. 
clear; clc; close all;
addpath('../mcode/')
genotypes = {'wt','mko','tko'};

n = 100; % number of points. 
alldose = linspace(-1,2,n);

timer = 1;
id.DT = 0.1;
id.sim_time = 240;


%% run the simulation 
for j = 1:3 % different genotypes
    id.genotype = genotypes{j};
    for i = 1:n
        id.dose = alldose(i); %'0.1 to 100','100'
        id.output ={'IKK','NFkBn'};%{'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'
        sim{j,i}  = getSimData(id); %row vector
        disp(timer/(n*3));
        timer = timer + 1;
    end
end

%% save the data
save ./simData/dose_scan.mat 

file_names ={'ikk_wt_dosescan.txt','ikk_mko_dosescan.txt', ...
             'ikk_tko_dosescan.txt';'nfkb_wt_dosescan.txt', ...
             'nfkb_mko_dosescan.txt','nfkb_tko_dosescan.txt'} ; 
for i = 1:2 % output ikk or nfkb
    for j = 1:3 % genotype
        fid = fopen(file_names{i,j},'w');
        k = 1; % dose
        data = [(0:240);  ones(1,241)*alldose(k); sim{j}(i,:)];
        fprintf(fid,'%f %f %f\n',data);
        fclose(fid);
        
        fid = fopen(file_names{i,j},'a');
        for k = 2:100 % dose
            data = [(0:240);  ones(1,241)*alldose(k); sim{j}(i,:)];
            fprintf(fid,'%f %f %f\n',data);
        end
        fclose(fid);
    end
end

%% 
!mv *.txt ./simData


%% plot
colors={[0 0 1],[0 1 0],[1 0 0]};
mulips={[1 1 0],[1 0 1],[0 1 1]};
colGrad = linspace(0.75,0,n);

for j = 1:3 % different genotypes     
    for i=1:100
        plot(sim{j,i}(2,:),'color',colors{j}+mulips{j}*colGrad(i))
        hold on ;
    end
end
plot([0 240],[0.05 0.05],'--k','linewidth',2)
xlim([0 240])
set(gca,'fontsize',16,'xtick',0:60:240,'xticklabel','','yticklabel','')
xlabel('Time (mins)')
ylabel('NFkBn (uM)')
title('NFkBn')
%legend('Both','TRIF pathway','MyD88 pathway','location','best') 

