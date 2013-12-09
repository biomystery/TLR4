function insilico=objSingleCheck(id)

% get sim data & expdata
insilico.output = id.output; 
insilico.dose = id.dose;
insilico.output = id.output;
insilico.genotype = id.genotype; 

sim = getSimData(id);

if numel(id.output)==1
    insilico.expData = getExpData(id.output{:},id.genotype,id.dose);
    insilico.simData = sim;
elseif numel(id.output)>1
    for i=1:numel(id.output)
        insilico.expData{i} = getExpData(id.output{i},id.genotype,id.dose);
        insilico.simData{i} =sim(i,:);
    end
else
    error('func:getSim','Wrong output id nubmer');
end
end
