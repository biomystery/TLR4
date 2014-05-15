load nfkb.mat
times = 0:5/60:12; 
figure
colors = colormap(jet(8));
for i = 1:8 
    %    subplot(3,3,i)
    a = nfkb(i).data; 
    names{i} = nfkb(i).name; 
    no_points = size(a,1);
    a_mean = nanmean(a);
    a_err = nanstd(a);

    size(a_mean)
% $$$     confplot(0:5/60:12,nanmean(a),nanstd(a), ...
% $$$              nanstd(a),'color',colors(i,:),'linewidth',2);
%    errorbar(times,a_mean,a_err,'color',colors(i,:))    
    plot(times,a_mean,'color',colors(i,:),'linewidth',2)        
    hold on 

    xlim([0 12])

end

hcb= colorbar; 
set(hcb,'YTick',1:8,'YTicklabel',nfkb(1).doses)
ylabel(hcb,'LPS (ng/ml)') 
