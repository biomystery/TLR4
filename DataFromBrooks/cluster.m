load nkfb.mat

figure

a = nfkb(9).data; 
opts = statset('Display','final');
[cidx, ctrs] = kmeans(a,2, ...
                      'Replicates',5, 'Options',opts);

plot(a(cidx==1,1),a(cidx==1,2),'r.', ...
     a(cidx==2,1),a(cidx==2,2),'b.', ctrs(:,1),ctrs(:,2),'kx');

figure
imagesc([a(cidx==1,:);a(cidx==2,:)],[0.5 3]);colorbar;
set(gca,'xtick',0:12:145,'xticklabel',0:12)

