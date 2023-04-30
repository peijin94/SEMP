% the target function, calculates the total time deviation
% author : P.J.Zhang
% date :  2018-4-29 20:32:48

function t=func_dt2_pso(ste_A_freq,ste_B_freq,WIND_freq,...
    t_STE_A_start,t_STE_B_start,t_WIND_start,...
    t0,theta0,vs,v_sw,alpha_A,alpha_B,r_ste_A_AU,r_WIND_AU,r_ste_B_AU,...
    ne_par)

    if ~exist('ne_par','var')
        ne_par = 2;
    end
    dt2=0;
    n=0;
    for ii=1:length(ste_A_freq)
        dt2_cur= (t_STE_A_start(ii) - func_t_pso(ste_A_freq(ii),t0,theta0,vs,v_sw, alpha_A, r_ste_A_AU,ne_par))^2;
        dt2=dt2+dt2_cur;
        n=n+1;
    end
    
    for ii=1:length(WIND_freq)
        dt2_cur= (t_WIND_start(ii) - func_t_pso(WIND_freq(ii),t0,theta0,vs,v_sw, 0 , r_WIND_AU,ne_par))^2;
        dt2=dt2+dt2_cur;
        n=n+1;
    end
    
    for ii=1:length(ste_B_freq)
        dt2_cur= (t_STE_B_start(ii) - func_t_pso(ste_B_freq(ii),t0,theta0,vs,v_sw, alpha_B, r_ste_B_AU,ne_par))^2;
        dt2=dt2+dt2_cur;
        n=n+1;
    end
    
    t=sqrt(dt2/n);
end

