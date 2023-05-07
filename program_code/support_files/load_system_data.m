
function sys_para = load_system_data (T, K, num_RT)

raw_demand = csvread('demand.csv',1,0);
raw_wind = csvread('windCF.csv',1,0);
raw_gen = csvread('generator_data.csv',12,2);

%% demand 360 days
num_len = length(raw_demand(:,1));
num_sce = 90;
for i = 1:num_sce
    st = i;
    ed = num_len-num_sce + i;
    load_st = ((i-1)*96+1);
    load_ed = i*96;
    load_before(load_st:load_ed,[1,2,3]) = raw_demand(st:num_sce:ed,[1,2,11]);
    wind_before (load_st:load_ed,[1,2,3]) = raw_wind(st:num_sce:ed,[1,2,3]);
end
%%

% load_kmeans = reshape(load_before(:,3), 96, num_sce);
% wind_kmeans = reshape(wind_before(:,3), 96, num_sce);
% 
% X = [load_kmeans/max(max(load_kmeans)); wind_kmeans];
% [~, C] = kmeans(X', K);
% 
% sys_para.load_after_kmeans = C(:, 1:T)' * max(max(load_kmeans));
% sys_para.wind_after_kmeans = C(:, 96+(1:T))';

%%
for i = 1:num_sce
    load_st = ((i-1)*96+1);
    load_ed = i*96;
    new_i = (i-1)*4 + 1; % 96 points denote [4] days
    load_kmeans(:,new_i) =   load_before(load_st:load_st+T-1,3);
    load_kmeans(:,new_i + 1) =   load_before(load_st+T:load_st+2*T-1,3);
    load_kmeans(:,new_i + 2) =   load_before(load_st+2*T:load_st+3*T-1,3);
    load_kmeans(:,new_i + 3) =   load_before(load_st+3*T:load_st+4*T-1,3);
    wind_kmeans(:,new_i) =   wind_before(load_st:load_st+T-1,3);
    wind_kmeans(:,new_i + 1) =   wind_before(load_st+T:load_st+2*T-1,3);
    wind_kmeans(:,new_i + 2) =   wind_before(load_st+2*T:load_st+3*T-1,3);
    wind_kmeans(:,new_i + 3) =   wind_before(load_st+3*T:load_st+4*T-1,3);
end
id_load = kmeans(load_kmeans',5);
id_wind = kmeans(wind_kmeans',5);
id_load = [[3;3;2;1;3;2;1;3;2;1;3;3;1;3;3;3;3;3;3;5;3;3;5;2;3;5;2;1;5;2;1;4;2;1;4;5;1;4;5;3;4;5;3;3;5;3;3;5;3;3;5;5;3;5;5;1;5;5;1;4;5;1;4;2;1;4;2;2;4;2;2;2;2;2;2;2;2;2;2;2;2;2;2;1;2;2;1;4;2;1;4;5;1;4;5;5;4;5;5;2;5;5;2;5;5;2;5;2;2;5;2;1;5;2;1;1;2;1;1;5;5;2;1;3;2;1;3;5;1;3;5;5;3;5;5;5;5;5;5;5;5;5;5;1;5;5;1;1;5;1;1;5;1;1;5;5;1;5;5;5;5;5;5;5;5;5;5;5;5;5;5;1;5;5;1;4;5;1;4;2;1;4;2;2;4;2;2;5;2;2;5;2;2;5;2;2;5;2;2;1;2;2;1;1;2;1;1;5;1;1;5;5;1;5;5;5;5;5;5;5;5;5;5;2;5;5;2;1;5;2;1;1;2;1;1;5;1;1;5;5;1;4;5;3;4;5;3;3;5;3;3;3;3;3;3;5;3;3;5;2;3;5;2;1;5;2;1;5;2;1;5;5;1;5;5;5;5;5;5;5;5;5;5;2;5;5;2;1;5;2;1;4;2;1;4;2;1;4;2;2;4;2;2;2;2;2;2;2;2;2;2;2;2;2;2;1;2;2;1;1;2;1;1;5;1;1;5;5;1;5;5;2;5;5;2;2;5;2;2;2;2;2;2;1;2;2;1;4;2;1;4;2;1;4;2;5;4;2;5;5]];
id_wind = [[4;1;5;5;3;3;3;3;4;5;3;5;5;3;4;5;4;1;3;3;4;5;3;5;5;3;3;5;3;3;3;5;4;4;2;1;1;3;4;2;4;4;2;4;2;5;2;2;2;2;3;5;3;3;3;4;3;5;1;5;1;3;2;2;5;3;5;2;1;4;1;5;3;5;1;4;1;3;5;1;3;5;5;5;3;5;5;5;3;3;5;4;5;2;4;3;3;3;5;4;2;5;3;5;5;2;2;3;5;2;1;5;1;3;3;5;4;2;5;3;1;1;3;5;5;5;3;3;3;3;3;5;5;3;4;3;5;3;3;3;3;5;1;5;3;1;3;5;5;3;5;4;1;3;3;3;3;5;5;1;3;3;3;3;3;3;3;3;5;3;3;3;3;5;5;5;3;5;5;1;3;3;5;3;3;3;3;3;3;3;3;5;5;5;3;3;3;5;5;3;3;4;3;3;3;5;5;3;3;5;3;5;3;3;3;3;3;3;3;3;5;4;5;3;3;3;3;3;3;3;3;3;5;5;3;2;1;3;3;1;3;3;3;3;5;3;5;3;5;5;3;3;3;3;5;1;3;5;3;3;3;4;3;5;3;3;3;3;5;3;3;5;1;5;5;3;5;3;3;3;5;3;3;3;5;5;4;2;2;2;3;4;4;1;3;5;1;3;3;3;3;3;3;4;5;4;1;5;5;2;1;5;4;1;4;4;2;2;5;5;5;5;2;1;3;5;5;4;2;2;2;3;5;4;5;3;4;2;3;3;3;1;3;3;4;1;3;4;2;1;3;5;2;5;4;3;3;5;4;4]];

l1 = sum((id_load==1)) / 360;
l2 = sum((id_load==2)) / 360;
l3 = sum((id_load==3)) / 360;
l4 = sum((id_load==4)) / 360;
l5 = sum((id_load==5)) / 360;
sys_para.c_sc = [l1, l2, l3, l4, l5];
% w1 = sum((id_wind==1)) / 360;
% w2 = sum((id_wind==2)) / 360;
% w3 = sum((id_wind==3)) / 360;
% w4 = sum((id_wind==4)) / 360;
% w5 = sum((id_wind==5)) / 360;

sys_para.load_after_kmeans(:,1:5) =  load_kmeans(1:T,[325, 6, 53, 69, 101]);
sys_para.wind_after_kmeans(:,1:5) =  wind_kmeans(1:T,[180, 330, 260, 152, 3]);

sys_para.gen = raw_gen;
sys_para.g_min = raw_gen(:,2);
sys_para.g_max = raw_gen(:,1);
sys_para.ramp_min = -raw_gen(:,6);
sys_para.ramp_max = raw_gen(:,6);
sys_para.Tup = raw_gen(:,4);
sys_para.Tdn = raw_gen(:,5);
sys_para.gencarbon = raw_gen(:,11);
% sys_para.g_wind = coe_wind .* sys_para.wind(1:T,3);
% sys_para.noise = [-1.34988694015652;3.03492346633185;0.725404224946106;-0.0630548731896562;0.714742903826096;-0.204966058299775;-0.124144348216312;1.48969760778547;1.40903448980048;1.41719241342961;0.671497133608081;-1.20748692268504;0.717238651328839;1.63023528916473;0.488893770311789;1.03469300991786;0.726885133383238;-0.303440924786016;0.293871467096658;-0.787282803758638;0.888395631757642;-1.14707010696915;-1.06887045816803;-0.809498694424876];

% noise = normrnd(0,1,T,num_RT);% MU SIGMA M*N matrix;
sys_para.noise = [0.327678163907201	-1.14068114466963	0.316500360797716	0.176577794642316	0.144001801404465
-0.238301504589733	-1.09334345623960	-1.34286923662193	0.970737823554689	-1.63866572993389
0.229596893220314	-0.433609296474824	-1.03218434407217	-0.413972274974230	-0.760089998635267
0.439997904822629	-0.168469878275448	1.33121588506497	-0.438270518204902	-0.818793096250257
-0.616865928889227	-0.218533560026581	-0.418903195029849	2.00339061086226	0.519728888133619
0.274836786911666	0.541334435719376	-0.140321722056366	0.950993499549085	-0.0141600590972047
0.601102032468295	0.389266203843264	0.899822328897224	-0.432003843727780	-1.15552936828724
0.0923079512389623	0.751228984688333	-0.300111005615676	0.648940737363587	-0.00952491609816556
1.72984139157236	1.77825589929100	1.02936571210310	-0.360076301153972	-0.689810537631710
-0.608557444738319	1.22306255173381	-0.345065971567321	0.705885019349416	-0.666699153601164
-0.737059771697806	-1.28325610460477	1.01280186426298	1.41584906843659	0.864149421165126
-1.74987930638763	-2.32895451628334	0.629334584931419	-1.60451566859706	0.113419436226868
0.910482579647112	0.901931466951714	-0.213015082641055	1.02885306900203	0.398362846165994
0.867082552947325	-1.83563868373519	-0.865697308360524	1.45796778066199	0.883969890234671
-0.0798928390580371	0.0667569114368658	-1.04310830133763	0.0474713232748285	0.180257693987047
0.898475989377142	0.0354794858375770	-0.270068812648099	1.74625671011842	0.550854522057470
0.183703423091249	2.22716807816787	-0.438141355602144	0.155387514201181	0.682964276111937
0.290790134884454	-0.0692142540220484	-0.408674314796326	-1.23711968466263	1.17060866003560
0.112944717021051	-0.507323064614498	0.983545235205556	-2.19349427883461	0.475860587278343
0.439952188872440	0.235809672576244	-0.297697144009373	-0.333407067263734	1.41223268644450
0.101662443700341	0.245804851893843	1.14367891077096	0.713543302564059	0.0226084843095981
2.78733522781344	0.0700452094168079	-0.531620117507069	0.317407733234497	-0.0478694102202059
-1.16666503019464	-0.608580510079949	0.972565728008653	0.413610390293130	1.70133465427496
-1.85429908268969	-1.22259338018663	-0.522250484993549	-0.577085583637940	-0.509711712767427];


end