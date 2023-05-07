function Rout = M_RTED(UC, MPC, e0, P, E, eta, c, VF, Tw, is_DART)
% singe or multi-period real-time dispatch 
% Single period - Tw = 1;
% Multi period - Tw > 1

% UC - results from UC
% MPC - system data



%% read UC result
u = UC.u;
v = UC.v;
z = UC.z;
g0 = UC.g(:,1);     

%% read system data
% D = MPC.load(:,3)';
W = MPC.g_wind_noise';
gMin = MPC.g_min;
gMax = MPC.g_max;
rMax = MPC.ramp_max;
c1 = MPC.gen(:,9);
c2 = MPC.gen(:,10);


T = 24;

%% add storage dispatch to demand profile
% note that if we dispatch in RTED, then there is no storage in DAUC, hence
% p_c and p_d are zeros

% the only case that p_c and p_d takes on non-zero value is the DA case,
% in which storage are dispatched in DA


if is_DART==1
    D = MPC.load(:,3)'; 
else
    D = MPC.load(:,3)' + UC.p_c - UC.p_d; 
end

%% read storage opportunity value linearization
% row number - segment
% column number - periods

Vk = VF.k;
Ve = VF.x0*E;
Vb = VF.b*E;

%% run ED
% initialize data record
gOut = zeros(size(u));
wOut = zeros(1,T);
eOut = zeros(1,T);
pcOut = zeros(1,T);
pdOut = zeros(1,T);
lOut = zeros(1,T);
cOut = zeros(1,T);
cpOut = zeros(1,T);
qOut = zeros(1,T);

% these two record initial generation and storage
ee = e0;
gg = g0;


for t = 1:T
    
    tE = min(t+Tw-1, T); % calculate end period
    
    % Run real-time ED with specified horizon and value function segments
    Rtemp = RTED(D(t:tE), c1, c2, gg, gMax, gMin, rMax, u(:,t:tE), v(:,t:tE), z(:,t:tE), ...
        W(t:tE), ee, P, E, eta, c, Vk(:,tE), Ve(:,tE), Vb(:,tE), tE-t+1);
    
    % record the first result
    gOut(:,t) = Rtemp.g(:,1);
    wOut(t) = Rtemp.w(:,1);
    eOut(t) = Rtemp.e(:,1);
    pdOut(t) = Rtemp.p_d(:,1);
    pcOut(t) = Rtemp.p_c(:,1);
    cOut(t) = Rtemp.obj(:,1);
    lOut(t) = Rtemp.LMP(:,1);
    cpOut(t) = Rtemp.cp;
    qOut(t) = Rtemp.q(:,1);
    
    % update starting point for next period
    gg = Rtemp.g(:,1);
    ee = Rtemp.e(:,1);
    
    



end

% record results
Rout.g = gOut;
Rout.w = wOut;
Rout.e = eOut;
Rout.p_d = pdOut;
Rout.p_c = pcOut;
Rout.obj = cOut;
Rout.LMP = lOut;
Rout.cp = sum(cpOut);
Rout.q = qOut;
