%%
% Title: Pareto frontier analysis for energy storage market participation
% 
% Authors: 
% Xin Qin (qinxin_thu@outlook.com, xq234@cam.ac.uk), 
% Bolun Xu (bx2177@columbia.edu)
%
% 
% Last update date: 5/6/2023
% Summary:
%   This code is similarto mainTest.m except it also changes the ratio of
%   storage participating in DA+RT and RT. The result is used to construct
%   a Pareto frontier. This is achieved by introducing a new parameter rhoS
%   to iterate the ratio of storage in differnet market participation
%   setting. 
% 
% 
%   Note: To run this code, yalmip and solver Gurobi are needed.
%         If you do not install yalmip, please decompress YALMIP-master.zip
clc
clear all
close all

%% 1. Settings
% 1.1 System
T   = 24 * 1; %totl periods
Ts  = 1; % time interval between two periods (hour)
Tw  = 4; % time interval of rolling window dispatch
sys_para = load_system_data(T,5);

% 1.2 parameters for case studies
coe_wind = [.5 1 2]*1.3e4; % times of wind power - w
% coe_wind = 10000;
noise_power = [20] / 100; % 100% - i
% P_real = [10 50 100 200 300 400 500 700 1000 2000 3000 4000 7000 10000]; % P_real MW ES -j
% P_real = [500 1000 2000 3000 4000 5000]; % P_real MW ES -j
% P_real = [1000 2000 3000 4000 5000]; % P_real MW ES -j
P_real = [1]; % P_real MW ES -j
sigma = [0]; % the deviation (assume Guassian) used to consider bid uncertainty.
% coe_wind = [ 10000]; % times of wind power - w
% noise_power = [20] / 100; % 100% - i
% P_real = [2000 5000 10000 16000]; % P_real MW ES -j
% sigma = [0]; % the deviation (assume Guassian) used to consider bid uncertainty.
SP.es_mode = 2; % 1-ISO control BES, 2-ISO cannot control BES
RP.es_mode = 2;
MP.es_mode = 2;
DAdispatch.es_mode = 1;

% 1.3 system parameter
sc_num      = 5;
wind_num    = length(coe_wind);
noise_num   = length(noise_power);
P_num       = length(P_real);
un_num      = length(sigma);
Pr  = 0.25; % normalized power rating wrt energy rating
P   = Pr*Ts; % actual power rating taking time step size into account: now 10MW/40MWh
eta = .9; % efficiency
c   = 25; % marginal discharge cost - degradation
ed  = .01; % SoC sample granularity
ef  = .0; % final SoC target level, use 0 if none
Ne  = floor(1/ed)+1; % number of SOC samples
e0  = 0;
seg_num = 20;% value function segment number
% rho = 0.5; % ratio of storage in DA and RT markets
rhoS = [0:0.05:0.4, 0.5:0.1:0.8, 0.8:0.01:1];

%% 2. run market clearing
for sc = 1:5
    fprintf('\nStart scenario %d. \n',sc);
    for iRT = 1:5
    for w = 1:wind_num
        fprintf('\nRunning subloop %.2f %%. \n',w/wind_num*100);
        for i = 1:noise_num
            Iter.mpc = prepare_power_system(sys_para, coe_wind(w), noise_power(i), T, sc, iRT);
            %% 3. combined analysis
            for j = 1:P_num
                fprintf('\nRunning P = %d. \n', P_real(j));
                for i_rho = 1:numel(rhoS) 
               
                    % UC+ED
                    fprintf('rho = %.1f; ', rhoS(i_rho));
                    [RUC2, RED2] = UCED_wiES_rho(Iter.mpc, e0, P_real(j), P_real(j)/P, eta, c, seg_num, sigma(1), Ne, ed, ef, Tw, rhoS(i_rho));
                    
                    Iter.UEDA(i_rho) = RUC2; % unit commitment result with storage
                    Iter.UERT(i_rho) = RED2; % real-time dispatch result with storage 
                end
             %% 4. copy
                    % k = (w-1)*P_num*noise_num + (i-1)*P_num + j;
                    SC(sc).RT(iRT).WS(w).Iter(j) = Iter;
            end
        end
    end
    end
end



%%
save('test_rho.mat');