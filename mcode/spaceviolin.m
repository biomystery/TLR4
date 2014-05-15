function [] = spaceviolin(vects, places, colors, graph_limits, show_bins, width, bin_scale) 
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
% SPACEVIOLIN makes a violin plot, spacing them according to a secondary vector (e.g. doses)
%
% [] = spaceviolin(vects, places, (show_bins), (width), (bin_scale)) 
%
% vects          1xN cell array of vectors (1-D array of object measurements)
% places         1xN array directing placement of each Violin
% colors         1x... cell vector specifying violin fill colors - cycles if length < N
% graph_limits   2 element vector with graph y-limits
% show_bins    (opt) create subplot showing histogram of each population, and spline-fit line
% width        (opt) width-scaling for each violin - default is 0.5
% bin_scale    (opt) scale num. of bins calculated by Freedman–Diaconis Rule - default=1
%
%- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if nargin<5
    bin_scale = 1;
    if nargin<4
        width = 0.5;
        if nargin<3
            show_bins = 0;
        end
    end
end

% Calculate bin sizes
all = cell2mat(vects(:));
IQR = iqr(all);
avg_size = length(all)/length(vects);
bin_width = 2*bin_scale*IQR/(avg_size^(1/3));
medians = zeros(size(vects));


% Make figures
if show_bins % Diagnostic output: histogram overlaid with spline fit
    figure('Position',[500,357, 350 100*length(vects)])
    diagnos = tight_subplot(length(vects),1);
end
figure('Position', [500, 1031, 800, 300], 'PaperPositionMode','auto')
violin = axes; % Violin-figure output

% Loop through sets
for i = 1:length(vects)
    % Generate histogram data
    x = min(vects{i}):bin_width:max(vects{i});
    h = hist(vects{i},x);
    medians(i) = median(vects{i});
    
    % Cap histogram with zero values (keep spline from spiking @ end) and spline-interpolate
    x = [min(x)-bin_width, x, max(x)+bin_width];
    y = [0 h/sum(h) 0];
    xx = min(x):bin_width/100:max(x);
    yy = spline(x, y, xx);
    yy(yy<0) = 0;
    
    % Show subplot of bins+spline fit
    if show_bins
        hold(diagnos(i),'on')
        bar(diagnos(i),x,y,'FaceColor',[45 191 104]/255,'EdgeColor','none')
        set(diagnos(i),'XLim',graph_limits,'YLim',[0 .5])
        plot(diagnos(i),xx,yy,'LineWidth',2,'Color',[0 0 0])
        hold(diagnos(i),'off')
    end

    % Make main violin plot
    hold(violin,'on')
    fill([places(i)+width*yy,places(i)-width*yy(end:-1:1)],[xx,xx(end:-1:1)],...
        colors{mod(i-1,length(colors))+1},'LineWidth',2)
    hold(violin,'off')
end

% Plot medians and set graph properties
hold(violin,'on')
    plot(violin, places,medians,'--o','MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],...
        'Color', [0 0 0],'LineWidth',2,'MarkerSize',8)
hold(violin,'off')
set(violin,'YLim',graph_limits);
