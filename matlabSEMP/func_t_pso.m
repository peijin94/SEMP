% core function, calculates the complete duration from generation to end
% author : P.J.Zhang
% date :  2018-4-24 15:14:20

function t_res=func_t_pso(f,t0,theta0,vs,v_sw,alpha,r_satellite_AU,ne_par)

    parameter_define_astro;
    r_sun = 695700; %km
    %v_sw = 400;%km

    v_light=3e5;% km/s
    omega = 2.662e-6; %rad/s
    b=v_sw/omega;
    r0=r_sun;
    r_satellite = r_satellite_AU * AU2km;
    
    r = get_r_from_f(f,ne_par);
    
    S_r = r/2*sqrt(1+(r/b)^2)+b/2*log(r/b+sqrt(1+(r/b)^2));
    
    theta = theta0 - 1/b*(r-r0);
    D_so = sqrt((r*cos(theta)-r_satellite * cos(alpha ))^2 ...
        +(r*sin(theta)-r_satellite*sin(alpha ))^2);
    
    t_res = t0 + (S_r/vs + D_so/v_light);
end