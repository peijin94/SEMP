% Use the frequency to calculate the distance from the sun (leblank)
% author : P.J.Zhang
% date :  2018-05-01 14:34:29

function r_res=get_r_from_f(f,par_ne)
        
    if ~exist('par_ne','var')
        par_ne = 2;
    end
    parameter_define_astro;
    ne=(f/8.98)^2;
    % use leblanc model to derive the height
    func_freq=@(r,f)((f/8.98)^2-par_ne*(2.8e5*r^(-2)+3.5e6*r^(-4)+6.8e7*r^(-6)));
    r_res = abs(fzero(@(x)(func_freq(x,f)),sqrt(3e5/ne))*r_sun2km);
    
end