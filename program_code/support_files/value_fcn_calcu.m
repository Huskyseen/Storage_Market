function [VF VF_all] = value_fcn_calcu(lambda,seg_num,Ne, T, c, P, eta, ed, ef, sigma)

vEnd = zeros(Ne,1);  % generate value function samples
vEnd(1:floor(ef*100)) = 1e2; % use 100 as the penalty for final discharge level
v = zeros(Ne, T+1); % initialize the value function series
% v(1,1) is the marginal value of 0% SoC at the beginning of day 1
% V(Ne, T) is the maringal value of 100% SoC at the beginning of the last operating day
v(:,end) = vEnd; % update final value function
% process index
es = (0:ed:1)';
Ne = numel(es);
% calculate soc after charge vC = (v_t(e+P*eta))
eC = es + P*eta;
% round to the nearest sample
iC = ceil(eC/ed)+1;
iC(iC > (Ne+1)) = Ne + 2;
iC(iC < 2) = 1;
% calculate soc after discharge vC = (v_t(e-P/eta))
eD = es - P/eta;
% round to the nearest sample
iD = floor(eD/ed)+1;
iD(iD > (Ne+1)) = Ne + 2;
iD(iD < 2) = 1;

for t = T:-1:1 %     % Recalculate ES value fcn
    vi = v(:,t+1);
    if sigma == 0
        vo = CalcValueNoUnc(lambda(t), c, P, eta, vi, ed, iC, iD);
    else
        vo = CalcValueNormal(lambda(t), sigma, c, P, eta, vi, ed, iC, iD);
    end
    v(:,t) = vo;
end
vAvg = zeros(seg_num,T+1);
NN = (Ne-1)/seg_num;
for i = 1:seg_num
    vAvg(i,:) = mean(v((i-1)*NN + (1:(NN+1)),:));
end
VF.k = vAvg(:,2:(T+1));
VF.x0 = [0:1/seg_num:1-1/seg_num]' * ones(1,T);
VF.b(1,1:T) = 0;
for i = 2:1:seg_num
    VF.b(i,:) = VF.b(i-1,:) + VF.k(i-1,:) * (1/seg_num); % vAvg(i-1,2:1:(T+1)) * (1/seg_num);
end
VF_all.vAvg = vAvg;
VF_all.v = v;
end