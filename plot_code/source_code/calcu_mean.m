 reviewer = 0;

iEU = 1;
 for iS = iS_index % index of scenarios
     for iRT = 1:nRT % index of RT cases
     for k = 1:nK % index of iterations
         iEC = mod(k,nP);%index of P_real
         if iEC==0
             iEC=nP;
         end

         Iter = SC(iS).ESU(iEU).RT(iRT).Iter(k);

         UC_noES_cost = sum(Iter.UC.comit_cost);
         PMP_cost(iS,iRT,k) = sum(Iter.PC.obj) + sum(Iter.PC.p_d * c) + sum(Iter.PC.comit_cost); % changed
         SP_cost(iS,iRT,k) = sum(Iter.SP.obj) + sum(Iter.SP.p_d * c) + UC_noES_cost;
         NE_cost(iS,iRT,k) = sum(Iter.NE.obj) + sum(Iter.NE.p_d * c) + UC_noES_cost;
         UC_withES_cost = sum(Iter.DADA.comit_cost);
         DA_cost(iS,iRT,k) = sum(Iter.DART.obj) + sum(Iter.DADA.p_d * c) ...
             + UC_withES_cost;
         DART_cost(iS,iRT,k) = sum(Iter.DART2.obj) + sum(Iter.DART2.p_d * c) + ...
             + UC_withES_cost;
         
         total_load = sum(Iter.mpc.load(:,3));
         total_wind = sum(Iter.mpc.g_wind_noise);

         if reviewer == 0
             PMP_pucost(iS,iRT,k) = PMP_cost(iS,iRT,k)/total_load;
             SP_pucost(iS,iRT,k) = SP_cost(iS,iRT,k)/total_load;
             NE_pucost(iS,iRT,k) = NE_cost(iS,iRT,k)/total_load;
             DA_pucost(iS,iRT,k) = DA_cost(iS,iRT,k)/total_load;
             DART_pucost(iS,iRT,k) = DART_cost(iS,iRT,k)/total_load;

             PMP_pucarbon(iS,iRT,k) = sum(sum(Iter.PC.g,2).*sys_para.gencarbon)/total_load;
             SP_pucarbon(iS,iRT,k) = sum(sum(Iter.SP.g,2).*sys_para.gencarbon)/total_load;
             NE_pucarbon(iS,iRT,k) = sum(sum(Iter.NE.g,2).*sys_para.gencarbon)/total_load;
             DA_pucarbon(iS,iRT,k) = sum(sum(Iter.DART.g,2).*sys_para.gencarbon)/total_load;
             DART_pucarbon(iS,iRT,k) = sum(sum(Iter.DART2.g,2).*sys_para.gencarbon)/total_load;
         else
             NE_pucost(iS,iRT,k) = NE_cost(iS,iRT,k)/total_load;
             PMP_pucost(iS,iRT,k) = PMP_cost(iS,iRT,k)/total_load -NE_pucost(iS,iRT,k);
             SP_pucost(iS,iRT,k) = SP_cost(iS,iRT,k)/total_load - NE_pucost(iS,iRT,k);
             
             DA_pucost(iS,iRT,k) = DA_cost(iS,iRT,k)/total_load - NE_pucost(iS,iRT,k);
             DART_pucost(iS,iRT,k) = DART_cost(iS,iRT,k)/total_load - NE_pucost(iS,iRT,k);

             NE_pucarbon(iS,iRT,k) = sum(sum(Iter.NE.g,2).*sys_para.gencarbon)/total_load;
             PMP_pucarbon(iS,iRT,k) = sum(sum(Iter.PC.g,2).*sys_para.gencarbon)/total_load - NE_pucarbon(iS,iRT,k);
             SP_pucarbon(iS,iRT,k) = sum(sum(Iter.SP.g,2).*sys_para.gencarbon)/total_load - NE_pucarbon(iS,iRT,k);
             DA_pucarbon(iS,iRT,k) = sum(sum(Iter.DART.g,2).*sys_para.gencarbon)/total_load - NE_pucarbon(iS,iRT,k);
             DART_pucarbon(iS,iRT,k) = sum(sum(Iter.DART2.g,2).*sys_para.gencarbon)/total_load - NE_pucarbon(iS,iRT,k);

         end
         

         PMP_wind(iS,iRT,k) = sum(Iter.PC.w)/total_wind;%index changed
         SP_wind(iS,iRT,k) = sum(Iter.SP.w)/total_wind;
         NE_wind(iS,iRT,k) = sum(Iter.NE.w)/total_wind;
         DA_wind(iS,iRT,k) = sum(Iter.DART.w)/total_wind;
         DART_wind(iS,iRT,k) = sum(Iter.DART2.w)/total_wind;

         PMP_puprofit(iS,iRT,k) = sum([Iter.PC.LMP .* (Iter.PC.p_d - Iter.PC.p_c)]./ES_energy(iEC)) ...
             - c*sum(Iter.PC.p_d)./ES_energy(iEC);
         SP_puprofit(iS,iRT,k) = sum([Iter.SP.LMP .* (Iter.SP.p_d - Iter.SP.p_c)]./ES_energy(iEC))...
             - c*sum(Iter.SP.p_d)./ES_energy(iEC);
         NE_puprofit(iS,iRT,k) = 0;
         DA_puprofit(iS,iRT,k) = sum([Iter.DADA.LMP .* (Iter.DADA.p_d - Iter.DADA.p_c)]./ES_energy(iEC))...
             - c*sum(Iter.DADA.p_d)./ES_energy(iEC);
         pdnet = Iter.DART2.p_d - Iter.DADA.p_d;
         pcnet = Iter.DART2.p_c - Iter.DADA.p_c;
         DART_puprofit(iS,iRT,k) = sum([Iter.DART2.LMP .* (pdnet - pcnet)]./ES_energy(iEC)) - c*sum(Iter.DART2.p_d)./ES_energy(iEC) ...
                                 + sum([Iter.DADA.LMP .* (Iter.DADA.p_d - Iter.DADA.p_c)]./ES_energy(iEC));
         PMP_puprofit_nomc(iS,iRT,k) = sum([Iter.PC.LMP .* (Iter.PC.p_d - Iter.PC.p_c)]./ES_energy(iEC)) ...
             - 0*sum(Iter.PC.p_d)./ES_energy(iEC);
         SP_puprofit_nomc(iS,iRT,k) = sum([Iter.SP.LMP .* (Iter.SP.p_d - Iter.SP.p_c)]./ES_energy(iEC))...
             - 0*sum(Iter.SP.p_d)./ES_energy(iEC);
         NE_puprofit_nomc(iS,iRT,k) = 0;
         DA_puprofit_nomc(iS,iRT,k) = sum([Iter.DADA.LMP .* (Iter.DADA.p_d - Iter.DADA.p_c)]./ES_energy(iEC))...
             - 0*sum(Iter.DADA.p_d)./ES_energy(iEC);
         DART_puprofit_nomc(iS,iRT,k) = sum([Iter.DART2.LMP .* (pdnet - pcnet)]./ES_energy(iEC)) - 0*sum(Iter.DART2.p_d)./ES_energy(iEC) ...
             + sum([Iter.DADA.LMP .* (Iter.DADA.p_d - Iter.DADA.p_c)]./ES_energy(iEC));

         SP_p_cycle(iS,iRT,k) = sum(Iter.SP.p_c .* eta) / ES_energy(iEC);
         PMP_p_cycle(iS,iRT,k) = sum(Iter.PC.p_c .* eta) / ES_energy(iEC);
         DA_p_cycle(iS,iRT,k) = sum(Iter.DADA.p_c .* eta) / ES_energy(iEC);
         DART_p_cycle(iS,iRT,k) = sum(Iter.DART2.p_c .* eta) / ES_energy(iEC);

         % load shedding
         PMP_q(iS,iRT,k) = sum(Iter.SP.q) .*0;
         SP_q(iS,iRT,k) = sum(Iter.SP.q);
         NE_q(iS,iRT,k) = sum(Iter.NE.q);
         DA_q(iS,iRT,k) = sum(Iter.DART.q);
         DART_q(iS,iRT,k) = sum(Iter.DART2.q);


         SP_LMP(iS,iRT,k) = std(Iter.SP.LMP);
         NE_LMP(iS,iRT,k) = std(Iter.NE.LMP);
         PMP_LMP(iS,iRT,k) = std(Iter.PC.LMP);
         DA_LMP(iS,iRT,k) = std(Iter.DART.LMP);
         DART_LMP(iS,iRT,k) = std(Iter.DART2.LMP);

         SP_avg_LMP_og(iS,iRT,k)   = sum(Iter.SP.LMP .* Iter.mpc.load(:,3)') /total_load;
         NE_avg_LMP_og(iS,iRT,k)   = sum(Iter.NE.LMP .* Iter.mpc.load(:,3)') /total_load;
         PMP_avg_LMP_og(iS,iRT,k)  = sum(Iter.PC.LMP .* Iter.mpc.load(:,3)') /total_load;
         DA_avg_LMP_og(iS,iRT,k)   = sum(Iter.DART.LMP .* Iter.mpc.load(:,3)') /total_load;
         DART_avg_LMP_og(iS,iRT,k) = sum(Iter.DART2.LMP.* Iter.mpc.load(:,3)') /total_load;


     end
     end
 end
 


PMP_avg_pucost = squeeze(mean(sum(PMP_pucost(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_avg_pucost = squeeze(mean(sum(SP_pucost(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
NE_avg_pucost = squeeze(mean(sum(NE_pucost(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_avg_pucost = squeeze(mean(sum(DA_pucost(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DART_avg_pucost = squeeze(mean(sum(DART_pucost(iS_index,:,:) .* coe_sc(iS_index)',1),2))';


PMP_avg_pucarbon = squeeze(mean(sum(PMP_pucarbon(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_avg_pucarbon = squeeze(mean(sum(SP_pucarbon(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
NE_avg_pucarbon = squeeze(mean(sum(NE_pucarbon(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_avg_pucarbon = squeeze(mean(sum(DA_pucarbon(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DART_avg_pucarbon = squeeze(mean(sum(DART_pucarbon(iS_index,:,:) .* coe_sc(iS_index)',1),2))';

PMP_avg_puprofit = squeeze(mean(sum(PMP_puprofit(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_avg_puprofit = squeeze(mean(sum(SP_puprofit(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
NE_avg_puprofit = squeeze(mean(sum(NE_puprofit(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_avg_puprofit = squeeze(mean(sum(DA_puprofit(iS_index,:,:) .* coe_sc(iS_index)',1),2))'; 
DART_avg_puprofit = squeeze(mean(sum(DART_puprofit(iS_index,:,:) .* coe_sc(iS_index)',1),2))';

PMP_avg_puprofit_nomc = squeeze(mean(sum(PMP_puprofit_nomc(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_avg_puprofit_nomc = squeeze(mean(sum(SP_puprofit_nomc(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
NE_avg_puprofit_nomc = squeeze(mean(sum(NE_puprofit_nomc(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_avg_puprofit_nomc = squeeze(mean(sum(DA_puprofit_nomc(iS_index,:,:) .* coe_sc(iS_index)',1),2))'; 
DART_avg_puprofit_nomc = squeeze(mean(sum(DART_puprofit_nomc(iS_index,:,:) .* coe_sc(iS_index)',1),2))';

PMP_avg_pcycle = squeeze(mean(sum(PMP_p_cycle(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_avg_pcycle  = squeeze(mean(sum(SP_p_cycle(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_avg_pcycle  = squeeze(mean(sum(DA_p_cycle(iS_index,:,:) .* coe_sc(iS_index)',1),2))'; 
DART_avg_pcycle  = squeeze(mean(sum(DART_p_cycle(iS_index,:,:) .* coe_sc(iS_index)',1),2))';


PMP_avg_q = squeeze(mean(sum(PMP_q(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_avg_q = squeeze(mean(sum(SP_q(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
NE_avg_q = squeeze(mean(sum(NE_q(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_avg_q = squeeze(mean(sum(DA_q(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DART_avg_q = squeeze(mean(sum(DART_q(iS_index,:,:) .* coe_sc(iS_index)',1),2))';


PMP_std_LMP = squeeze(mean(sum(PMP_LMP(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
SP_std_LMP = squeeze(mean(sum(SP_LMP(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
NE_std_LMP = squeeze(mean(sum(NE_LMP(iS_index,:,:) .* coe_sc(iS_index)',1),2))';
DA_std_LMP = squeeze(mean(sum(DA_LMP(iS_index,:,:) .* coe_sc(iS_index)',1),2))'; 
DART_std_LMP = squeeze(mean(sum(DART_LMP(iS_index,:,:) .* coe_sc(iS_index)',1),2))';


SP_avg_LMP  = squeeze(mean(sum(SP_avg_LMP_og(iS_index,:,:) .* coe_sc(iS_index)',1),2))';  
NE_avg_LMP   = squeeze(mean(sum(NE_avg_LMP_og(iS_index,:,:) .* coe_sc(iS_index)',1),2))';   
PMP_avg_LMP = squeeze(mean(sum(PMP_avg_LMP_og(iS_index,:,:) .* coe_sc(iS_index)',1),2))';  
DA_avg_LMP   = squeeze(mean(sum(DA_avg_LMP_og(iS_index,:,:) .* coe_sc(iS_index)',1),2))';   
DART_avg_LMP = squeeze(mean(sum(DART_avg_LMP_og(iS_index,:,:) .* coe_sc(iS_index)',1),2))';   



% for reviewer 4
PMP_sc_pucost = squeeze(mean(PMP_pucost,2));
SP_sc_pucost = squeeze(mean(SP_pucost,2));
NE_sc_pucost = squeeze(mean(NE_pucost,2));
DA_sc_pucost = squeeze(mean(DA_pucost,2));
DART_sc_pucost = squeeze(mean(DART_pucost,2));
% for reviewer 4
PMP_sc_pucarbon = squeeze(mean(PMP_pucarbon,2));
SP_sc_pucarbon = squeeze(mean(SP_pucarbon,2));
NE_sc_pucarbon = squeeze(mean(NE_pucarbon,2));
DA_sc_pucarbon = squeeze(mean(DA_pucarbon,2));
DART_sc_pucarbon = squeeze(mean(DART_pucarbon,2));


aaaa=0;
if aaaa ==1
PMP_avg_pucost = squeeze(mean(PMP_pucost,1));
SP_avg_pucost = squeeze(mean(SP_pucost,1));
NE_avg_pucost = squeeze(mean(NE_pucost,1));
DA_avg_pucost = squeeze(mean(DA_pucost,1));
DART_avg_pucost = squeeze(mean(DART_pucost,1));


PMP_avg_pucarbon = squeeze(mean(PMP_pucarbon,1));
SP_avg_pucarbon = squeeze(mean(SP_pucarbon,1));
NE_avg_pucarbon = squeeze(mean(NE_pucarbon,1));
DA_avg_pucarbon = squeeze(mean(DA_pucarbon,1));
DART_avg_pucarbon = squeeze(mean(DART_pucarbon,1));

PMP_avg_puprofit = squeeze(mean(PMP_puprofit,1));
SP_avg_puprofit = squeeze(mean(SP_puprofit,1));
NE_avg_puprofit = squeeze(mean(NE_puprofit,1));
DA_avg_puprofit = squeeze(mean(DA_puprofit,1)); 
DART_avg_puprofit = squeeze(mean(DART_puprofit,1));



PMP_avg_q = squeeze(mean(PMP_q,1));
SP_avg_q = squeeze(mean(SP_q,1));
NE_avg_q = squeeze(mean(NE_q,1));
DA_avg_q = squeeze(mean(DA_q,1));
DART_avg_q = squeeze(mean(DART_q,1));
end
