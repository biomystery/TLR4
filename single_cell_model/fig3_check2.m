addpath('../mcode/')

% $$$ id.output = {...
% $$$     'IkBa','IkBan','IkBaNFkB','IkBaNFkBn','IkBat', ... % 1-5
% $$$     'IkBb','IkBbn','IkBbNFkB','IkBbNFkBn','IkBbt', ... % 6-10
% $$$     'IkBe','IkBen','IkBeNFkB','IkBeNFkBn','IkBet', ... % 11-15
% $$$     'NFkB','NFkBn',                                ... % 16-17
% $$$     'LPSo','LPS','LPSen','TLR4','TLR4en',          ... % 18-22
% $$$     'TLR4LPS','TLR4LPSen','MyD88','MyD88s','TRIF', ... % 23-27,MyD88s means M6
% $$$     'TRIFs','TRAF6','TRAF6s','IKKK_off','IKKK',    ... % 28-32
% $$$     'IKK_off','IKK','IKK_i','TBK1','TBK1s'         ... % 33-37
% $$$     'IRF3','IRF3s','IRF3n','IRF3ns'              ... % 38-41
% $$$              };
id.output = {'IKK','NFkBn'};

id.genotype = 'wt';
id.dose = 100; 
[np,ip] = getRateParams();
id.DT = 1; 
id.sim_time = 60*12;

id.inputvPid = [10,27:32]; % np
id.inputvP = [0;np([27:32])];
id.inputPid = [49:52]; % experiment
id.inputP  = [ip(49:50)*5;1;1];

N = 8; 
val = [.5,1,5,20,35,500,1000,5000];
%val = linspace(.1,1,10);

time_seq = 0:id.DT:id.sim_time; 

h = figure('units','inch','position',[ 9.4306    9.1944   13.9722    4.2639*2])
clf
colors = colormap(jet(N))
for j = 1:N
    id.dose = val(j);
    sim = getSimData(id); 

    for i = 1:2;
        subplot(2,1,i)
        plot(time_seq,sim(i,:),'color',colors(j,:),'linewidth',2)
        hold on 
        drawnow
        xlim([0 60*12])
        set(gca,'xtick',0:60:60*12,'xticklabel',0:12)
    end
end
for i =1:2
    subplot(2,1,i)
    hcb= colorbar; 
    set(hcb,'YTick',1:8,'YTicklabel',val)
    ylabel(hcb,'LPS (ng/ml)') 
 end


 saveas(gca,'./figs/delay0_np27to32_1_ip49to50_5_dosescan_IKKscale1_LPSscale1.fig')
 
 set(h,'Units','Inches');
 pos = get(h,'Position');
 set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
 print(h,'./figs/delay0_np27to32_1_ip49to50_5_dosescan_IKKscale1_LPSscale1.pdf','-dpdf','-r0')
 open './figs/delay0_np27to32_1_ip49to50_5_dosescan_IKKscale1_LPSscale1.pdf'
 