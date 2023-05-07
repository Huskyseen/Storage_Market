%%
% Title: Plot codes for energy storage market participation simulation 
% (Figure 4)
%
% Authors: 
% Xin Qin (qinxin_thu@outlook.com, xq234@cam.ac.uk), 
% Bolun Xu (bx2177@columbia.edu)
%
% 
% Last update date: 5/6/2023
% Summary:
%   This code is used to plot the 
%   - Pareto Frontier

clc
clear all
close all

load('DA1223_rho_24h.mat')
l2 = load('DA0105_rho_24h.mat');
%% Plot setting 1
plot_mode = 2; % 1-in one window , 2-in 6 windows
figureposition = [200 200 400 420];
figure_agg_position = [2 200 1600 500];
%% Read and reformat data
close all
V = zeros(5,wind_num, P_num, numel(rhoS));
C = zeros(5,wind_num, P_num, numel(rhoS));
LMP = zeros(5,wind_num, P_num, numel(rhoS));
% sys_para = load_system_data(T);

for i = 1:5
    for iRT = 1:5
        for w = 1:wind_num
            for j = 1:P_num
                for m = 1:numel(rhoS)
                    load = sys_para.load_after_kmeans(:,i);
                    Iter = SC(i).RT(iRT).WS(w).Iter(j);
                    V_raw(i,w,j,m,iRT) = (sum(Iter.UERT(m).obj) + 0)./sum(load);
                    C_raw(i,w,j,m,iRT) = sum(sum(Iter.UERT(m).g,2) .* sys_para.gencarbon)./sum(load);
                    LMP_raw(i,w,j,m,iRT) = sum(Iter.UERT(m).LMP' .* load)/sum(load);
                end
            end

        end
    end
end

for i = 1:5
    for iRT = 1:5
        for w = 1:wind_num
            for j = 6
                for m = 1:numel(rhoS)
                    load = sys_para.load_after_kmeans(:,i);
                    Iter = l2.SC(i).RT(iRT).WS(w).Iter(1);
                    V_raw(i,w,j,m,iRT) = (sum(Iter.UERT(m).obj) + 0)./sum(load);
                    C_raw(i,w,j,m,iRT) = sum(sum(Iter.UERT(m).g,2) .* sys_para.gencarbon)./sum(load);
                    LMP_raw(i,w,j,m,iRT) = sum(Iter.UERT(m).LMP' .* load)/sum(load);
                end
            end

        end
    end
end
V = squeeze(mean(V_raw,5));
C = squeeze(mean(C_raw,5));
LMP = squeeze(mean(LMP_raw,5));
iS_index = 1:5;
coe_sc = zeros(1, sc_num);
coe_sc(iS_index) = sys_para.c_sc(iS_index) ./ sum(sys_para.c_sc(iS_index));

Vm = squeeze(sum(LMP(iS_index,:,:,:) .*coe_sc(iS_index)',1));
Cm = squeeze(sum(C(iS_index,:,:,:) .*coe_sc(iS_index)',1));

n1 = 2;
n2 = 33;
%% Plot setting 2

% legend
P_list = cell(P_num,1);
for i = 1:P_num
    P_list{i} = sprintf('P=%d', P_real(i));
end
color_map;
cbar_rho = cbar([10 9 2 5 13 17],:);

% title
P_st = 1;
jj = 1;
for i = P_st:P_num
    W_list{jj} = sprintf('%.f GW', P_real(i)/1000);
    jj = jj+1;
end
W_list{6} = sprintf('No ES');
yl = [12 76];
yt = [12:16:76];
%% Figure 4a. low wind

iW = 1;% 1 2 3

if plot_mode == 1
    figure('Position', figure_agg_position)
    subplot(1,3,1)%low wind
    if iW==1
        title(sprintf('Pareto frontier wind %.1f GW',coe_wind(iW)/1000));
    else
        title(sprintf('Pareto frontier wind %.0f GW',coe_wind(iW)/1000));
    end
else
    figure('Position', figureposition)
end
hold all
minCrho = zeros(numel(P_num),1);
minWrho = zeros(numel(P_num),1);

for iP = P_st:P_num+1
    CS = squeeze(Cm(iW,iP,:))';
    WS = squeeze(Vm(iW,iP,:))';

    [~,i1] = min(CS);
    minCrho(iP) = rhoS(i1);
    [~,i2] = min(WS);
    minWrho(iP) = rhoS(i2);

    sgf = sgolayfilt([CS; WS]',1,27);
    table_lw = [sgf,rhoS'];
    K = convhull(sgf(:,1),sgf(:,2));
    Fline(iP) = plot(sgf(:,1), sgf(:,2), '-', 'color', cbar_rho(iP,:),'LineWidth', 3);
end
Fline(6) = plot(sgf(1,1), sgf(1,2),'o','LineWidth',2, 'MarkerEdgeColor','k','MarkerFaceColor','w', 'MarkerSize',8);
xlim([0.275 0.315])
set(gca,'XTick',[0.275:0.01:0.315]);
ylim(yl)
set(gca,'YTick',yt);
grid on
xlabel('Carbon emission (ton/MWh)')
ylabel('Consumer payment  ($/MWh)')
legend(Fline, W_list, 'Location', 'best','FontSize',11)
set(gca,'FontSize',12);



%% Figure 4b. medium wind

iW = 2;% 1 2 3
if plot_mode == 1
    subplot(1,3,2)%low wind
    if iW==1
        title(sprintf('Pareto frontier wind %.1f GW',coe_wind(iW)/1000));
    else
        title(sprintf('Pareto frontier wind %.0f GW',coe_wind(iW)/1000));
    end
else
    figure('Position', figureposition)
end
hold all
minCrho = zeros(numel(P_num),1);
minWrho = zeros(numel(P_num),1);

for iP = P_st:P_num+1
    CS = squeeze(Cm(iW,iP,:))';
    WS = squeeze(Vm(iW,iP,:))';
    [~,i1] = min(CS);
    minCrho(iP) = rhoS(i1);
    [~,i2] = min(WS);
    minWrho(iP) = rhoS(i2);
    sgf = sgolayfilt([CS; WS]',n1,n2);
    table_mw = [sgf,rhoS'];
    if iP<=5
    Fline(iP) = plot(sgf(:,1), sgf(:,2), '-', 'color', cbar_rho(iP,:),'LineWidth', 3);
    end
    if iP ==5
        plot(sgf(1,1), sgf(1,2),'o','LineWidth',2, 'MarkerEdgeColor',cbar_rho(iP,:), ...
            'MarkerFaceColor',cbar_rho(iP,:), 'MarkerSize',5);
        plot(sgf(numel(rhoS),1), sgf(numel(rhoS),2),'o','LineWidth',2, 'MarkerEdgeColor',cbar_rho(iP,:), ...
            'MarkerFaceColor',cbar_rho(iP,:), 'MarkerSize',5);
    end
end
% plot(sgf(1,1), sgf(1,2),'o','LineWidth',2, 'MarkerEdgeColor',cbar_rho(5,:),'MarkerFaceColor',cbar_rho(5,:), 'MarkerSize',8);
txt = {'100% DA+RT'};
text(0.1855,62,txt,'FontSize',12)
txt1 = {'0% DA+RT'};
text(0.201,30,txt1, 'FontSize',12)

Fline(6) = plot(sgf(1,1), sgf(1,2),'o','LineWidth',2, 'MarkerEdgeColor','k','MarkerFaceColor','w', 'MarkerSize',8);
xlim([0.175 0.215])
set(gca,'XTick',[0.175:0.01:0.215]);
ylim(yl)
set(gca,'YTick',yt);
grid on
xlabel('Carbon emission (ton/MWh)')
ylabel('Consumer payment  ($/MWh)')
legend(Fline, W_list, 'Location', 'best','FontSize',11)
set(gca,'FontSize',12);

%% Figure 4c. high wind
iW = 3;% 1 2 3
minCrho = zeros(numel(P_num),1);
minWrho = zeros(numel(P_num),1);

if plot_mode == 1
    subplot(1,3,3)%low wind
    if iW==1
        title(sprintf('Pareto frontier wind %.1f GW',coe_wind(iW)/1000));
    else
        title(sprintf('Pareto frontier wind %.0f GW',coe_wind(iW)/1000));
    end
else
    figure('Position', figureposition)
end
hold all

for iP = P_st:P_num+1

    CS = squeeze(Cm(iW,iP,:))';
    WS = squeeze(Vm(iW,iP,:))';
    [~,i1] = min(CS);
    minCrho(iP) = rhoS(i1);%min carbon
    [~,i2] = min(WS);
    minWrho(iP) = rhoS(i2);%min payment/cost
    if iP<=3
        sgf = sgolayfilt([CS; WS]',1,21);
    else
        sgf = sgolayfilt([CS; WS]',n1,n2);
    end
    storage(iP).table_hw = [sgf,rhoS'];

    K = convhull(sgf(:,1),sgf(:,2));
    Fline(iP) = plot(sgf(:,1), sgf(:,2), '-', 'color', cbar_rho(iP,:),'LineWidth', 3);
end
Fline(6) = plot(sgf(1,1), sgf(1,2),'o','LineWidth',2, 'MarkerEdgeColor','k','MarkerFaceColor','w', 'MarkerSize',8);
grid on
xlabel('Carbon emission (ton/MWh)')
ylabel('Consumer payment  ($/MWh)')
if plot_mode ==2
legend(Fline, W_list, 'position', [0.161666759053866,0.648412705863282,0.229999996945262,0.264285706835134],'FontSize',11)
else
    legend(Fline, W_list, 'Location', 'best','FontSize',11)
end
xlim([0.085 0.125])
set(gca,'XTick',[0.085:0.01:0.125]);
ylim(yl)
set(gca,'YTick',yt);
set(gca,'FontSize',12);
hold off


