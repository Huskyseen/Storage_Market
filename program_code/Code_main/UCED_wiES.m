function [RUC, RED] = UCED_wiES(MPC, e0, P, E, eta, c, seg_num, sigma, Ne, ed, ef, Tw, rho)

% schedule storage in day-ahead and then re-dispatch storage in real-time

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
RUC = DAUC(D, c1, c2, gMax, gMin, rMax, Tup, Tdn, NLC, SC, W, e0, P*rho, E*rho, eta, c);
% p_d_temp = RUC.p_d;
% p_c_temp = RUC.p_c;
% RUC_p_c = 0;
% RUC.p_d = 0;


%% calculate storage bids

[VF,~] = value_fcn_calcu(RUC.LMP, seg_num, Ne, numel(RUC.LMP), c, P/E, eta, ed, ef, sigma);

%% run ED

RED = M_RTED(RUC, MPC, e0, P*(1-rho), E*(1-rho), eta, c, VF, Tw, 0);

%%
% RUC_p_c = p_c_temp;
% RUC.p_d = p_d_temp;