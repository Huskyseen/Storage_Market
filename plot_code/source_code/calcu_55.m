
idV = 6; %index of value in table
idWU = 2;
clear PMP_pucost_all
%%
for iS = iS_index % index of scenarios
    for iRT = 1:RT_num % index of RT cases
        for iEU = 1:un_num

            Iter = SC(iS).ESU(iEU).RT(iRT).Iter(k);
            stall = (iS-1) * RT_num * un_num * nK + (iRT-1) * un_num * nK + (iEU-1) * nK +1;
            edall = stall + nK -1;
            for iW = 1:wind_num
                index_K = (iW-1)*nP + (1:nP);
                st = index_K(1);
                ed = index_K(nP);


                temp_SP_pucost(st:ed, 1) = squeeze(SP_pucost(iS,iRT,index_K));
                temp_DA_pucost(st:ed, 1) = squeeze(DA_pucost(iS,iRT,index_K));
                temp_NE_pucost(st:ed, 1) = squeeze(NE_pucost(iS,iRT,index_K));
                temp_PMP_pucost(st:ed, 1) = squeeze(PMP_pucost(iS,iRT,index_K));
                temp_DART_pucost(st:ed, 1) = squeeze(DART_pucost(iS,iRT,index_K));

                temp_SP_pucarbon(st:ed, 1) = squeeze(SP_pucarbon(iS,iRT,index_K));
                temp_DA_pucarbon(st:ed, 1) = squeeze(DA_pucarbon(iS,iRT,index_K));
                temp_NE_pucarbon(st:ed, 1) = squeeze(NE_pucarbon(iS,iRT,index_K));
                temp_PMP_pucarbon(st:ed, 1) = squeeze(PMP_pucarbon(iS,iRT,index_K));
                temp_DART_pucarbon(st:ed, 1) = squeeze(DART_pucarbon(iS,iRT,index_K));

                temp_SP_puprofit(st:ed, 1) = squeeze(SP_puprofit(iS,iRT,index_K));
                temp_DA_puprofit(st:ed, 1) = squeeze(DA_puprofit(iS,iRT,index_K));
                temp_NE_puprofit(st:ed, 1) = squeeze(NE_puprofit(iS,iRT,index_K));
                temp_PMP_puprofit(st:ed, 1) = squeeze(PMP_puprofit(iS,iRT,index_K));
                temp_DART_puprofit(st:ed, 1) = squeeze(DART_puprofit(iS,iRT,index_K));

                temp_ALL_EC(st:ed, 1) = ES_PC/1000; % storage capacity, GW
                temp_ALL_WC(st:ed, 1) = WC(iW)/1000; % wind capacity, GW

                if iS ==4

                    alter=1;
                end

            end
            % create a whole table
            tab_SP_pucost(stall:edall,1) = temp_SP_pucost;
            tab_DA_pucost(stall:edall,1) = temp_DA_pucost;
            tab_NE_pucost(stall:edall,1) = temp_NE_pucost;
            tab_PMP_pucost(stall:edall,1) = temp_PMP_pucost;
            tab_DART_pucost(stall:edall,1) = temp_DART_pucost;

            tab_SP_pucarbon(stall:edall,1) = temp_SP_pucarbon;
            tab_DA_pucarbon(stall:edall,1) = temp_DA_pucarbon;
            tab_NE_pucarbon(stall:edall,1) = temp_NE_pucarbon;
            tab_PMP_pucarbon(stall:edall,1) = temp_PMP_pucarbon;
            tab_DART_pucarbon(stall:edall,1) = temp_DART_pucarbon;

            tab_SP_puprofit(stall:edall,1) = temp_SP_puprofit;
            tab_DA_puprofit(stall:edall,1) = temp_DA_puprofit;
            tab_NE_puprofit(stall:edall,1) = temp_NE_puprofit;
            tab_PMP_puprofit(stall:edall,1) = temp_PMP_puprofit;
            tab_DART_puprofit(stall:edall,1) = temp_DART_puprofit;



            tab_SP_legend(stall:edall, 1) = mylegend(1);
            tab_DA_legend(stall:edall, 1) = mylegend(2);
%             tab_NE_legend(stall:edall, 1) = mylegend(1);
%             tab_PMP_legend(stall:edall, 1) = mylegend(1);
            tab_DART_legend(stall:edall, 1) = mylegend(3);


            tab_ALL_SC(stall:edall, 1) = iS;
            tab_ALL_RT(stall:edall, 1) = iRT;
            tab_ALL_EU(stall:edall, 1) = iEU;
            tab_ALL_EPC(stall:edall, 1) = temp_ALL_EC;
            tab_ALL_WC(stall:edall, 1) = temp_ALL_WC; % storage capacity, GW


        end
    end
end

T_SP = table(tab_ALL_SC, tab_ALL_RT, tab_ALL_EU,tab_ALL_WC, tab_ALL_EPC, tab_SP_legend, tab_SP_pucost, tab_SP_pucarbon, tab_SP_puprofit);
T_DA = table(tab_ALL_SC, tab_ALL_RT, tab_ALL_EU,tab_ALL_WC, tab_ALL_EPC, tab_DA_legend, tab_DA_pucost, tab_DA_pucarbon, tab_DA_puprofit);
% T_NE = table(tab_ALL_SC, tab_ALL_RT, tab_ALL_EU,tab_ALL_WC, tab_ALL_EPC, tab_NE_legend, tab_NE_pucost, tab_NE_pucarbon, tab_NE_puprofit);
% T_PMP = table(tab_ALL_SC, tab_ALL_RT, tab_ALL_EU,tab_ALL_WC, tab_ALL_EPC, tab_PMP_legend, tab_PMP_pucost, tab_PMP_pucarbon, tab_PMP_puprofit);
T_DART = table(tab_ALL_SC, tab_ALL_RT, tab_ALL_EU,tab_ALL_WC, tab_ALL_EPC, tab_DART_legend, tab_DART_pucost, tab_DART_pucarbon, tab_DART_puprofit);
