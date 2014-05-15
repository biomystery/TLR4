
load nfkb.mat
addpath(genpath('~/Dropbox/matlab'))

opts = statset('Display','final');
%range = [-0.3 2.0];
range = [0 2.0];


for id =1:8
    h= figure
    a = nfkb(id).data; 
    imagesc(a,range);
    %Use this to generate a map:
    mod_colormap = divergingmap(0:1/1023:1,[12 12 77]/255,[158 4 0]/255);

    %And then just set it with this:
    colormap(mod_colormap)

    colorbar; 
    set(gca,'xtick',0:12:145,'xticklabel',0:12,'fontsize',16)
    
    title(nfkb(id).name,'Interpreter','none')
    
    saveas(gca,strcat(nfkb(id).name,'a.fig'))
    saveas(gca,strcat(nfkb(id).name,'a.pdf'))
    
    

end
% $$$ saveas(gca,'no_cluster.fig')
% $$$ set(h,'Units','Inches');
% $$$ pos = get(h,'Position');
% $$$ set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
% $$$ print(h,'no_cluster.pdf','-dpdf','-r0')
% $$$ 
% $$$ 



