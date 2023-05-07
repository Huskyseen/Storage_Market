function Rout = P_RTED(UC, MPC, e0, P, E, eta, c)
% real-time dispatch with perfect prediction

%% read UC result
u = UC.u;
v = UC.v;
z = UC.z;
g0 = UC.g(:,1);     

%% read system data
D = MPC.load(:,3)';
W = MPC.g_wind_noise';
gMin = MPC.g_min;
gMax = MPC.g_max;
rMax = MPC.ramp_max;
c1 = MPC.gen(:,9);
c2 = MPC.gen(:,10);



%% run ED
% set storage opportunity value to zero and time horizon to 24
Rout = RTED(D, c1, c2, g0, gMax, gMin, rMax, u, v, z, W, e0, P, E, eta, c, 0, 0, 0, 24);