x = 0:0.01:1; 

hill = @(x,n) x.^n./(x.^n + 0.5^n);

figure
N = 10;
colors = jet(N); 
n_all = linspace(1,3,N); 
for i=1:N
    plot(x,hill(x,n_all(i)),'color',colors(i,:))
    hold on;
end 
set(gca,'fontsize',16)
grid on ;
set(gca,'xtick',0:.5:1)
xlabel('x')
ylabel('x^n/(x^n+0.5^n)')

h = colorbar('peer',gca)
colormap(jet(N))
set(get(h,'ylabel'),'string','n','fontsize',16)
set(h,'ytick',1:10,'yticklabel',n_all)

saveas(gca,'check_hill.fig') 
saveas(gca,'check_hill.pdf') 
