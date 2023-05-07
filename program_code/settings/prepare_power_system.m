
function mpc = prepare_power_system (sys_para, coe_wind, noise_rate, T, sc, iRT)
%% load and wind
mpc.load(:,3) = sys_para.load_after_kmeans(:,sc);
mpc.wind(:,3) = sys_para.wind_after_kmeans(:,sc);

mpc.gen = sys_para.gen;
mpc.g_min = mpc.gen(:,2);
mpc.g_max = mpc.gen(:,1);
mpc.ramp_min = -mpc.gen(:,6);
mpc.ramp_max = mpc.gen(:,6);
mpc.Tup = mpc.gen(:,4);
mpc.Tdn = mpc.gen(:,5);
mpc.g_wind = coe_wind .* mpc.wind(1:T,3);

%% noise
noise_wind = noise_rate * mean(mpc.g_wind) * sys_para.noise(1:T, iRT);
noise_wind(noise_wind>noise_rate * mean(mpc.g_wind)) = noise_rate * mean(mpc.g_wind);
noise_wind(noise_wind<-noise_rate * mean(mpc.g_wind)) = -noise_rate * mean(mpc.g_wind);
g_wind_with_noise = mpc.g_wind + noise_wind;
g_wind_with_noise(g_wind_with_noise<0) = 0;
mpc.g_wind_noise = g_wind_with_noise;
end