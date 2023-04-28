% Final step of the program : plot the result considering the harmonic
% author : P.J.Zhang
% date :  2018-5-16 17:50:03

function draw_result_parker_signal_harmo(x,vw,r_ste_A_AU,r_WIND_AU,...
    r_ste_B_AU,angel_A,angel_B,f_res_steA,t_res_steA,f_res_WIND,t_res_WIND,...
    f_res_steB,t_res_steB,T_ste,T_wind,F_ste,F_wind,S_ste_A,S_ste_B,S_wind,...
    time_range,clim_ste,clim_wind,harmo_f,fname)
    
    parameter_define_astro;
    t1=time_range(1);
    t2=time_range(2);
    
    t0 = x(1);
    theta0 = x(2);
    vs = x(3);
    
    %use minute to label the time
    xlim_t1=0;
    xlim_t2=(t2-t1)*24*60;
    
    fbase = logspace(log10(20),log10(15000),400);
    figure()
    
    set(gcf,'position',[ 2560    580    800    400])
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
    
    if harmo_f(1)
        plot((t_res_A)/60,fbase*2,'r:','linewidth',2)
        %plot((t_res_A)/60,fbase,'r','linewidth',2)
        plot(t_res_steA/60,f_res_steA*2,'ks','linewidth',1.5);
        for ii=1:length(f_res_steA)
             plot([xlim_t1, xlim_t2],2*[f_res_steA(ii),f_res_steA(ii)],'k');
        end
    else
        plot((t_res_A)/60,fbase,'r','linewidth',2)
        plot(t_res_steA/60,f_res_steA,'ks','linewidth',1.5);
        for ii=1:length(f_res_steA)
             plot([xlim_t1, xlim_t2],[f_res_steA(ii),f_res_steA(ii)],'k');
        end
    end
    

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
    
    if harmo_f(2)
        plot((t_res_W)/60,fbase*2,'g:','linewidth',2)
        %plot((t_res_W)/60,fbase,'g','linewidth',2)
        plot(t_res_WIND/60,f_res_WIND*2,'ks','linewidth',1.5);
        for ii=1:length(f_res_WIND)
            plot([xlim_t1, xlim_t2],2*[f_res_WIND(ii),f_res_WIND(ii)],'k');
        end
    else
        plot((t_res_W)/60,fbase,'g','linewidth',2)
        plot(t_res_WIND/60,f_res_WIND,'ks','linewidth',1.5);
        for ii=1:length(f_res_WIND)
            plot([xlim_t1, xlim_t2],[f_res_WIND(ii),f_res_WIND(ii)],'k');
        end
    end
    
    
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
    
    if harmo_f(3)
        plot((t_res_B)/60,fbase*2,'b:','linewidth',2)
        %plot((t_res_B)/60,fbase,'b','linewidth',2)
        plot(t_res_steB/60,f_res_steB*2,'ks','linewidth',1.5);
        for ii=1:length(f_res_steB)
            plot([xlim_t1, xlim_t2],2*[f_res_steB(ii),f_res_steB(ii)],'k');
        end
    else
        plot((t_res_B)/60,fbase,'b','linewidth',2)
        plot(t_res_steB/60,f_res_steB,'ks','linewidth',1.5);
        for ii=1:length(f_res_steB)
            plot([xlim_t1, xlim_t2],[f_res_steB(ii),f_res_steB(ii)],'k');
        end
    end
    
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
    plot(AU2km/r_sun2km*cos(theta_all),AU2km/r_sun2km*sin(theta_all),'k:');

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
    
    f_spiral = logspace(log10(30),log10(1000),200);
    colors_f=parula(length(f_spiral));
    for ii = 1:length(f_spiral)
        r_f(ii) = get_r_from_f(f_spiral(ii));
        theta_f(ii) = theta0+1/b*(r_f(ii)-r_sun2km);
        hold on
        plot(r_f(ii)/r_sun2km * cos(theta_f(ii)),r_f(ii)/r_sun2km * sin(theta_f(ii)),...
            'o','markerfacecolor',colors_f(ii,:),'color',colors_f(ii,:),'markersize',4);
    end
    ticks_f=log10([30 50 100 200 400 1000]);
    cbr=colorbar('ticks',(ticks_f-min(ticks_f))/(max(ticks_f)-min(ticks_f)), ...
        'TickLabels',[30 50 100 200 400 1000]);
    cbr.Label.String='Frequency (kHz)';
    cbr.Location='southoutside';
    set(gcf,'position',[2560     0        455         500])
    
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
    plot((t_res_A)/60,fbase,'r','linewidth',2)
    
    for jj=1:length(fbase)
        t_res_W(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,0,r_ste_A_AU );
    end
    plot((t_res_W)/60,fbase,'g','linewidth',2)
    
    for jj=1:length(fbase)
        t_res_B(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_B,r_ste_A_AU );
    end
    plot((t_res_B)/60,fbase,'b','linewidth',2)
    
    
        plot(t_res_steA/60,f_res_steA,'rx','linewidth',1.5);
        plot(t_res_WIND/60,f_res_WIND,'gx','linewidth',1.5);
        plot(t_res_steB/60,f_res_steB,'bx','linewidth',1.5);
    
    legend('STEREO A','WIND','STEREO B')
    set(gca,'yscale','log')
    xlim([0 xlim_t2])
    ylim([20,1.4e4])
    box on
    grid on
    set(gcf,'position',[720   425   240   480])
    warning('off')
    if exist('fname','var') 
        mkdir(['img/',fname])
        print(['img/',fname,'/parkerspiral.jpg'],'-djpeg','-r700')
        saveas(gcf,['img/',fname,'/parkerspiral.eps'],'epsc')
    end
    
    figure()
    
    
    hold on
    for jj=1:length(fbase)
        t_res_W(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,0,r_WIND_AU );
        t_res_A(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_A,r_ste_A_AU );
        t_res_B(jj)=func_t_pso(fbase(jj),t0,theta0,vs,vw,angel_B,r_ste_B_AU );
        t_line(jj) = max([t_res_A(jj),t_res_B(jj),t_res_W(jj)]) - min([t_res_A(jj),t_res_B(jj),t_res_W(jj)]);
    end
    fill([fbase,fliplr(fbase)],[t_line,fliplr(-t_line)]/60,[0.7,0.7,0.7]);
    
    for jj=1:length(f_res_WIND)
        t_m_W(jj)=func_t_pso(f_res_WIND(jj),t0,theta0,vs,vw,0,r_WIND_AU );
    end
    
    for jj=1:length(f_res_steA)
        t_m_A(jj)=func_t_pso(f_res_steA(jj),t0,theta0,vs,vw,angel_A,r_ste_A_AU );
    end
    
    for jj=1:length(f_res_steB)
        t_m_B(jj)=func_t_pso(f_res_steB(jj),t0,theta0,vs,vw,angel_B,r_ste_B_AU );
    end
    
    
        stem([f_res_steA,f_res_steA],[(t_res_steA-t_m_A),(t_res_steA-t_m_A)]/60,'r.','linewidth',1.5);
        stem([f_res_WIND,f_res_WIND],[(t_res_WIND-t_m_W),(t_res_WIND-t_m_W)]/60,'g.','linewidth',1.5);
        stem([f_res_steB,f_res_steB],[(t_res_steB-t_m_B),(t_res_steB-t_m_B)]/60,'b.','linewidth',1.5);
    
    legend('\Delta t_{model}','STEREO A','WIND','STEREO B')
    set(gca,'xscale','log')
    ylim([-1 1]*10)
    xlim([min(fbase),max(fbase)])
    box on
    grid on
    set(gca,'layer','top')
    set(gcf,'position',[ 3000     0    365    480])
    warning('off')
    if exist('fname','var') 
        mkdir(['img/',fname])
        print(['img/',fname,'/obs_model.jpg'],'-djpeg','-r700')
        saveas(gcf,['img/',fname,'/obs_model.eps'],'epsc')
    end
    
    
    
end