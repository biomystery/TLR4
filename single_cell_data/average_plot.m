figure
colors = colormap(jet(8));
for i = 1:8
    subplot(3,3,i)
    a = nfkb(i).data; 
    no_points = size(a,1);
    a_mean = nanmean(a);
    a_err = nanstd(a);

    size(a_mean)
    confplot(0:5/60:12,nanmean(a),nanstd(a), ...
             nanstd(a),'color',colors(i,:),'linewidth',2);

    %    errorbar(times,a_mean,a_err,'color',colors(i,:))
    hold on 
    xlim([0 12])
    ylim([0 3.8])
    title(nfkb(i).name,'Interpreter','none')
end

%hcb= colorbar; 
%set(hcb,'YTick',1:9,'YTicklabel',names) 
