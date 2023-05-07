%% Figure 6. radar
clc
close all


color_map
%% Collect results from data sheet
close all

% Point propertiesnP
num_of_points = 4;
row_of_points = 4;

% Create generic labels
P_labels = cell(num_of_points, 1);
P_labels{1} = sprintf('Storage profitability');
P_labels{2} = sprintf('Economics');
P_labels{3} = sprintf('Sustainability');
P_labels{4} = sprintf('Market Volatility\nMitigation');


P_title = cell(row_of_points, 1);
P_title{1} = sprintf('Low wind, low storage');
P_title{2} = sprintf('High wind, low storage');
P_title{3} = sprintf('Low wind, high storage');
P_title{4} = sprintf('High wind, low storage');

% Cluster results
P_all = [];
j = 1;

% Select wind scenario and storage capacity HERE
for iP = [6 9]
    for iW = [1 3]

        ii = (iW-1)*nP + (iP);

        id_base = (iW-1)*nP + (1);%(iW-1)*nP + (iP);
        profit_base = PMP_avg_puprofit(id_base);
        cost_base = NE_avg_pucost(id_base);
        carbon_base = NE_avg_pucarbon(id_base);
        reli_base = PMP_std_LMP(id_base);

       P = [SP_avg_puprofit(ii) /profit_base-1,    -(SP_avg_pucost(ii) - cost_base) / cost_base,    -(SP_avg_pucarbon(ii) - carbon_base)/carbon_base,   -(SP_std_LMP(ii)-reli_base)/reli_base;
            DA_avg_puprofit(ii)/profit_base-1,     -(DA_avg_pucost(ii) - cost_base) / cost_base,    -(DA_avg_pucarbon(ii) - carbon_base)/carbon_base,   -(DA_std_LMP(ii)-reli_base)/reli_base;
            DART_avg_puprofit(ii)/profit_base-1,   -(DART_avg_pucost(ii) - cost_base) / cost_base,  -(DART_avg_pucarbon(ii) - carbon_base)/carbon_base, -(DART_std_LMP(ii)-reli_base)/reli_base];
  
        P_all = [P_all,P'];
        id_iP(j) = iP;
        id_iW(j) = iW;

        j = j+1;
    end
end

%% Normalize the results and plot

% Normalize results
P_std(1:4,:) = mapminmax(P_all(1:4,:),0,1); % taking valua from 0 to 1

if plot_mode == 1
    figure('Position', figure_agg_position)
end

for jj = 1:j-1
    st = 1 + (jj-1)*3; % 3 bidding choices
    ed = 3 + (jj-1)*3;
    P_std_matlab = P_std(:,st:ed)';               % for Matlab
    if plot_mode == 1
        subplot(2,2,jj)
    else
        figure
    end

    min_ax = -0.0 .* ones(1,4);
    max_ax = 1.0 .* ones(1,4);
    h(jj) =spider_plot(P_std_matlab,...
        'AxesLabels',P_labels,...
        'AxesLimits', [min_ax;max_ax],... % [min axes limits; max axes limits]
        'AxesDisplay', 'one','AxesFontSize', 10,'Color',radarcolor,...
        'AxesLabelsEdge', 'none','LabelFontSize',11,...
        'AxesColor',radaraxiscolor,...
        'Marker', 'o',...
        'LineStyle', '-',...
        'LineWidth', 1.5,...
        'FillOption', 'on', 'FillTransparency',[0.4 0.2 0.1], ...
        'MarkerSize', 5);


    % Title properties
    title(['Wind-',num2str(WC(id_iW(jj))/1000),'GW', '  Storage-',num2str(P_plot(id_iP(jj))),'GW'],...
        'Fontweight', 'bold',...
        'FontSize', 12);

    % Legend properties
    legend(mylegend2, 'Position', [0.64,0.715,0.276,0.147],'FontSize', 11);
    hold off
end

