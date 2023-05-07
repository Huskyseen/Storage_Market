
%% Figure 2. generator cost and carbon emission

n1 = 2;
n2 = 13;

n1a = 2;
n2a = 15;

%% 1. per-unit generation cost


iW = wplot(1);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    figure('Position', figure_agg_position)
    subplot(1,3,1)%low wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
plot_pucost;
axis([myXst myXed 7.5 20.5]);
set(gca,'YTick',[8:3:20]);
set(gca,'XTick',myXTick);
ylabel('Average generation cost ($/MWh)')
xlabel(myXlabel)
legend([h1,h2,h3], mylegend, 'Position',[0.635,0.143,0.2475,0.194],'FontSize',11);
set(gca,'FontSize',12);
hold off
grid off
box on

% plot subplot
if plot_mode == 1
axes('Position',[0.18,0.30,0.15,0.3]);
else
axes('Position',[0.25,0.39,0.5,0.35]); 
end
iii = 7:22;
hold all
plot(P_plot(iii), f1(iii),'-','LineWidth',my_linesize(1), 'color', cbar_selected(1,:));
plot(P_plot(iii), f2(iii),'-.','LineWidth',my_linesize(1), 'color', cbar_selected(2,:));
plot(P_plot(iii), f3(iii),'--','LineWidth',my_linesize(1), 'color', cbar_selected(4,:));
plot(P_plot(nmin),vmin,'o','LineWidth',2, 'MarkerEdgeColor',cbar_selected(1,:),'MarkerFaceColor','w', 'MarkerSize',8)
grid off
box on
axis([P_plot(7) P_plot(22) 18.5 19.7]);
set(gca,'xTick',[P_plot(7) 1 2 3]);
set(gca,'YTick',[18.5 19 19.5]);
hold off



iW = wplot(2);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    subplot(1,3,2)%medium wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
    plot_pucost;
axis([myXst myXed 7.5 20.5]);
set(gca,'YTick',[8:3:20]);
set(gca,'XTick',myXTick);
ylabel('Average generation cost ($/MWh)')
xlabel(myXlabel)
legend([h1,h2,h3], mylegend, 'Location','best','FontSize',11,'FontSize',11);
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
plot_pucost
axis([myXst myXed 7.5 20.5]);
set(gca,'YTick',[8:3:20]);
set(gca,'XTick',myXTick);
ylabel('Average generation cost ($/MWh)')
xlabel(myXlabel)
legend([h1,h2,h3], mylegend, 'position',[0.492500001788139,0.703333335521203,0.247499996423721,0.194047613654818],'FontSize',11);
set(gca,'FontSize',12);
hold off
grid off
box on


%% 2. per-unit carbon emission
iW = wplot(1);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    figure('Position', figure_agg_position)
    subplot(1,3,1)%low wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
plot_pucarbon

axis([myXst myXed 0.26 0.30]);
set(gca,'YTick',[0.26:0.01:0.30]);
set(gca,'XTick',myXTick);
ylabel('Per-unit carbon emission (ton/MWh)')
xlabel(myXlabel)
legend([h1,h2,h3], mylegend, 'Location','southwest','FontSize',11);
set(gca,'FontSize',12);
hold off
grid off
box on
hold off


iW = wplot(2);%wind index
ii = (iW-1)*nP + (1:nP);
if plot_mode == 1
    subplot(1,3,2)%medium wind
    title(['Wind capacity ',num2str(WC(iW)/1000),' GW'])
else
    figure('Position', figureposition)
end
plot_pucarbon
axis([myXst myXed 0.18 0.22]);
set(gca,'YTick',[0.18:0.01:0.22]);
set(gca,'XTick',myXTick);
ylabel('Per-unit carbon emission (ton/MWh)')
xlabel(myXlabel)
legend([h1,h2,h3], mylegend, 'Location','best','FontSize',11);
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
plot_pucarbon
axis([myXst myXed 0.088 0.128]);
set(gca,'YTick',[0.088:0.01:0.128]);
set(gca,'XTick',myXTick);
ylabel('Per-unit carbon emission (ton/MWh)')
xlabel(myXlabel)
legend([h1,h2,h3], mylegend, 'position',[0.21662499826774,0.150000008266596,0.247499996423721,0.194047613654818],'FontSize',11);
set(gca,'FontSize',12);
hold off
grid off
box on
