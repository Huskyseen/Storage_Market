%%
% Title: Plot codes for energy storage market participation simulation 
% (Figure 1-3, 5, S1, S2)
%
% Authors: 
% Xin Qin (qinxin_thu@outlook.com, xq234@cam.ac.uk), 
% Bolun Xu (bx2177@columbia.edu)
% 
% Please download and include the data files from:
% https://drive.google.com/drive/folders/1C2kqt6j26Ly8-Vv45FKcKqxUrqDpZcrM
% 
% Last update date: 5/6/2023
% Summary:
%   This code is used to plot 
%   - Generation cost
%   - Carbon emission
%   - Storage profits
%   - Load/wind scenarios
%   - Radar plots
% 


close all
clear all
clc
%% Select the figures to plot
plot_radar = 0; % 1- radar plot, 0- other plots
if plot_radar == 1
    load('DA1210_1seg.mat') % for radar plots
else
    load('DA1215_1seg.mat') % for other plots
end
%% Plot setting
color_map;      % load color map
wplot = [1, 2, 3];
plot_mode = 2; % 1-in one window , 2-in 6 windows

% set x axis for plot
P_plot = ES_PC / 1000;
myXTick = [0 1000 2000 3000 4000 5000] / 1000;
myXlabel = {'Storage capacity (GW)'};
myXst = 0;
myXed = 5000/1000;

mylegend  = {'RT', 'DA','DA+RT'};
mylegend2 = {'RT', 'DA','DA+RT'};

figureposition = [200 200 400 420];
figure_agg_position = [2 200 1200 400];
sz = [4 5 6]; %markersize
my_linesize = [2.5 2];

%% Data settings
iS_index = [1:5];
iEU_index = 1;
coe_sc = zeros(1, sc_num);
coe_sc(iS_index) = sys_para.c_sc(iS_index) ./ sum(sys_para.c_sc(iS_index));

%% Initialization
nK  = numel(SC(1).ESU(1).RT(1).Iter);
nRT = numel(SC(1).ESU(1).RT);
nP  = numel(ES_PC);
nS  = numel(SC);
ES_energy = ES_PC/(P*Ts);
iRT = 1;
iEU = 1;

%% Calculate mean values
calcu_mean;
calcu_55;

%% Figure 2. generator cost and carbon emission
if plot_radar == 0
    R1_55_generator;
end
%% Figure 3. storage profits
if plot_radar == 0
    R1_55_storage;
end
%% Figure 5. radar
% warning: to plot radar plot, please use plot_radar ==1
if plot_radar == 1
    subplot_radar;
end
%% Figures S1 and S2. load and wind scenarios
if plot_radar == 0
    plot_scenarios;
end