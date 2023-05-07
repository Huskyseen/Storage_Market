function out = sc_average(variable,num_sc,DA_un)


var_sum = 0;

    DA(un).sc_all.LMP_SP = zeros(1,T); DA(un).sc_all.LMP_MP = zeros(1,T); DA(un).sc_all.LMP_noES = zeros(1,T);DA(un).sc_all.LMP_DA = 0; DA(un).sc_all.LMP_UC = 0;DA(un).sc_all.LMP_RP = 0;
    DA(un).sc_all.profits_MP = 0; DA(un).sc_all.profits_SP = 0; DA(un).sc_all.profits_DA = 0; DA(un).sc_all.profits_RP = 0;
    DA(un).sc_all.gencarbon_MP = 0; DA(un).sc_all.gencarbon_SP = 0; DA(un).sc_all.gencarbon_noES = 0;
    for sc = 1:num_sc
        var_sum = var_sum + sum(DA(un).SC(sc).Iter(k).MP.g_cost);
    end



end