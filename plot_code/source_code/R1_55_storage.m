%% Figure 3. storage profits

%% bar plot

n1 = 2;
n2 = 7;

pXst = -0.3;
pXed = 2.8;
pYst = -100;
pYed = 500;
pXTick = [0.01 0.5 1 1.5 2 2.5];
pXlabel = {'0.01','0.5','1','1.5','2','2.5'};
id_plot = [3 11 13 15 17 19];

EC_to_plot = ES_PC(id_plot)/1000

% plot1
iW = wplot(1);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    figure('Position', figure_agg_position)
    subplot(1,3,1)%low wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
hold all
plot_esprofits1

xlim([pXst pXed]);
ylim([pYst pYed]);
set(gca,'YTick',[-100 0 100 200 300 400 500]);
set(gca,'XTick',pXTick);
set(gca,'XTicklabels',pXlabel)
ylabel('Daily per-unit profits ($/MWh/day)')
xlabel('Storage capacity (GW)')
legend(mylegend, 'Location','best');
set(gca,'FontSize',12);
hold off
grid off
box on



iW = wplot(2);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    subplot(1,3,2)%medium wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
hold all
plot_esprofits1

xlim([pXst pXed]);
ylim([pYst pYed]);
set(gca,'YTick',[-100 0 100 200 300 400 500]);
set(gca,'XTick',pXTick);
set(gca,'XTicklabels',pXlabel)
ylabel('Daily per-unit profits ($/MWh/day)')
xlabel('Storage capacity (GW)')
legend(mylegend, 'Location','best');
set(gca,'FontSize',12);
hold off
grid off
box on



iW = wplot(3);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    subplot(1,3,3)%high wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
hold all
plot_esprofits1

xlim([pXst pXed]);
ylim([pYst pYed]);
set(gca,'YTick',[-100 0 100 200 300 400 500]);
set(gca,'XTick',pXTick);
set(gca,'XTicklabels',pXlabel)

ylabel('Daily per-unit profits ($/MWh/day)')
xlabel('Storage capacity (GW)')
legend(mylegend, 'Location','best');
set(gca,'FontSize',12);
hold off
grid off
box on

