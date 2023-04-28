addpath('../');

%release the mdata structure
struct2vars(mdata);

if ~exist('ne_par','var')
    ne_par = 4;
end

if harmo_f(1)
   f_res_steA = 1/2*f_res_steA; 
end
if harmo_f(2)
    f_res_WIND = 1/2*f_res_WIND; 
end
if harmo_f(3)
    f_res_steB = 1/2*f_res_steB;
end

op_func_pso = @(xinp)(func_dt2_pso( f_res_steA, f_res_steB, f_res_WIND,...
     t_res_steA*60,  t_res_steB*60,  t_res_WIND*60,...
    xinp(1),xinp(2),xinp(3), v_sw,deg2rad( angel_A),deg2rad( angel_B),...
     r_ste_A_AU, r_WIND_AU, r_ste_B_AU,ne_par));

nvars = 3;
duration = ( t2- t1)*24*3600;
ub=[ duration , 2*pi , 3e5  ];
lb=[-600       ,  0   ,   0 ];

options = optimoptions(@particleswarm,'SwarmSize',280,...
    'HybridFcn','fmincon',...
    'Display','off',...
    'MaxStallIterations',12,...
    'UseParallel',true);

% if we have the x already in pso.mat we can skip these two lines 
tic
[x,fval,exitflag] = particleswarm(op_func_pso,nvars,lb,ub,options);
toc
disp(['final err: ',num2str(fval)])
disp(['v0:',num2str(x(3)/3e5)])
disp(['theta0:',num2str(x(2)/pi*180)])
disp(['t0:',num2str(x(1))])
clim_ste=20;
clim_wind=15;
fname_output=['fig_', fname_wind(end-15:end-8)];

draw_result_parker_signal_harmo2(x, v_sw, r_ste_A_AU, r_WIND_AU,...
     r_ste_B_AU,deg2rad( angel_A),deg2rad( angel_B),...
     f_res_steA, t_res_steA*60 , f_res_WIND,...
     t_res_WIND*60 , f_res_steB, t_res_steB*60 ,...
     T_ste_small, T_wind_small, F_ste_small, F_wind_small,...
     S_ste_A_small, S_ste_B_small, S_wind_small,[ t1, t2],...
    clim_ste,clim_wind,harmo_f,fname_output,ne_par)
 
%sensitive_calc_mdata;
