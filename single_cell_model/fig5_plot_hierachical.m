
filenames ={'./simData/single_cell_.5_lognormal_delay_mt_scale1_lps.mat','./simData/single_cell_5_lognormal_delay_mt_scale1_lps.mat','./simData/single_cell_50_lognormal_delay_mt_scale1_lps.mat','./simData/single_cell_5000_lognormal_delay_mt_scale1_lps.mat'}

load('../single_cell_data/nfkb.mat')
doses = [1 3 5 8];
mod_colormap = divergingmap(0:1/1023:1,[12 12 77]/255,[158 4 0]/255);
mod_colormap(1,:) = [0.1 0.1 0.1];
fig1 = figure('Position',[490   710   402   650],'PaperPositionMode','auto');
ha = tight_subplot(4,1);colormap(mod_colormap)


for i = 1:4 
    load(filenames{i})

    data1= cell2mat(both_vary.nfkb');
    data1 = data1(1:(size(nfkb(i).data,1)),:);
    
    order1 = hierarchial(data1,0);
    data1 = data1(order1,:);
    imagesc(data1(round(linspace(1,size(data1,1),200)),1:541),'Parent',ha(i))
    set(ha(i),'CLim',[0 0.1],'XTick',1:180:541,'YTick',[],'XTickLabel',{},'Box','off','TickDir','out') 
    if i ==length(doses)
           set(ha(i),'XTickLabel',{'0', '3', '6', '9', '12'})
    end
end

print(fig1,['./figs/','subfig_2a_sim.eps'], '-depsc')