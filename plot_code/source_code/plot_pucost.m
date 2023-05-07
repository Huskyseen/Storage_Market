hold all



for iS = 1:nS
for iP = 1:nP
    id_temp = T_SP.tab_ALL_WC==WC(iW)/1000 & T_SP.tab_ALL_EPC == ES_PC(iP)/1000 & ( T_SP.tab_ALL_SC == iS_index(iS) );
    maxsp_all(iS,iP) = max(T_SP.tab_SP_pucost(id_temp));
    minsp_all(iS,iP) = min(T_SP.tab_SP_pucost(id_temp));
    maxda_all(iS,iP) = max(T_DA.tab_DA_pucost(id_temp));
    minda_all(iS,iP) = min(T_DA.tab_DA_pucost(id_temp));
    maxdart_all(iS,iP) = max(T_DART.tab_DART_pucost(id_temp));
    mindart_all(iS,iP) = min(T_DART.tab_DART_pucost(id_temp));
end
end

maxsp = myfilter(sum(maxsp_all .* coe_sc',1), n1,n2);
minsp = myfilter(sum(minsp_all .* coe_sc',1), n1a,n2a);  
pic01 = fill([P_plot,fliplr(P_plot)],[minsp,fliplr(maxsp)], cbar_selected(1,:));
set(pic01,'edgealpha', 0, 'facealpha', cbar_shadow(1));
% hatchfill2(pic01,'cross','HatchAngle',25,'HatchDensity',20,'HatchColor',cbar_selected(1,:),'HatchLineWidth',1);

maxda =  myfilter(sum(maxda_all .* coe_sc',1), n1a,n2a); 
minda =  myfilter(sum(minda_all .* coe_sc',1), n1a,n2a);   
pic02 = fill([P_plot,fliplr(P_plot)],[minda,fliplr(maxda)], cbar_selected(2,:));
set(pic02,'edgealpha', 0, 'facealpha', cbar_shadow(2));
% hatchfill2(pic02,'single','HatchAngle',45,'HatchDensity',30,'HatchColor',cbar_selected(2,:),'HatchLineWidth',1);


maxdart =  myfilter(sum(maxdart_all .* coe_sc',1), n1a,n2a); 
mindart =  myfilter(sum(mindart_all .* coe_sc',1), n1a,n2a);   
pic03 = fill([P_plot,fliplr(P_plot)],[mindart,fliplr(maxdart)], cbar_selected(4,:));
set(pic03,'edgealpha', 0, 'facealpha', cbar_shadow(3));


f1 = myfilter(SP_avg_pucost(:,ii), n1,n2);
f2 = myfilter(DA_avg_pucost(:,ii), n1a,n2a);
f3 = myfilter(DART_avg_pucost(:,ii), n1a,n2a);
f4 = myfilter(NE_avg_pucost(:,ii), n1a,n2a);

% h4 = plot(P_plot, f4 ,'-.','LineWidth',my_linesize(2), 'color', cbar_selected(3,:));
h1 = plot(P_plot, f1,'-','LineWidth',my_linesize(1), 'color', cbar_selected(1,:));
h2 = plot(P_plot, f2,'-.','LineWidth',my_linesize(1), 'color', cbar_selected(2,:));
% plot(P_plot, myfilter(NE_avg_pucost(:,ii), n1,n2),'--','LineWidth',my_linesize(1), 'color', cbar_selected(3,:))
% plot(P_plot, myfilter(PMP_avg_pucost(:,ii), n1,n2),'-.','LineWidth',my_linesize(1), 'color', cbar_selected(6,:))
h3 = plot(P_plot, f3 ,'--','LineWidth',my_linesize(1), 'color', cbar_selected(4,:));

[vmin, nmin] = min(f1);
% [vmin, nmin] = min((SP_avg_pucost(:,ii)));
plot(P_plot(nmin),vmin,'o','LineWidth',2, 'MarkerEdgeColor',cbar_selected(1,:),'MarkerFaceColor','w', 'MarkerSize',8)


