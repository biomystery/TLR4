close all
load ./shuttle/shuttleModule.mat
figure('position',[30 30 1200 900]) % fig Endo TC for IKK
mutantName = {'wt','1','2','3','12','13','23','123'}; %shuttling

% subplot 221, time couses
colors={'b','g','r'};
ind=[3,4];
indf = [1 4];
Z = {};
Z{1} = zeros(length(shuttleData{3}{1,1}.simData{2}),100);
Z{2} = zeros(length(shuttleData{3}{1,1}.simData{2}),100);
Z{3} = zeros(length(shuttleData{3}{1,1}.simData{2}),100);

x = 0:240;
y = alldose

for k=1:1
    km =ind(k);

    for j = 1:3 % different genotypes     
        for i=1:100
            Z{j}(:,i)= shuttleData{km}{j,i}.simData{2};
        end
    end
end


%%

for i = 1:3
subplot(2,2,i)
imagesc(t(x),y,Z{i},[0 .12]);
colorbar
set(gca,'ydir','normal')

end

%%

figure
for i = 1:3
subplot(2,2,i)
surf(y,x,Z{i},'edgecolor','none','facecolor','interp');
end
