load nkfb.mat
times = 0:5/60:12; 
figure
colors = colormap(jet(9));
for i = 1:9 
    %    subplot(3,3,i)
    a = nfkb(i).data; 
    names{i} = nfkb(i).name; 
    no_points = size(a,1);
    a_mean = nanmean(a);
    a_err = nanstd(a);

    size(a_mean)
    plot(times,a_mean,'color',colors(i,:))
    hold on 
    xlim([0 4])

end

hcb= colorbar; 
set(hcb,'YTick',1:9,'YTicklabel',names) 
