
%% 

for iS = 1:nS
for iP = 1:nP
    id_temp = T_SP.tab_ALL_WC==WC(iW)/1000 & T_SP.tab_ALL_EPC == ES_PC(iP)/1000 & ( T_SP.tab_ALL_SC == iS_index(iS) );
    maxsp_all(iS,iP) = max(T_SP.tab_SP_puprofit(id_temp));
    minsp_all(iS,iP) = min(T_SP.tab_SP_puprofit(id_temp));
    maxda_all(iS,iP) = max(T_DA.tab_DA_puprofit(id_temp));
    minda_all(iS,iP) = min(T_DA.tab_DA_puprofit(id_temp));
    maxdart_all(iS,iP) = max(T_DART.tab_DART_puprofit(id_temp));
    mindart_all(iS,iP) = min(T_DART.tab_DART_puprofit(id_temp));

    meansp_all(iS,iP) = mean(T_SP.tab_SP_puprofit(id_temp));
    meanda_all(iS,iP) = mean(T_DA.tab_DA_puprofit(id_temp));
    meandart_all(iS,iP) = mean(T_DART.tab_DART_puprofit(id_temp));
end
end


ec_plot_pre = ones(nS,1) * ES_PC(id_plot) ./1000; 
mean_sp_pre = meansp_all(:,id_plot);
mean_da_pre = meanda_all(:,id_plot);
mean_dart_pre = meandart_all(:,id_plot);
ec_plot = ec_plot_pre(:);
mean_sp = mean_sp_pre(:);
mean_da = mean_da_pre(:);
mean_dart = mean_dart_pre(:);
for i  = 1:length(mean_sp)
lg_sp(i,1) = {'RT'};
lg_da(i,1) = {'DA'};
lg_dart(i,1) = {'DA+RT'};
end
Tec = [ec_plot;ec_plot;ec_plot];
Tvalue = [mean_sp;mean_da;mean_dart];
Tlegend = [lg_sp;lg_da;lg_dart];
tab_profit = table(Tlegend, Tvalue, Tec);
plot_cat = {'RT',	'DA','DA+RT'};
es_cat = ES_PC(id_plot)/1000;
tab_profit.Tlegend = categorical(tab_profit.Tlegend,plot_cat);% categorical(table row, catagory to filter)


b1 = boxchart(ec_plot-0.11, mean_sp,'MarkerStyle','none','Notch','off');
b1.BoxWidth = 0.09;
hold on
b2 = boxchart(ec_plot , mean_da,'MarkerStyle','none','Notch','off');
b2.BoxWidth = 0.09;
b3 = boxchart(ec_plot + 0.11, mean_dart,'MarkerStyle','none','Notch','off');
b3.BoxWidth = 0.09;

b1.BoxFaceColor = cbar_selected(1,:);
b2.BoxFaceColor = cbar_selected(2,:);
b3.BoxFaceColor = cbar_selected(4,:);

legend([b1,b2,b3],mylegend, 'Location','best');
