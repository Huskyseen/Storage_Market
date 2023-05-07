function vo = CalcValueNormal(mu, sigma, c, P, eta, vi, ed, iC, iD)
%%
% Title: Calculate Risk-Neutral value function using deterministic price
% Inputs:
%   mu - price mean
%   sigma - price deviation
%   c - marginal discharge cost
%   P - power rating w.r.t to energy rating and sampling time, i.e., a
%   1MW/2MWh battery with 5min resolution -> P = 0.5/12 
%   eta - efficiency
%   vi - input value function for the next time period, which equals to
%   v_t(e) where e is sampled from 0 to 1 at the granularity e
%   ed - granularity at which vi is sampled, in p.u. to energy rating
%
% Outputs:
%   vo - value function for the current time period sampled at ed

%% 

% create samples of e
% es = (0:ed:1)'; 
% Ne = numel(es); % number of samples

% add a large number of upper and lower v, where the first point is
% v_t(0-) = +infty, and the second point is v_t(0), the second largest one is
% v_t(1), and the largest one is v_t(1+) = -infty
lNum = 1e5;
v_foo = [lNum;vi;-lNum];

% % calculate soc after charge vC = (v_t(e+P*eta))
% eC = es + P*eta; 
% % round to the nearest sample 
% iC = ceil(eC/ed)+1;
% iC(iC > (Ne+1)) = Ne + 2;
% iC(iC < 2) = 1;
vC = v_foo(iC);


% % calculate soc after discharge vC = (v_t(e-P/eta))
% eD = es - P/eta; 
% % round to the nearest sample 
% iC = floor(eD/ed)+1;
% iC(iC > (Ne+1)) = Ne + 2;
% iC(iC < 2) = 1;
vD = v_foo(iD);

% % get index of infeasible low states
% iEiFl = vi >= lNum;
% iCiFl = vC >= lNum;
% iDiFl = vD >= lNum;
% 
% % get index of infeasible high states
% iEiFu = vi <= -lNum;
% iCiFu = vC <= -lNum;
% iDiFu = vD <= -lNum;

% calculate CDF and PDF
FtEC = normcdf(vi*eta, mu, sigma); % F_t(v_t(e)*eta)
FtCC = normcdf(vC*eta, mu, sigma); % F_t(v_t(e+P*eta)*eta)
FtED = normcdf((vi/eta + c).*((vi/eta + c) > 0), mu, sigma); % F_t(v_t(e)/eta + c) 
FtDD = normcdf((vD/eta + c).*((vD/eta + c) > 0), mu, sigma); % F_t(v_t(e-P/eta)/eta + c) 

ftEC = normpdf(vi*eta, mu, sigma); % f_t(v_t(e)*eta)
ftCC = normpdf(vC*eta, mu, sigma); % f_t(v_t(e+P*eta)*eta)
ftED = normpdf((vi/eta + c).*((vi/eta + c) > 0), mu, sigma).*((vi/eta + c) > 0); % f_t(v_t(e)/eta + c) 
ftDD = normpdf((vD/eta + c).*((vD/eta + c) > 0), mu, sigma).*((vD/eta + c) > 0); % f_t(v_t(e-P/eta)/eta + c) 


% ftEC = normpdf(vi*eta, mu, sigma); % f_t(v_t(e)*eta)
% ftCC = normpdf(vC*eta, mu, sigma); % f_t(v_t(e+P*eta)*eta)
% ftED = normpdf((vi/eta + c).*((vi/eta + c) > 0), mu, sigma).*((vi/eta + c) > 0); % f_t(v_t(e)/eta + c) 
% ftDD = normpdf((vD/eta + c).*((vD/eta + c) > 0), mu, sigma).*((vD/eta + c) > 0); % f_t(v_t(e-P/eta)/eta + c) 

% calculate terms
% calculate terms
Term1 = vC .* FtCC;
Term2 = ( mu * (FtEC - FtCC) - sigma^2 * (ftEC - ftCC) ) / eta;
Term3 = vi .* (FtED - FtEC);
Term4 = ( mu * (FtDD - FtED) - sigma^2 * (ftDD - ftED) ) * eta;
Term5 = - c * eta * (FtDD - FtED);
Term6 = vD .* (1-FtDD);


% modify for feasibility
% Term1((iEiFl + iCiFl) == 2) = lNum;
% Term1((iEiFu + iCiFu) == 2) = -lNum;
% Term2((iEiFl + iDiFl) == 2) = lNum;
% Term2((iEiFu + iDiFu) == 2) = -lNum;
% Term1(iCiFu) = -lNum;
% Term2(iDiFl) = lNum;

% output new value function samped at ed
vo = Term1 + Term2 + Term3 + Term4 + Term5 + Term6;
% vo(vo >= 1e6) = lNum;
% vo(vo <= -1e6) = -lNum;
