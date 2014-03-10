figure
colors = colormap(jet(9));
for i = 1:9 
    subplot(3,3,i)
    a = nfkb(i).data; 
    no_points = size(a,1);
    a_mean = nanmean(a);
    a_err = nanstd(a);

    size(a_mean)
    errorbar(times,a_mean,a_err,'color',colors(i,:))
    hold on 
    xlim([0 4])
    title(nfkb(i).name,'Interpreter','none')
end

%hcb= colorbar; 
%set(hcb,'YTick',1:9,'YTicklabel',names) 
