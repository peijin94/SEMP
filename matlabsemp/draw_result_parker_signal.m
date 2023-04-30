% Final step of the program : plot the result
% author : P.J.Zhang
% date :  2018-04-30 18:46:58

function draw_result_parker_signal(x,vw,r_ste_A_AU,r_WIND_AU,r_ste_B_AU,angel_A,angel_B,...
    f_res_steA,t_res_steA,f_res_WIND,t_res_WIND,f_res_steB,t_res_steB,...
    T_ste,T_wind,F_ste,F_wind,S_ste_A,S_ste_B,S_wind,time_range,clim_ste,clim_wind,fname)
    
    parameter_define_astro;
    t1=time_range(1);
    t2=time_range(2);
    
    t0 = x(1);
    theta0 = x(2);
    vs = x(3);
    
    %use minute to label the time
    xlim_t1=0;
    xlim_t2=(t2-t1)*24*60;
    
    fbase = logspace(log10(50),log10(15000),400);
    figure()
    
    set(gcf,'position',[  161.0000  131.4000  1990  780])
    subplot(131)
    h=pcolor(T_ste,F_ste,S_ste_A);
    h.EdgeColor='none';
    set(gca,'clim',[0,clim_ste])
    set(gca, 'YScale', 'log')
    xlim([xlim_t1,xlim_t2])
    ylim([20 1.4e4])
    title('STEREO A')
    set(gca,'Layer','top')
    %set(gca,'XTickLabelRotation',-45)
    %datetick('x','HH:MM:SS','keeplimits')
    colormap(jet)
    hold on
    for jj=1:length(fbase)
        t_res_A(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_A,r_ste_A_AU );
    end
    plot((t_res_A)/60,fbase,'color','r','linewidth',2)
    for ii=1:length(f_res_steA)
        plot([xlim_t1, xlim_t2],[f_res_steA(ii),f_res_steA(ii)],'k');
    end
    h2=plot(t_res_steA/60,f_res_steA,'ks');
    shading interp
    ylabel('Frequency (kHz)')
    
    
    subplot(132)
    h=pcolor(T_wind,F_wind,S_wind);
    h.EdgeColor='none';
    set(gca,'clim',[0,clim_wind])
    set(gca, 'YScale', 'log')
    xlim([xlim_t1,xlim_t2])
    title('WIND')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    %set(gca,'XTickLabelRotation',-45)
    %datetick('x','HH:MM:SS','keeplimits')
    colormap(jet)    
    hold on
    for jj=1:length(fbase)
        t_res_W(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,0,r_WIND_AU );
    end
    plot((t_res_W)/60,fbase,'color','g','linewidth',2)
    for ii=1:length(f_res_WIND)
        plot([xlim_t1, xlim_t2],[f_res_WIND(ii),f_res_WIND(ii)],'k');
    end
    h2=plot(t_res_WIND/60,f_res_WIND,'ks');
    shading interp
    xlabel(['Time (minute) started from ', datestr(t1)])
    

    subplot(133)
    h=pcolor(T_ste,F_ste,S_ste_B);
    h.EdgeColor='none';
    set(gca,'clim',[0,clim_ste])
    set(gca, 'YScale', 'log')
    xlim([xlim_t1,xlim_t2])
    title('STEREO B')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    %set(gca,'XTickLabelRotation',-45)
    %datetick('x','HH:MM:SS','keeplimits')
    colormap(jet)
    hold on
    for jj=1:length(fbase)
        t_res_B(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_B,r_ste_B_AU );
    end
    plot((t_res_B)/60,fbase,'color','b','linewidth',2)
    for ii=1:length(f_res_steB)
        plot([xlim_t1, xlim_t2],[f_res_steB(ii),f_res_steB(ii)],'k');
    end
    h2=plot(t_res_steB/60,f_res_steB,'ks');
    colormap(color_vacu)
    shading interp
    
    set(gcf,'position',[0   425   720   480])
    if exist('fname','var') 
        mkdir(['img/',fname])
        % the eps can be to large
        print(['img/',fname,'/spectra.jpg'],'-djpeg','-r700')
        %saveas(gcf,['img/',fname,'/spectra.eps'],'epsc')
    end
    
    figure()
    hold on
    h_sate(1)=plot(r_ste_A_AU*AU2km/r_sun2km * cos(angel_A),r_ste_A_AU*AU2km/r_sun2km * sin(angel_A),'ro','markersize',5,'markerfacecolor','r');
    h_sate(2)=plot(r_WIND_AU*AU2km/r_sun2km * cos(0),r_WIND_AU*AU2km/r_sun2km * sin(0),'go','markersize',5,'markerfacecolor','g');
    h_sate(3)=plot(r_ste_B_AU*AU2km/r_sun2km * cos(angel_B),r_ste_B_AU*AU2km/r_sun2km * sin(angel_B),'bo','markersize',5,'markerfacecolor','b');
    theta_all=0:0.002:2*pi;
    plot(AU2km/r_sun2km*cos(theta_all),AU2km/r_sun2km*sin(theta_all),'k--');

    ax=gca;  
    axis equal
    ax.YAxisLocation = 'origin'; 
    ax.XAxisLocation = 'origin'; 
    
    xlim([-255 255])
    ylim([-255 300])
    xticks(-200:50:200)
    yticks(-200:50:200)
    
    omega = -2.662e-6; %rad/s
    b=vw/omega;
    r_spiral = linspace(1e4,AU2km*1.5,200);
    theta_spiral = theta0+1/b*(r_spiral-r_sun2km);
    
    plot(r_spiral/r_sun2km .* cos(theta_spiral),r_spiral/r_sun2km .* sin(theta_spiral),'k-')
    
    f_spiral = logspace(log10(25),log10(1000),200);
    colors_f=parula(length(f_spiral));
    for ii = 1:length(f_spiral)
        r_f(ii) = get_r_from_f(f_spiral(ii));
        theta_f(ii) = theta0+1/b*(r_f(ii)-r_sun2km); 
        hold on
        plot(r_f(ii)/r_sun2km * cos(theta_f(ii)),r_f(ii)/r_sun2km * sin(theta_f(ii)),...
            'o','markerfacecolor',colors_f(ii,:),'color',colors_f(ii,:),'markersize',4);
    end
    ticks_f=log10([50 100 200 400 1000]);
    cbr=colorbar('ticks',(ticks_f-min(ticks_f))/(max(ticks_f)-min(ticks_f)), ...
        'TickLabels',[50 100 200 400 1000]);
    cbr.Label.String='Frequency (kHz)';
    cbr.Location='southoutside';
    set(gcf,'position',[960     425         440         480])
    box on
    legend(h_sate,'STEREO A','WIND','STEREO B','Location','north','Orientation','horizontal')
    if exist('fname','var') 
        mkdir(['img/',fname])
        print(['img/',fname,'/driftline.jpg'],'-djpeg','-r700')
        saveas(gcf,['img/',fname,'/driftline.eps'],'epsc')
    end
    figure()
    
    hold on
    for jj=1:length(fbase)
        t_res_A(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_A,r_ste_A_AU );
    end
    plot((t_res_A)/60,fbase,'color','r','linewidth',2)
    
    for jj=1:length(fbase)
        t_res_A(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,0,r_ste_A_AU );
    end
    plot((t_res_A)/60,fbase,'color','g','linewidth',2)
    
    for jj=1:length(fbase)
        t_res_A(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_B,r_ste_A_AU );
    end
    plot((t_res_A)/60,fbase,'color','b','linewidth',2)
    
    legend('STEREO A','WIND','STEREO B')
    set(gca,'yscale','log')
    xlim([0 xlim_t2])
    ylim([20,1.4e4])
    box on
    grid on
    set(gcf,'position',[720   425   240   480])
    
    if exist('fname','var') 
        mkdir(['img/',fname])
        print(['img/',fname,'/parkerspiral.jpg'],'-djpeg','-r700')
        saveas(gcf,['img/',fname,'/parkerspiral.eps'],'epsc')
    end
end