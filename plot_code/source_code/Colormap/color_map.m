%% colorbar, output: colormap
% colormap(1:4,:) - green
% colormap(5:6,:) - blue
% colormap(7:9,:) - yellow
% colormap(10:12,:) - red
% colormap(13:14,:) - purple
% colormap(15:16,:) - black


hexmap = ['#1ABC9C'; '#2ECC71'; '#16A085';'#27AE60';...% green
            '#3498DB';'#2980B9';...% blue
            '#F1C40F';'#E67E22';'#F39C12';...% yellow
            '#E74C3C'; '#D35400'; '#C0392B'; ...% red
            '#9B59B6'; '#8E44AD';...% purple
            '#34495E'; '#2C3E50'; ...% black
            '#DCDCDC'; '#D3D3D3';'#C0C0C0'];...% grey

cbar = hex2rgb(hexmap);
cbar_selected = cbar([6, 10, 9, 1, 11, 12],:);

radarcolor = cbar([6 10 9],:);
radaraxiscolor = cbar(17,:);

cbar_shadow = [0.4, 0.3, 0.2, 0.2, 0.2];
