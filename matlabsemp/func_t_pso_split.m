% core function, calculate the Dt of the satellites
% author : P.J.Zhang
% date :  2018-5-9 16:07:55

function t_res = func_t_pso_split(f,theta0,v_sw,alpha,r_satellite_AU)

    parameter_define_astro;
    r_sun = 695700; %km
    %v_sw = 400;%km

    v_light=3e5;% km/s
    omega = 2.662e-6; %rad/s
    b=v_sw/omega;
    r0=r_sun;
    r_satellite = r_satellite_AU * AU2km;
    
    r = get_r_from_f(f);
    
    theta = theta0 - 1/b*(r-r0);
    D_so = sqrt((r*cos(theta)-r_satellite * cos(alpha ))^2 ...
        +(r*sin(theta)-r_satellite*sin(alpha ))^2);
    
    t_res = (D_so/v_light);
end