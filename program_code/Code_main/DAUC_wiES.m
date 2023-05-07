function [RDA, RRT] = DAUC_wiES(MPC, e0, P, E, eta, c, VF, is_DART)

% day-ahead unit commitment with energy storage

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
% run unit commitment with storage
RDA = DAUC(D, c1, c2, gMax, gMin, rMax, Tup, Tdn, NLC, SC, W, e0, P, E, eta, c);

% run single-period economic dispatch but without storage (P and E are set to zero)
% the code takes VF for formality but will not use it
RRT = M_RTED(RDA, MPC, e0, 0, 0, eta, c, VF, 1, is_DART);

