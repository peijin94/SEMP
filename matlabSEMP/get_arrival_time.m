% get the arrival time of the signal targeting the rise time of the signal
% author : P.J.Zhang
% date :  2018-4-29 11:24:20

function [f_res,t_res] = get_arrival_time(T,F,S,f_upper,f_lower,f_step,t_step,thresh)
    f_res = logspace(log10(f_upper),...
    log10(f_lower),f_step * log10(f_upper/f_lower));
    
    t_seq = linspace(min(T(:)),max(T(:)),t_step);
    
    t_vec = T(1,:);
    f_vec = F(:,1);
    
    t_res=zeros(size(f_res));
    for ii=1:length(f_res)
        sample_signal = interp2(t_vec,f_vec,S,...
            t_seq,f_res(ii)*ones(size(t_seq)),'spline');
        %t_STE_A_inc(ii)=t_seq(1+find(max(diff(sample_signal))==diff(sample_signal)));
        max_diff = max(diff(sample_signal));
        anorm_diff = diff(sample_signal)/max_diff;
        idx_start = find(anorm_diff>thresh);
        t_res(ii)=t_seq(1+idx_start(1));
    end
    
    t_res = t_res*60;
    
    % the velocity are all in the form of km/s
    % so here the time should be in the form of km/s
end