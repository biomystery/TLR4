function fig5_plot(wt) 



X= cell2mat(wt.nfkb');
n = numel(wt.nfkb) ;

% $$$ for i = 1:n
% $$$     X(i,:) = X(i,:)/max(X(i,:));
% $$$ end
IDX = kmeans(X,2);
%%
c1 = find(IDX == 1); 
c2 = find(IDX == 2); 

Xordered = X([c2;c1],:); 

%colormap(flipud(gray(13)))
figure('position',[30 30 900 900]) % fig Endo TC for IKK4
%subplot(2,2,2)
%imagesc(Xordered,[0 .1]); 
imagesc(X,[0 .1]); 

%Use this to generate a map:
mod_colormap = divergingmap(0:1/1023:1,[12 12 77]/255,[158 4 0]/255);

%And then just set it with this:
colormap(mod_colormap)

colorbar;
%ylim([0 500])
%xlim([0 240])
hold on
%plot([1 241], [100 100],'k','linewidth',2)
set(gca,'xtick',0:60:240*3,'xticklabel',0:12,'fontsize',16)
xlabel('Time (hours)')
plot(Xordered(2,:))


