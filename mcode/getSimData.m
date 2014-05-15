function simData=getSimData(id)
%% construct and passing parameters
v=struct;
[v.NP,v.IP] = getRateParams();%wt
v.D_FLAG=0; % display flag
v.P_FLAG=0; % plot flag
v.L_FLAG=0; % Legend turn on or off
v.DT = id.DT;

% update parameter
if isfield(id,'inputPid')
    v.IP(id.inputPid) =id.inputP;
end
if isfield(id,'inputvPid')
    v.NP(id.inputvPid) =id.inputvP;

end

% total time
v.SIM_TIME     = id.sim_time; % min of stimulation phase (phase 2)v.GENOTYPE = id.genotype;
v.LPS_DOSE = id.dose*v.IP(52);
v.INITVALUES = getInit();



% mutant 
switch id.genotype
  case 'mko'
    v.INITVALUES{1}(25)=0; %myd88
  case 'tko'
    v.INITVALUES{1}(27)=0;
  case 'wt'
    v.IP(24:25) = v.IP(49:50);
end

% Run
v  = nfkbRunPar(v) ;

%% return
if numel(id.output)==1
    index =find(strcmp(v.INITVALUES{2}(:),id.output));
    simData =v.OUTPUT(:,index)';
elseif numel(id.output)>1
    for i=1:numel(id.output)
        index(i) =find(strcmp(v.INITVALUES{2}(:),id.output{i}));
    end
    simData =v.OUTPUT(:,index)';
else
    error('func:getSim','Wrong output id nubmer');
end