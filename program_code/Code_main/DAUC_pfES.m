function Rout = DAUC_pfES(MPC, e0, P, E, eta, c)

% day-ahead unit commitment with energy storage and perfect wind prediction

%% format data
D = MPC.load(:,3)';
W = MPC.g_wind_noise';
gMin = MPC.g_min;
gMax = MPC.g_max;
rMax = MPC.ramp_max;
c1 = MPC.gen(:,9);
c2 = MPC.gen(:,10);
Tup = MPC.Tup;
Tdn = MPC.Tdn;
NLC = MPC.gen(:,8);
SC = MPC.gen(:,7);
                    
%% run UC
Rout = DAUC(D, c1, c2, gMax, gMin, rMax, Tup, Tdn, NLC, SC, W, e0, P, E, eta, c);