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
        id.dose = 10^alldose(i); %'0.1 to 100','100'
        id.output ={'IKK','NFkBn','IRF3ns'};%{'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'
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
!mv *.txt ./simData


%% plot
figure('position',[680   447   311   531])
load ./simData/dose_scan.mat
colors={[0 0 1],[0 1 0],[1 0 0]};
mulips={[1 1 0],[1 0 1],[0 1 1]};
colGrad = linspace(0.75,0,n);
times = 0:id.DT:240; 


for k = 1:2 % different genotypes     
    subplot(2,1,k)
    for j = 1:3
        for i=1:100
            plot(times,sim{j,i}(k,:),'color',colors{j}+mulips{j}*colGrad(i))
            hold on ;
        end
    end
    xlim([0 240])
    set(gca,'fontsize',16,'xtick',0:60:240,'xticklabel','','yticklabel','')
    title(id.output{k})
end

%legend('Both','TRIF pathway','MyD88 pathway','location','best') 

%% fig2B-D; duration, peak time and maxmium peak. 
figure 
%% figure S2
max_values = max(cell2mat(sim)');
min_values = min(cell2mat(sim)');
min_values = min(reshape(min_values,3,3)');
max_values = max(reshape(max_values,3,3)');

figure('position',[680   667   900   800])
for k = 1:3
    for j = 1:3
        
        subplot(3,3,j+(k-1)*3) 
        data = ones(n,2401);
        
        for i = 1:n
            data(i,:) = sim{j,i}(k,:); 
        end
        imagesc(data,[min_values(k) max_values(k)]);colormap(hot); ...
            colorbar;
        xlabel('Time (mins)');ylabel('LPS Dose (ng/ml)');
        set(gca,'Ydir','normal')
        title(strcat(genotypes{j},id.output{k}),'color','r')
        set(gca,'xtick',1:600:2401,'xticklabel',0:60:240,'ytick',1:33: ...
                100,'yticklabel',[0.1,1,10,100])
    end
end
saveas(gca,'figs2.fig') 
saveas(gca,'figs2.pdf')

%%
fig2_plot