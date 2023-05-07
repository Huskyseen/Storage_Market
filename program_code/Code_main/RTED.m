function Rout = RTED(D, c1, c2, g0, gMax, gMin, rMax, u, v, z, W, e0, P, E, eta, cES, Vk, Ve, Vb, Tw)
%%
% All vectors should be formulated with column numbers for different time
% periods, roll numbers for different units
% D - demand profile
% c1 - first order generation cost
% c2 - second order generation cost
% g0 - initial generation
% gMax - gen Max
% gMin - gen Min
% rMax - ramp limit
% u - generation on if 1, from DAUC
% v - generator up if 1, from DAUC
% z - generator down if 1, from DAUC
% W - wind profile
% e0 - initial SoC
% P - Power rating
% E - energy rating
% eta - efficiency
% cES - storage discharge cost
% Vk - first order coef for storage value function at end of period
% Ve - value function SoC samples
% Vb - zero order coef for storage value function at end of period
% Tw - window of economicdispatch

tic;

Ne = size(P,1); % only consider one storage
Ng = size(g0,1); % read number of generators
Ns = numel(Vk); % storage opportunity value segments

%% define variables
p_c = sdpvar(Ne,Tw); % storage charge power
p_d = sdpvar(Ne,Tw); % storage discharge power
e = sdpvar(Ne,Tw); % SoC 
es_cost = sdpvar(Ne,1); % storage opportunity cost at the end time horizon
g = sdpvar(Ng,Tw); % generator output
w = sdpvar(1,Tw); % wind input

qU = sdpvar(1,Tw); % emergency generator / load shedding
qD = sdpvar(1,Tw); % emergency generator / load shedding

%% generator Min and Max
g_limit = [gMin * ones(1,Tw) .* u <= g <= gMax * ones(1,Tw) .* u]; % generator power limits

%% generator ramp limits
% need to set gMax on the lower bound in order to shut-down generator
g_ramping = [-rMax - gMax .* z(:,1) <= g(:,1) - g0 <= rMax + gMin .* v(:,1)];

for t = 2:Tw
    g_ramping = [g_ramping, -rMax - gMax .* z(:,t) <= g(:,t) - g(:,t-1) <= rMax + gMin .* v(:,t)]; %generator ramping limits
end

%% Power balance
p_balance = [sum(g,1) + w + sum(p_d,1) + qU == D + sum(p_c,1) + qD ]; % electric power balance

%% Wind integration
cons_wind = [w <= W, w>=0];

%% Storage limits
p_ES = [p_c >= 0 , p_d >= 0, ...
        p_c <= P , p_d <= P,...
        e <= E , e >= 0]; % ES power is large than 0
    
%% Storage SoC evolution
soc_ES = [e(:,1) - e0 ==  p_c(:,1) * eta - p_d(:,1) / eta];% initial and final SOC
for t = 2:Tw
    soc_ES = [soc_ES, e(:,t) - e(:,t-1) == p_c(:,t) * eta - p_d(:,t) / eta]; %ES charging/discharging
end

%% End Horizon Storage opportunity value using piece-wise linearization
Vf_cons = [es_cost(:,1) .* ones(Ns,1) <= Vk .* (e(:,Tw).* ones(Ns,1) - Ve) + Vb];

%% slack generator
cons_slack = [qU >= 0, qD >= 0];

%% Define objective
g_cost = 0; 
for k = 1:Ng
    g_cost = g_cost + c1(k) .* g(k,:) + c2(k) * g(k,:).^2;
end

g_cost = g_cost + qU*1000 + qD*1000;

%
e_cost = p_d*cES;

obj_cost = sum(g_cost) - sum(es_cost) + sum(e_cost);

%% Start Opt
% assemble constraints
cons_set = g_limit ...  
    + g_ramping ...
    + p_balance ...
    + cons_wind ...
    + p_ES ...
    + soc_ES ...
    + Vf_cons ...
    + cons_slack;

options =sdpsettings('verbose',0,'solver','gurobi','savesolveroutput',1,'cachesolvers',1);

sol = solvesdp(cons_set,obj_cost, options);

if sol.problem > 0
%     error('RT did not solve!')
    fprintf('Error, RT did not solve!');
end


%% Save results

Rout.g = value(g);
Rout.w = value(w);
Rout.e = value(e);
Rout.p_c = value(p_c);
Rout.p_d = value(p_d);
Rout.obj = value(g_cost);
Rout.cp = toc;
Rout.LMP = -dual(p_balance);
Rout.q = value(qU)-value(qD);
Rout.e_cost = value(e_cost);

yalmip('clear');
