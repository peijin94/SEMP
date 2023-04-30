% this function draw the signals with estimated arrival time
% author : P.J.Zhang
% date : 2018-4-28 22:31:06

function draw_ste_ab_wind_esti(T_ste,F_ste,S_ste_A,S_ste_B,T_wind,F_wind,S_wind,climu,climu_wind,...
    t1,t2,ste_A_freq,WIND_freq,ste_B_freq,t_STE_A_start,t_STE_B_start,t_WIND_start,...
    angle_A,angle_B,t0,theta0,vs,vw,fname)
        
    r_sun = 695700; %km

    AU = 149597870; %km
    omega = 2.9e-6; %rad/s
    b=vw/omega;
    r0=r_sun;


    fbase = logspace(log10(20),...
    log10(1.6e4),...
    40);

    figure()
    
    set(gcf,'position',[  161.0000  131.4000  1590  780])
    subplot(131)
    h=pcolor(T_ste,F_ste,S_ste_A);
    h.EdgeColor='none';
    set(gca,'clim',[0,climu])
    set(gca, 'YScale', 'log')
    xlim([t1,t2])
    ylim([10 1.6e4])
    title('STEREO A')
    set(gca,'XTickLabelRotation',-45)
    datetick('x','HH:MM:SS','keeplimits')
    colormap(jet)
    hold on
    
    for jj=1:length(fbase)
        t_res_A(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angle_A);
    end
    plot(t_res_A,fbase,'color','b','linewidth',2)
    
    for ii=1:length(ste_A_freq)
        plot([t1,t2],[ste_A_freq(ii),ste_A_freq(ii)],'k');
    end
    h2=plot(t_STE_A_start,ste_A_freq,'ks');
    
    
    %legend([h1,h2],'Max(Diff)','Start Point')
    shading interp

    subplot(132)
    h=pcolor(T_wind,F_wind,S_wind);
    h.EdgeColor='none';
    set(gca,'clim',[0,climu_wind])
    set(gca, 'YScale', 'log')
    xlim([t1,t2])
    title('WIND')
    set(gca,'XTickLabelRotation',-45)
    ylim([10 1.6e4])
    datetick('x','HH:MM:SS','keeplimits')
    colormap(jet)
    hold on
    
    for jj=1:length(fbase)
        t_res_W(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,0);
    end
    plot(t_res_W,fbase,'color','b','linewidth',2)
    
    for ii=1:length(WIND_freq)
        plot([t1,t2],[WIND_freq(ii),WIND_freq(ii)],'k');
    end
    h2=plot(t_WIND_start,WIND_freq,'ks');
    %legend([h1,h2],'Max(Diff)','Start Point')
    shading interp


    subplot(133)
    h=pcolor(T_ste,F_ste,S_ste_B);
    h.EdgeColor='none';
    set(gca,'clim',[0,climu])
    set(gca, 'YScale', 'log')
    xlim([t1,t2])
    title('STEREO B')
    set(gca,'XTickLabelRotation',-45)
    ylim([10 1.6e4])
    datetick('x','HH:MM:SS','keeplimits')
    colormap(jet)
    hold on
    
    for jj=1:length(fbase)
        t_res_B(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angle_B);
    end
    plot(t_res_B,fbase,'color','b','linewidth',2)
    
    for ii=1:length(ste_B_freq)
        plot([t1,t2],[ste_B_freq(ii),ste_B_freq(ii)],'k');
    end
    h2=plot(t_STE_B_start,ste_B_freq,'ks');
    shading interp
    %legend([h1,h2],'Max(Diff)','Start Point')
    colormap(color_vacu)

    set(gcf,'position',[  161.0000  131.4000 720  480])
    if exist('fname','var')    
        print(fname,'-djpeg','-r400')
    end
    
    figure()
    b_cur = b;
    theta=theta0-(0:0.01:3);
        
    r=r0-b_cur.*(theta-theta0);
    x_e=r.*cos(theta)./r_sun;
    y_e=r.*sin(theta)./r_sun;
    ax=gca;  
    plot(x_e,y_e,'k','linewidth',2);
       

    ax.YAxisLocation = 'origin';    
    ax.XAxisLocation = 'origin';
    axis equal
    box on
    
    xlim([-250 250])
    ylim([-250 250])
    hold on
    theta_earth = 0:0.001:(2*pi);
    plot(AU/r_sun*cos(theta_earth),AU/r_sun*sin(theta_earth),'k:','color',[0.6 0.6 0.6]);
    
    plot(AU/r_sun*cos(angle_A),AU/r_sun*sin(angle_A),'kx','linewidth',2)
    plot(AU/r_sun*cos(angle_B),AU/r_sun*sin(angle_B),'kx','linewidth',2)
    plot(AU/r_sun*cos(0),-AU/r_sun*sin(0),'kx','linewidth',2)
    text(AU/r_sun*cos(angle_A)+5,AU/r_sun*sin(angle_A),'STEREO A')
    text(AU/r_sun*cos(angle_B)+5,AU/r_sun*sin(angle_B),'STEREO B')
    text(AU/r_sun+0.5,6.5,'WIND')
    
    set(gcf,'position',[483   703   400   419])
    
    figure()
    hold on
    plot(t_res_A,fbase,'color','r','linewidth',2)
    plot(t_res_W,fbase,'color','g','linewidth',2)
    plot(t_res_B,fbase,'color','b','linewidth',2)
    legend('A','W','B')
    set(gca,'yscale','log')
    xlim([t1,t2])
    ylim([min(fbase),max(fbase)])
    set(gcf,'position',[ 161   703   314   420])
    datetick('x','HH:MM:SS','keeplimits')
end