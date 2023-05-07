function Rout = DAUC(D, c1, c2, gMax, gMin, rMax, Tup, Tdn, NLC, SC, W, e0, P, E, eta, cES)
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
% Tup - min up time
% Tdn - min dn time
% NLC - no load cost
% SC - start-up cost
% W - wind profile
% e0 - initial SoC
% P - Power rating
% E - energy rating
% eta - efficiency


tic;

Ne = size(P,1); % only consider one storage
Ng = size(c1,1); % read number of generators
Tw = numel(D); % UC is always 24 hours

%% define variables
p_c = sdpvar(Ne,Tw); % storage charge power
p_d = sdpvar(Ne,Tw); % storage discharge power
e = sdpvar(Ne,Tw); % SoC 

g = sdpvar(Ng,Tw); % generator output
u = binvar(Ng,Tw);
v = binvar(Ng,Tw);
z = binvar(Ng,Tw);

w = sdpvar(1,Tw); % wind input
r = sdpvar(1,Tw); % system reserve

%% generator Min and Max
g_limit = [gMin * ones(1,Tw) .* u <= g <= gMax * ones(1,Tw) .* u]; % generator power limits

%% generator ramp limits
% in UC we ignore ramping constraint for the first time period
g_ramping = [ ];

for t = 2:Tw
    g_ramping = [g_ramping, -rMax - gMin .* z(:,t) <= g(:,t) - g(:,t-1) <= rMax + gMin .* v(:,t)]; %generator ramping limits
end

%% up and dn constraints
% Logic constraints
% in UC we ignore the start-up / shut-down constraint in the first time
% period
cons_logic = [];
for t = 2:Tw
cons_logic = [cons_logic, v(:,t) - z(:,t) == u(:,t) - u(:,t-1)];
end

cons_logic2 = [v - z <= 1 .* ones(Ng,Tw)];

% Minimum up time constraint
cons_mindn = [];
cons_minup = [];
for t = 1:Tw
    tup = max(t .* ones(Ng,1) - Tup, ones(Ng,1));
    tdn = max(t .* ones(Ng,1) - Tdn, ones(Ng,1));
    cons_minup = [cons_minup, sum(v(:,tup:t),2) <= u(:,t)];
    cons_mindn = [cons_mindn, sum(z(:,tdn:t),2) <= 1 - u(:,t)];
end

cons_commitment = cons_logic + cons_logic2 + cons_mindn + cons_minup;
%% Power balance
p_balance = [sum(g,1) + w + sum(p_d,1) == D + sum(p_c,1) ]; % electric power balance

%% Wind integration
cons_wind = [w <= W, w>= 0];

%% Storage limits
p_ES = [p_c >= 0 , p_d >= 0, ...
        p_c <= P , p_d <= P,...
        e <= E , e >= 0]; % ES power is large than 0
    
%% Storage SoC evolution
soc_ES = [e(:,1) - e0 ==  p_c(:,1) * eta - p_d(:,1) / eta];% initial and final SOC
for t = 2:Tw
    soc_ES = [soc_ES, e(:,t) - e(:,t-1) == p_c(:,t) * eta - p_d(:,t) / eta]; %ES charging/discharging
end

%% reserve constraints
% System reserve

cons_reserve = [r >= 0.2 .* w]; 
cons_reserve2 = [r <= sum((gMax * ones(1,Tw)) .* u - g, 1) ];
cons_reserve3 = [r <= sum((rMax * ones(1,Tw)) .* u, 1) ];

cons_res = cons_reserve + cons_reserve2 + cons_reserve3;

%% Define objective
g_cost = 0; 
m_cost = 0; 
v_cost = 0;
for k = 1:Ng
    g_cost = g_cost + c1(k) .* g(k,:) + c2(k) * g(k,:).^2;
    m_cost = m_cost + u(k,:) .* NLC(k); 
    v_cost = v_cost + v(k,:) .* SC(k);
end

%
e_cost = p_d*cES;

obj_cost = sum(g_cost) + sum(m_cost) + sum(v_cost) + sum(e_cost);

%% Start Opt
% assemble constraints
cons_set = g_limit ...
    + g_ramping ...
    + p_balance ...
    + cons_wind ...
    + p_ES ...
    + soc_ES ...
    + cons_commitment ...
    + cons_res;

options =sdpsettings('verbose',0,'solver','gurobi','savesolveroutput',1);

sol = solvesdp(cons_set,obj_cost, options);


if sol.problem > 0
    error('UC did not solve!')
end


%% Save results

Rout.g = value(g);
Rout.u = round(value(u));
Rout.v = round(value(v));
Rout.z = round(value(z));
Rout.w = value(w);
Rout.e = value(e);
Rout.p_c = value(p_c);
Rout.p_d = value(p_d);
Rout.obj = value(g_cost);
Rout.comit_cost = value(m_cost) + value(v_cost);
Rout.cp = toc;
Rout.e_cost = value(e_cost);

yalmip('clear');

%%%%%%%%%%%%%%%%%%%
%% re-run model in LP to calculate LMP
u = Rout.u;
v = Rout.v;
z = Rout.z;

%% define variables
p_c = sdpvar(Ne,Tw); % storage charge power
p_d = sdpvar(Ne,Tw); % storage discharge power
e = sdpvar(Ne,Tw); % SoC 

g = sdpvar(Ng,Tw); % generator output

w = sdpvar(1,Tw); % wind input
r = sdpvar(1,Tw); % reserve

%% generator Min and Max
g_limit = [gMin * ones(1,Tw) .* u <= g <= gMax * ones(1,Tw) .* u]; % generator power limits


%% generator ramp limits
g_ramping = [ ];

for t = 2:Tw
    g_ramping = [g_ramping, -rMax - gMin .* z(:,t) <= g(:,t) - g(:,t-1) <= rMax + gMin .* v(:,t)]; %generator ramping limits
end


%% Power balance
p_balance = [sum(g,1) + w + sum(p_d,1) == D + sum(p_c,1) ]; % electric power balance

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

%% reserve constraints
% System reserve

cons_reserve = [r >= 0.2 .* w]; 
cons_reserve2 = [r <= sum((gMax * ones(1,Tw)) .* u - g, 1) ];
cons_reserve3 = [r <= sum((rMax * ones(1,Tw)) .* u, 1) ];

cons_res = cons_reserve + cons_reserve2 + cons_reserve3;

%% Define objective
g_cost = 0; 
for k = 1:Ng
    g_cost = g_cost + c1(k) .* g(k,:) + c2(k) * g(k,:).^2;
end

%
e_cost = p_d*cES;

obj_cost = sum(g_cost) + sum(e_cost);

%% Start Opt
% assemble constraints
cons_set = g_limit ...
    + g_ramping ...
    + p_balance ...
    + cons_wind ...
    + p_ES ...
    + soc_ES ...
    + cons_res;

options =sdpsettings('verbose',0,'solver','gurobi','savesolveroutput',1,'cachesolvers',1);
options.gurobi.FeasibilityTol = 1e-4;
sol = solvesdp(cons_set,obj_cost, options);

%% record price results

Rout.LMP = -dual(p_balance);

yalmip('clear');

