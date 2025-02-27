function v = nfkbSim(v)
%% intro
% The simulation is run in 2 phases
%   1. An equilibrium phase.  This runs in increments of START_TIME
%       (by default 4000min) until there is no change > 1%
%   2. A stimulation phase. This runs from 0 to SIM_TIME minutes

%% Call the ODE function to reset the persistent variables
nfkbOde([],[],[],v);

%% Run Phase 2
if v.SIM_TIME > 0
    screen('Phase 2',v.D_FLAG);
    v.PHASE         = 2;
    initial_values  = v.BASAL_VALUES;
    initial_values(18)  = v.LPS_DOSE; % LPS dose set
    
    
    % LPS chronic
    screen('LPS chronic treatment',v.D_FLAG);
    [t2, r2] = ode15s('nfkbOde', [0 v.SIM_TIME],initial_values,[],v);
    
    
    % Interpolate Phase 2 Results
    %   This makes an array of length SIM_TIME+1 with per min values
    v.OUTPUT = interp1(t2,r2(:,:),0:v.DT:v.SIM_TIME);
end
end