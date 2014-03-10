function [pt,hpt]=findPeakHalf(simData,id)
[a b] =max(simData);
for ii =1:(numel(id.timespan)-1)
    if(simData(ii)<a/2 && simData(ii+1)>a/2)
        hpt= (ii-1)*id.DT; %half-peak time
    end
end
pt = (b-1)*id.DT; %peak time
end
