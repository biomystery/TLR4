
load nkfb.mat
addpath(genpath('~/Dropbox/matlab'))

opts = statset('Display','final');
n = 6;
for id =1:9

    a = nfkb(id).data; 


    [cidx, ctrs] = kmeans(a,n, ...
                          'Replicates',5, 'Options',opts);

    fraction = sum(isnan(cidx))/size(cidx,1);
    new_ind =[];

    h = figure('position',[10 10 1200 900])
    for i =n:-1:1
        %new_ind = [new_ind;find(cidx==i)];
        subplot(n,2,i*2-1)
        imagesc(a(find(cidx==i),:),[0.5 3]);
        set(gca,'xtick',0:12:145,'xticklabel',0:12)
        
        subplot(n,2,i*2)
        confplot(0:5/60:12,mean(a(find(cidx==i),:)),std(a(find(cidx==i),: ...
                                                          )), ...
                 std(a(find(cidx==i),:)),'color',[1 0 0],'linewidth',2);
        set(gca,'xtick',0:12,'xticklabel',0:12)
        xlim([0 12])
        ylim([0.5 3])

    end
    
    title(nfkb(id).name,'Interpreter','none')

    saveas(gca,strcat(nfkb(id).name,'.fig'))

    set(h,'Units','Inches');
    pos = get(h,'Position');
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,strcat(nfkb(id).name,'.pdf'),'-dpdf','-r0')

end





