%% Figures S1 and S2. load and wind scenarios
%% setting
iEU = 1;
for iS = 1:5
    for iW = 1:wind_num
        for iRT  = 1:nRT
            ii = (iW-1)*nP + 1; %index of 1th es at each wind scenarios
            Iter = SC(iS).ESU(iEU).RT(iRT).Iter(ii);
            load(iS,:) = Iter.mpc.load(:,3)/1000; % load in GW
            windpu(iS,:) = Iter.mpc.wind(:,3)/1000; % load in 1MW;

            windda(iS,iW,:) = Iter.mpc.g_wind/1000; % da wind forecase in GW

            windrt(iS,iW,iRT,:) = Iter.mpc.g_wind_noise/1000; % rt wind in GW
        end
    end
end

for iS = 1:5
    for iW = 1:3
        for iRT = 1:nRT
        mae_wind_all(iS,iW,iRT) = mae(squeeze(windrt(iS,iW,iRT,:)) - squeeze(windda(iS,iW,:))) ./ (mean(windda(iS,iW,:))) ;
        mse_wind_all(iS,iW,iRT) = mse(squeeze(windrt(iS,iW,iRT,:)) - squeeze(windda(iS,iW,:)))./ (mean(windda(iS,iW,:))) ;
        end
    end
end
mae_wind = squeeze(mean(mae_wind_all,3)) * 100;
mse_wind = squeeze(mean(mse_wind_all,3)) * 100;
final_mae = mean(mae_wind);
final_mse = mean(mse_wind);
%% wind
iW = 2;%wind index
if plot_mode == 1
    figure('Position', figure_agg_position)
end
for iS = 1:5
if plot_mode == 1
    subplot(2,3,iS)%low wind
else
    figure('Position', figureposition)
end
hold all
plot(squeeze(windda(iS,iW,:)),'-o','LineWidth',2, 'MarkerSize',5,'color',cbar_selected(1,:))
P_plot = 1:T;
data_temp = squeeze(windrt(iS,iW,1:nRT,:));
ubd = max(data_temp,[],1);
lbd = min(data_temp,[],1);
pic01 = fill([P_plot,fliplr(P_plot)],[lbd,fliplr(ubd)], cbar_selected(1,:));
set(pic01,'edgealpha', 0, 'facealpha', cbar_shadow(1));
axis([1 24 0 15]);
set(gca,'XTick',myXTick);
set(gca,'XTick',[1 6 12 18 24]);
set(gca,'XTicklabels',{'0:00','6:00','12:00','18:00','24:00'})


ylabel('Wind generation (GW)')
xlabel('Time')
legend('DA','RT', 'Location','best');
set(gca,'FontSize',12);
set(gca,'linewidth',1)
hold off
grid on
box off
temp_name =sprintf('%s%d','sc_wind',iS);

end
%% load
if plot_mode == 1
    figure('Position', figure_agg_position)
end
for iS = 1:5
if plot_mode == 1
    subplot(2,3,iS)%low wind
else
    figure('Position', figureposition)
end
hold all
plot((load(iS,:)),'-o','LineWidth',2, 'MarkerSize',5,'color',cbar_selected(1,:))
axis([1 24 9 17]);
set(gca,'YTick',[9 11 13 15 17]);
set(gca,'XTick',myXTick);
set(gca,'XTick',[1 6 12 18 24]);
set(gca,'XTicklabels',{'0:00','6:00','12:00','18:00','24:00'})
ylabel('Load demand (GW)')
xlabel('Time')
set(gca,'FontSize',12);
set(gca,'linewidth',0.7)
hold off
grid on
box off
temp_name =sprintf('%s%d','sc_load',iS);

end