addpath('../mcode')
id.DT = 1;     
id.sim_time =240; 
%% wt simulation
id.genotype = 'wt';

% 1. low dose, wt
id.dose = 1; %'1','100' 
id.output ={'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'
sim{1}  = getSimData(id); % 1 ng/ml LPS

% 2. high dose, wt
id.dose = 100; %'1','100'
sim{2}  = getSimData(id); % 100 ng/ml LPS 

%% KOs

% 3&4. mko, hi & Low
id.genotype = 'mko';
sim{3}  = getSimData(id);
id.dose = 1;
sim{4}  = getSimData(id);

%5&6, tko, hi & low
id.genotype = 'tko';
sim{5}  = getSimData(id);
id.dose = 100;
sim{6}  = getSimData(id);

%% normalize sim data: normalized to the timepoint of the
%% simerimental timepoint. 
ikknorm  = max(sim{2}(1,:)); %wt,100
irfnorm = max(sim{2}(2,:));
nfkbnorm  = max(sim{2}(3,:));

for i = 1:6
    sim{i}(1,:)=sim{i}(1,:)/ikknorm;
    sim{i}(2,:)=sim{i}(2,:)/irfnorm;
    sim{i}(3,:)=sim{i}(3,:)/nfkbnorm;
end

%% simort files.
% wirte the wt ikk file 
csvwrite('./simData/ikk.csv',[0:240;sim{1}(1,:);0:240;sim{2}(1,:)]'); %wt,ikk

% ko sim

csvwrite('./simData/ikkKoSim.csv',[0:240;sim{3}(1,:);0:240;sim{4}(1,:);0:240;sim{5}(1,:);0:240;sim{6}(1,:)]'); %wt,ikk


csvwrite('./simData/nfIRF.csv',[sim{1}(2,:);sim{1}(3,:); ...
                    sim{2}(2,:);sim{2}(3,:)])

% 1:2 low irf; 3:4 low nfkb; 5:6 high irf; 7:8 high nfkb

