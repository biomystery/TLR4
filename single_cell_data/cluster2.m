
load nfkb.mat
%addpath(genpath('~/Dropbox/matlab'))

opts = statset('Display','final');
n = 4;
range = [-0.3 3.2];
for id =1:8
    if id==1
        n=2;
    else
        n=4;
    end
    
    a = nfkb(id).data; 


    [cidx, ctrs] = kmeans(a,n, ...
                          'Replicates',5, 'Options',opts);

    fraction = sum(isnan(cidx))/size(cidx,1);
    new_ind =[];

    h = figure
    for i =n:-1:1
        %new_ind = [new_ind;find(cidx==i)];
        subplot(n,2,i*2-1)
        imagesc(a(find(cidx==i),:),range);
        set(gca,'xtick',0:12:145,'xticklabel',0:12)
        
        subplot(n,2,i*2)
        %confplot(0:5/60:12,mean(a(find(cidx==i),:)),std(a(find(cidx==i),: ...
        %                                                )), ...
        %         std(a(find(cidx==i),:)),'color',[1 0 0],'linewidth',2);
        set(gca,'xtick',0:12,'xticklabel',0:12)
        xlim([0 12])
        ylim(range)

    end
    
    title(nfkb(id).name,'Interpreter','none')

    saveas(gca,strcat(nfkb(id).name,'.fig'))

    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    %print(h,strcat(nfkb(id).name,'.pdf'),'-dpdf','-r0')

end





