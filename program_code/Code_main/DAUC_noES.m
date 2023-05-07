function Rout = DAUC_noES(MPC)

% day-ahead unit commitment without energy storage

%% format data
D = MPC.load(:,3)';
W = MPC.g_wind';
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
Rout = DAUC(D, c1, c2, gMax, gMin, rMax, Tup, Tdn, NLC, SC, W, 0, 0, 0, 1, 0);