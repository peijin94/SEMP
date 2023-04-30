t0_esti=x(1);
theta0_esti=x(2);
vs_esti=x(3);

t0_test = (-20:0.2:20)+t0_esti;
theta0_test = (-15:1:15)/180*pi+theta0_esti;
vs_test = (-0.01:0.0002:0.01)*3e5 + vs_esti;
vsw_test = 400 + (-100:10:300);

dt_t0_idx =1:length(t0_test);
parfor num_0 = 1:length(t0_test)
    
    dt_t0_idx(num_0) = func_dt2_pso(f_res_steA,f_res_steB,f_res_WIND,...
        t_res_steA, t_res_steB, t_res_WIND,...
        t0_test(num_0),theta0_esti,vs_esti,v_sw,angel_A,angel_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU);

end

dt_theta0_idx=1:length(theta0_test);
parfor num_0 = 1:length(theta0_test)
    
    dt_theta0_idx(num_0) = func_dt2_pso(f_res_steA,f_res_steB,f_res_WIND,...
        t_res_steA, t_res_steB, t_res_WIND,...
        t0_esti,theta0_test(num_0),vs_esti,v_sw,angel_A,angel_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU);

end

dt_vs_idx= 1:length(vs_test);
parfor num_0 = 1:length(vs_test)
    
    dt_vs_idx(num_0) = func_dt2_pso(f_res_steA,f_res_steB,f_res_WIND,...
        t_res_steA, t_res_steB, t_res_WIND,...
        t0_esti,theta0_esti,vs_test(num_0),v_sw,angel_A,angel_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU);

end

dt_vsw_idx= 1:length(vsw_test);
parfor num_0 = 1:length(vsw_test)
    
    dt_vsw_idx(num_0) = func_dt2_pso(f_res_steA,f_res_steB,f_res_WIND,...
        t_res_steA, t_res_steB, t_res_WIND,...
        t0_esti,theta0_esti,vs_esti,vsw_test(num_0),angel_A,angel_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU);

end

theta1_test=(0:10:360)/180*pi;
res = zeros(length(theta1_test),length(vsw_test));
for num_i=1:length(vsw_test)
    parfor num_j=1:length(theta1_test)
        
        tmp_var = func_dt2_pso(f_res_steA,f_res_steB,f_res_WIND,...
            t_res_steA, t_res_steB, t_res_WIND,...
            t0_esti,theta1_test(num_j),vs_esti,vsw_test(num_i),angel_A,angel_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU);
        
        res(num_j,num_i)=tmp_var;
    end
end

figure(6)

subplot(1,3,1)
plot(t0_test,dt_t0_idx,'r','linewidth',2)
xlim([min(t0_test),max(t0_test)])
hold on
plot(t0_esti,dt_t0_idx(round((1+length(dt_t0_idx))/2)),'bs');
xlabel('Time (second)');


subplot(1,3,2)
plot(theta0_test/pi*180,dt_theta0_idx,'r','linewidth',2)
xlim([min(theta0_test/pi*180),max(theta0_test/pi*180)])
hold on
plot(theta0_esti/pi*180,dt_theta0_idx(round((1+length(dt_theta0_idx))/2)),'bs');
xlabel('Angel (Degree)');

subplot(1,3,3)
plot(vs_test/3e5,dt_vs_idx,'r','linewidth',2)
xlim([min(vs_test/3e5),max(vs_test/3e5)])
hold on
plot(vs_esti/3e5,dt_vs_idx(round((1+length(dt_vs_idx))/2)),'bs');
xlabel('Source speed (c)')

% subplot(2,2,4)
% plot(vsw_test,dt_vsw_idx,'r','linewidth',2)
% xlim([min(vsw_test),max(vsw_test)])
% hold on
% xlabel('SW Speed (km/s)')

set(gcf,'position',[5    46   680   320])

figure(7)
[V,T]=meshgrid(vsw_test,theta1_test/pi*180);
h=pcolor(T,V,res);
shading interp
set(h,'edgecolor','none')
xlabel('Angel (Degree)')
ylabel('Solar wind speed (km/s)')
xticks([0:60:360])
colorbar
set(gcf,'position',[645    58   375   308])