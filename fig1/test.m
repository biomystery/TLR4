addpath('../mcode')
id.DT = 1;     
id.sim_time =60*12; 
%% wt simulation
id.genotype = 'mko';

% 1. low dose, wt
id.dose = 0.01; %'1','100' 
id.output ={'IKK','IRF3ns','NFkBn'}; %'IKK','nfkb','irf'

[np ip]= getRateParams();

% $$$  v.inputPid =51;
% $$$  v.inputP = 1; 
id.inputvPid =[4:6 10];
id.inputvP = [np(4:6);37]; 

sim{1}  = getSimData(id); % 1 ng/ml LPS

% 2. high dose, wt
id.dose = 100; %'1','100'
sim{2}  = getSimData(id); % 100 ng/ml LPS 



%% plot
h= figure
subplot(2,2,1)
plot(sim{1}(1,:)/(.1*ip(51)),'k')
xlim([0 id.sim_time])
set(gca,'xtick',0:120:id.sim_time)
title('1ng/ml LPS')
ylabel('IKK flux')
xlabel('Time (min)') 

subplot(2,2,2)
plot(sim{1}(3,:),'k')
xlim([0 id.sim_time])
ylim([0 0.125])
set(gca,'xtick',0:120:id.sim_time)

title('1ng/ml LPS')
ylabel('NFkBn')
xlabel('Time (min)') 

subplot(2,2,3)
plot(sim{2}(1,:)/(.1*ip(51)),'k')
xlim([0 id.sim_time])
set(gca,'xtick',0:120:id.sim_time)
title('100 ng/ml LPS')
ylabel('IKK flux')
xlabel('Time (min)') 

subplot(2,2,4)
plot(sim{2}(3,:),'k')
xlim([0 id.sim_time])
ylim([0 0.125])
set(gca,'xtick',0:120:id.sim_time)
title('100 ng/ml LPS')
ylabel('NFkB')
xlabel('Time (min)') 

%%
saveas(gca,'test1.fig')

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'test1.pdf','-dpdf','-r0')
