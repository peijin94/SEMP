% the target function, calculates the total time deviation
% author : P.J.Zhang
% date :  2018-5-9 13:56:37

function t=func_dt2_pso_split(ste_A_freq,ste_B_freq,WIND_freq,...
    t_STE_A_start,t_STE_B_start,t_WIND_start,...
    theta0,v_sw,alpha_A,alpha_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU)
    
    dt2=0;
    n_var=0;
    for ii=1:length(ste_A_freq)
        dt2_cur= ((t_STE_A_start(ii)-t_STE_B_start(ii)) - ...
            (func_t_pso_split(ste_A_freq(ii),theta0,v_sw, alpha_A, r_ste_A_AU) - ...
            func_t_pso_split(ste_B_freq(ii),theta0,v_sw, alpha_B , r_ste_B_AU)))^2;
        dt2=dt2+dt2_cur;
        n_var=n_var+1;
    end
    
    for ii=1:length(WIND_freq)
        dt2_cur= ((t_STE_B_start(ii)-t_WIND_start(ii)) - ...
            (func_t_pso_split(ste_B_freq(ii),theta0,v_sw, alpha_B, r_ste_B_AU) - ...
            func_t_pso_split(WIND_freq(ii),theta0,v_sw, 0 , r_WIND_AU)))^2;
        dt2=dt2+dt2_cur;
        n_var=n_var+1;
    end
    
    t=sqrt(dt2/n_var);
   
end

