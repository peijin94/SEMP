function varargout = arrivalTime(varargin)
% ARRIVALTIME MATLAB code for arrivalTime.fig
%      ARRIVALTIME, by itself, creates a new ARRIVALTIME or raises the existing
%      singleton*.
%
%      H = ARRIVALTIME returns the handle to a new ARRIVALTIME or the handle to
%      the existing singleton*.
%
%      ARRIVALTIME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARRIVALTIME.M with the given input arguments.
%
%      ARRIVALTIME('Property','Value',...) creates a new ARRIVALTIME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before arrivalTime_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to arrivalTime_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help arrivalTime

% Last Modified by GUIDE v2.5 16-May-2018 17:27:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @arrivalTime_OpeningFcn, ...
                   'gui_OutputFcn',  @arrivalTime_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before arrivalTime is made visible.
function arrivalTime_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to arrivalTime (see VARARGIN)

% Choose default command line output for arrivalTime
handles.output = hObject;

if ~isempty(hObject.UserData)
    if hObject.UserData.level>=5
        
        semp_data=hObject.UserData;
        handles.UserData=semp_data;
        handles.clim_upper=25;

        axes(handles.axes1)
        h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_A_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,handles.clim_upper])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        colormap(color_vacu)
        shading interp

        axes(handles.axes2)
        h=pcolor(handles.UserData.T_wind_small,handles.UserData.F_wind_small,handles.UserData.S_wind_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,handles.clim_upper])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        colormap(color_vacu)
        shading interp

        axes(handles.axes3)
        h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_B_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,handles.clim_upper])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        colormap(color_vacu)
        shading interp
            

        handles.t1_m=0;
        handles.t2_m=max(handles.UserData.T_ste_small(:));
        [x,y] = gen_fline(handles.UserData.upper1,handles.UserData.lower1,handles.UserData.steps1,handles.t1_m,handles.t2_m);
        axes(handles.axes1)
        hold on;
        handles.freq_line1=plot(x,y,'k');

        [x,y] = gen_fline(handles.UserData.upper2,handles.UserData.lower2,handles.UserData.steps2,handles.t1_m,handles.t2_m);
        axes(handles.axes2)    
        hold on;
        handles.freq_line2=plot(x,y,'k');

        [x,y] = gen_fline(handles.UserData.upper3,handles.UserData.lower3,...
            handles.UserData.steps3,handles.t1_m,handles.t2_m);
        axes(handles.axes3)
        hold on;
        handles.freq_line3=plot(x,y,'k');

        handles.t_res = handles.UserData.t_res;        
        handles.idx_steA = 1:length(handles.UserData.f_res_steA);
        handles.idx_WIND = (1:length(handles.UserData.f_res_WIND))+handles.idx_steA(end);
        handles.idx_steB = (1:length(handles.UserData.f_res_steB))+handles.idx_WIND(end);

        axes(handles.axes1)
        hold on
        handles.mark_all_steA=plot(handles.t_res(handles.idx_steA),handles.UserData.f_res_steA,'ks');
            xlim([handles.t1_m,handles.t2_m])

        axes(handles.axes2)
        hold on
        handles.mark_all_WIND=plot(handles.t_res(handles.idx_WIND),handles.UserData.f_res_WIND,'ks');
            xlim([handles.t1_m,handles.t2_m])

        axes(handles.axes3)
        hold on
        handles.mark_all_steB=plot(handles.t_res(handles.idx_steB),handles.UserData.f_res_steB,'ks');
            xlim([handles.t1_m,handles.t2_m])
        
        handles.length_idx   = length(handles.t_res);
        handles.cursor_idx   = 1;
        handles.cursor_freq  = judge_the_freq(handles.cursor_idx,handles);

        freq_cur=handles.cursor_freq;
        handles.cursor_line  = plot(judge_123_axe(handles.cursor_idx,handles),...
            [handles.t1_m,handles.t2_m], ...
            [freq_cur,freq_cur],'g','linewidth',2 );

        [t_res,s_res] = get_signal_line(handles.UserData.T_ste_small,handles.UserData.F_ste_small,...
            handles.UserData.S_ste_A_small, freq_cur ,180);

        axes(handles.axes4)
        hold off
        plot(t_res,s_res,'k','linewidth',2)
        xlim([handles.t1_m,handles.t2_m])

        if handles.t_res(1)<-0.1
            t_cur = (handles.t1_m+handles.t2_m)/2 ;
        else
            t_cur = handles.t_res(1);
        end

        handles.cursor_mark_line = plot(judge_123_axe(handles.cursor_idx,handles),...
            t_cur, freq_cur,'gs','linewidth',2 );

        axes(handles.axes4)
        hold on
        handles.cursor_mark_ax4  = plot(handles.axes4 ,...
            [t_cur,t_cur], [min(s_res),max(s_res)],'k');
        axis tight

        axes(handles.axes5)
        h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_A_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,handles.clim_upper])
        set(gca, 'YScale', 'log')
        ylim([freq_cur/1.06,freq_cur*1.06])
        xlim([t_cur-6 , t_cur+6])
        set(gca,'Layer','top')
        colormap(color_vacu)
        hold on
        plot([t_cur,t_cur],[freq_cur/1.06,freq_cur*1.06],'k','linewidth',2)
        plot([t_cur-6,t_cur+6],[freq_cur,freq_cur],'k','linewidth',2)
        plot(t_cur,freq_cur,'ko','markersize',30,'linewidth',2)

        axis off 
        box off
        shading interp
        
        
    else
    
    semp_data=hObject.UserData;
    
    handles.UserData=semp_data;
    handles.clim_upper=25;
    
    
    axes(handles.axes1)
    h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_A_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    colormap(color_vacu)
    shading interp
    
    axes(handles.axes2)
    h=pcolor(handles.UserData.T_wind_small,handles.UserData.F_wind_small,handles.UserData.S_wind_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    colormap(color_vacu)
    shading interp
    
    axes(handles.axes3)
    h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_B_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    colormap(color_vacu)
    shading interp
   
    hold on
    
    handles.mark_all_steA=plot(nan,nan);
    handles.mark_all_WIND=plot(nan,nan);
    handles.mark_all_steB=plot(nan,nan);
    
    handles.t1_m=0;
    handles.t2_m=max(handles.UserData.T_ste_small(:));
    [x,y] = gen_fline(handles.UserData.upper1,handles.UserData.lower1,handles.UserData.steps1,handles.t1_m,handles.t2_m);
    axes(handles.axes1)
    hold on;
    handles.freq_line1=plot(x,y,'k');
    
    [x,y] = gen_fline(handles.UserData.upper2,handles.UserData.lower2,handles.UserData.steps2,handles.t1_m,handles.t2_m);
    axes(handles.axes2)    
    hold on;
    handles.freq_line2=plot(x,y,'k');
    
    [x,y] = gen_fline(handles.UserData.upper3,handles.UserData.lower3,...
        handles.UserData.steps3,handles.t1_m,handles.t2_m);
    axes(handles.axes3)
    hold on;
    handles.freq_line3=plot(x,y,'k');
    
    

    handles.t_res = -ones(1,length(handles.UserData.f_res_steA)+...
        length(handles.UserData.f_res_WIND)+length(handles.UserData.f_res_steB));
    
    handles.idx_steA = 1:length(handles.UserData.f_res_steA);
    handles.idx_WIND = (1:length(handles.UserData.f_res_WIND))+handles.idx_steA(end);
    handles.idx_steB = (1:length(handles.UserData.f_res_steB))+handles.idx_WIND(end);
    
    handles.length_idx   = length(handles.t_res);
    handles.cursor_idx   = 1;
    handles.cursor_freq  = judge_the_freq(handles.cursor_idx,handles);
    
    freq_cur=handles.cursor_freq;
    handles.cursor_line  = plot(judge_123_axe(handles.cursor_idx,handles),...
        [handles.t1_m,handles.t2_m], ...
        [freq_cur,freq_cur],'g','linewidth',2 );
    
    [t_res,s_res] = get_signal_line(handles.UserData.T_ste_small,handles.UserData.F_ste_small,...
        handles.UserData.S_ste_A_small, freq_cur ,180);
    
    axes(handles.axes4)
    hold off
    plot(t_res,s_res,'k','linewidth',2)
    xlim([handles.t1_m,handles.t2_m])
    
    if handles.t_res(1)<-0.1
        t_cur = (handles.t1_m+handles.t2_m)/2 ;
    else
        t_cur = handles.t_res(1);
    end
    
    handles.cursor_mark_line = plot(judge_123_axe(handles.cursor_idx,handles),...
        t_cur, freq_cur,'gs','linewidth',2 );

    axes(handles.axes4)
    hold on
    handles.cursor_mark_ax4  = plot(handles.axes4 ,...
        [t_cur,t_cur], [min(s_res),max(s_res)],'k');
    axis tight
    
    axes(handles.axes5)
    h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_A_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([freq_cur/1.06,freq_cur*1.06])
    xlim([t_cur-6 , t_cur+6])
    set(gca,'Layer','top')
    colormap(color_vacu)
    hold on
    plot([t_cur,t_cur],[freq_cur/1.06,freq_cur*1.06],'k','linewidth',2)
    plot([t_cur-6,t_cur+6],[freq_cur,freq_cur],'k','linewidth',2)
    plot(t_cur,freq_cur,'ko','markersize',30,'linewidth',2)
    
    axis off 
    box off
    shading interp
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes arrivalTime wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = arrivalTime_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in confirm_t.
function confirm_t_Callback(hObject, eventdata, handles)
% hObject    handle to confirm_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.t_res(handles.cursor_idx)=handles.t1_m +...
    get(handles.slider1,'value')*(handles.t2_m-handles.t1_m);

delete(handles.mark_all_steA);
delete(handles.mark_all_steB);
delete(handles.mark_all_WIND);

axes(handles.axes1)
handles.mark_all_steA=plot(handles.t_res(handles.idx_steA),handles.UserData.f_res_steA,'ks');
    xlim([handles.t1_m,handles.t2_m])

axes(handles.axes2)
handles.mark_all_WIND=plot(handles.t_res(handles.idx_WIND),handles.UserData.f_res_WIND,'ks');
    xlim([handles.t1_m,handles.t2_m])
    
axes(handles.axes3)
handles.mark_all_steB=plot(handles.t_res(handles.idx_steB),handles.UserData.f_res_steB,'ks');
    xlim([handles.t1_m,handles.t2_m])

guidata(hObject,handles)

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
% hObject    handle to left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function [x,y]=gen_fline(upper,lower,steps,t1,t2)
freqs = logspace(log10(lower), log10(upper), steps);
x = ((mod(1:steps,2)'*[t1,t2])+((1-mod(1:steps,2))'*[t2,t1]))';
y = (freqs'*[1,1])';
x=x(:);
y=y(:);

    


% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in prev_channel.
function prev_channel_Callback(hObject, eventdata, handles)
% hObject    handle to prev_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.cursor_idx ~=1
    
    handles.cursor_idx   =  handles.cursor_idx - 1;
    handles.cursor_freq  = judge_the_freq(handles.cursor_idx,handles);
    
    freq_cur=handles.cursor_freq;
    
    delete(handles.cursor_line);
    delete(handles.cursor_mark_line);
    
    handles.cursor_line  = plot(judge_123_axe(handles.cursor_idx,handles),...
        [handles.t1_m,handles.t2_m], ...
        [freq_cur,freq_cur],'g','linewidth',2 );
    
    [t_res,s_res] = get_signal_line(judge_123_t_mat(handles.cursor_idx,handles),...
        judge_123_f_mat(handles.cursor_idx,handles),...
       judge_123_signal(handles.cursor_idx,handles), freq_cur ,180);
    
    axes(handles.axes4)
    hold off
    plot(t_res,s_res,'k','linewidth',2)
    xlim([handles.t1_m,handles.t2_m])
    
    if handles.t_res(handles.cursor_idx)<-0.1
        t_cur = (handles.t1_m+handles.t2_m)/2 ;
        set(handles.slider1,'value',0.5);
    else
        t_cur = handles.t_res(handles.cursor_idx);
        set(handles.slider1,'value',t_cur/(handles.t2_m-handles.t1_m));
    end
    
    handles.cursor_mark_line = plot(judge_123_axe(handles.cursor_idx,handles),...
        t_cur, freq_cur,'gs','linewidth',2 );

    axes(handles.axes4)
    hold on
    handles.cursor_mark_ax4  = plot(handles.axes4 ,...
        [t_cur,t_cur], [min(s_res),max(s_res)],'k');
    axis tight
    
    axes(handles.axes5)
    h=pcolor(judge_123_t_mat(handles.cursor_idx,handles),...
        judge_123_f_mat(handles.cursor_idx,handles),...
        judge_123_signal(handles.cursor_idx,handles));
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([freq_cur/1.06,freq_cur*1.06])
    xlim([t_cur-6 , t_cur+6])
    set(gca,'Layer','top')
    colormap(color_vacu)
    hold on
    plot([t_cur,t_cur],[freq_cur/1.06,freq_cur*1.06],'k','linewidth',2)
    plot([t_cur-6,t_cur+6],[freq_cur,freq_cur],'k','linewidth',2)
    plot(t_cur,freq_cur,'ko','markersize',30,'linewidth',2)
    
    axis off 
    box off
    shading interp
end

uicontrol(handles.slider1)
guidata(hObject,handles)


% --- Executes on button press in next_channel.
function next_channel_Callback(hObject, eventdata, handles)
% hObject    handle to next_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.cursor_idx ~= handles.length_idx
    
    handles.cursor_idx   =  handles.cursor_idx + 1;
    handles.cursor_freq  = judge_the_freq(handles.cursor_idx,handles);
    
    freq_cur=handles.cursor_freq;
    
    delete(handles.cursor_line);
    delete(handles.cursor_mark_line);
    
    handles.cursor_line  = plot(judge_123_axe(handles.cursor_idx,handles),...
        [handles.t1_m,handles.t2_m], ...
        [freq_cur,freq_cur],'g','linewidth',2 );
    
    [t_res,s_res] = get_signal_line(judge_123_t_mat(handles.cursor_idx,handles),...
        judge_123_f_mat(handles.cursor_idx,handles),...
        judge_123_signal(handles.cursor_idx,handles), freq_cur ,180);
    
    axes(handles.axes4)
    hold off
    plot(t_res,s_res,'k','linewidth',2)
    xlim([handles.t1_m,handles.t2_m])
    
    if handles.t_res(handles.cursor_idx)<-0.1
        t_cur = (handles.t1_m+handles.t2_m)/2 ;
        set(handles.slider1,'value',0.5)
    else
        t_cur = handles.t_res(handles.cursor_idx);
        set(handles.slider1,'value',t_cur/(handles.t2_m-handles.t1_m));
    end
    
    handles.cursor_mark_line = plot(judge_123_axe(handles.cursor_idx,handles),...
        t_cur, freq_cur,'gs','linewidth',2 );

    axes(handles.axes4)
    hold on
    handles.cursor_mark_ax4  = plot(handles.axes4 ,...
        [t_cur,t_cur], [min(s_res),max(s_res)],'k');
    axis tight
    
    axes(handles.axes5)
    h=pcolor(judge_123_t_mat(handles.cursor_idx,handles),...
        judge_123_f_mat(handles.cursor_idx,handles),...
        judge_123_signal(handles.cursor_idx,handles));
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([freq_cur/1.06,freq_cur*1.06])
    xlim([t_cur-6 , t_cur+6])
    set(gca,'Layer','top')
    colormap(color_vacu)
    hold on
    plot([t_cur,t_cur],[freq_cur/1.06,freq_cur*1.06],'k','linewidth',2)
    plot([t_cur-6,t_cur+6],[freq_cur,freq_cur],'k','linewidth',2)
    plot(t_cur,freq_cur,'ko','markersize',30,'linewidth',2)
    
    axis off 
    box off
    shading interp
end
uicontrol(handles.slider1)
guidata(hObject,handles)




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cursor_var = get(hObject,'value');


    t_cur = handles.t1_m+(handles.t2_m-handles.t1_m)*cursor_var;
    freq_cur=handles.cursor_freq;
    [~,s_res] = get_signal_line(judge_123_t_mat(handles.cursor_idx,handles),...
        judge_123_f_mat(handles.cursor_idx,handles),...
        judge_123_signal(handles.cursor_idx,handles), freq_cur ,180);
    
    delete(handles.cursor_mark_ax4)
    delete(handles.cursor_mark_line)
    
    handles.cursor_mark_line = plot(judge_123_axe(handles.cursor_idx,handles),...
        t_cur, freq_cur,'gs','linewidth',2 );
    
    axes(handles.axes4)
    hold on
    handles.cursor_mark_ax4  = plot(handles.axes4 ,...
        [t_cur,t_cur], [min(s_res),max(s_res)],'k');
    axis tight
    
    axes(handles.axes5)
    hold off
    h=pcolor(judge_123_t_mat(handles.cursor_idx,handles),...
        judge_123_f_mat(handles.cursor_idx,handles),...
        judge_123_signal(handles.cursor_idx,handles));
    h.EdgeColor='none';
    set(gca,'clim',[1,handles.clim_upper])
    set(gca, 'YScale', 'log')
    ylim([freq_cur/1.06,freq_cur*1.06])
    xlim([t_cur-6 , t_cur+6])
    set(gca,'Layer','top')
    colormap(color_vacu)
    hold on
    plot([t_cur,t_cur],[freq_cur/1.06,freq_cur*1.06],'k','linewidth',2)
    plot([t_cur-6,t_cur+6],[freq_cur,freq_cur],'k','linewidth',2)
    plot(t_cur,freq_cur,'ko','markersize',30,'linewidth',2)
    
    axis off 
    box off
    shading interp

guidata(hObject,handles)
    

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'value',0.5)



function [t_seq,s_res]= get_signal_line(T,F,S,f_samp,t_step)
t_vec = T(1,:);
f_vec = F(:,1);
t_seq = linspace(min(T(:)),max(T(:)),t_step);

s_res = interp2(t_vec,f_vec,S,...
            t_seq,f_samp*ones(size(t_seq)),'spline');
        

function the_handle = judge_123_axe(idx_cursor,handles)

if idx_cursor <= (length(handles.UserData.f_res_steA))
    the_handle = handles.axes1;
elseif idx_cursor <= (length(handles.UserData.f_res_steA)+...
        length(handles.UserData.f_res_WIND))
    the_handle = handles.axes2;
else
    the_handle = handles.axes3;
end

function sig_cur = judge_123_signal(idx_cursor,handles)
if idx_cursor <= (length(handles.UserData.f_res_steA))
    sig_cur = handles.UserData.S_ste_A_small;
elseif idx_cursor <= (length(handles.UserData.f_res_steA)+...
        length(handles.UserData.f_res_WIND))
    sig_cur = handles.UserData.S_wind_small;
else
    sig_cur = handles.UserData.S_ste_B_small;
end


function f_mat_cur = judge_123_f_mat(idx_cursor,handles)
if idx_cursor <= (length(handles.UserData.f_res_steA))
    f_mat_cur = handles.UserData.F_ste_small;
elseif idx_cursor <= (length(handles.UserData.f_res_steA)+...
        length(handles.UserData.f_res_WIND))
    f_mat_cur = handles.UserData.F_wind_small;
else
    f_mat_cur = handles.UserData.F_ste_small;
end

function t_mat_cur = judge_123_t_mat(idx_cursor,handles)
if idx_cursor <= (length(handles.UserData.f_res_steA))
    t_mat_cur = handles.UserData.T_ste_small;
elseif idx_cursor <= (length(handles.UserData.f_res_steA)+...
        length(handles.UserData.f_res_WIND))
    t_mat_cur = handles.UserData.T_wind_small;
else
    t_mat_cur = handles.UserData.T_ste_small;
end

function the_freq = judge_the_freq(idx_cursor,handles)

if idx_cursor <= (length(handles.UserData.f_res_steA))
    the_freq = handles.UserData.f_res_steA(idx_cursor);
elseif idx_cursor <= (length(handles.UserData.f_res_steA)+...
        length(handles.UserData.f_res_WIND))
    the_freq = handles.UserData.f_res_WIND(idx_cursor ...
        -length(handles.UserData.f_res_steA));
else
    the_freq = handles.UserData.f_res_steB(idx_cursor ...
        -length(handles.UserData.f_res_steA)-length(handles.UserData.f_res_WIND));
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cur_var = get(hObject,'value');
handles.clim_upper = cur_var*50;
if handles.clim_upper<=1
    handles.clim_upper=1.1;
end
set(handles.axes1,'clim',[1,handles.clim_upper]);
set(handles.axes2,'clim',[1,handles.clim_upper]);
set(handles.axes3,'clim',[1,handles.clim_upper]);
set(handles.axes5,'clim',[1,handles.clim_upper]);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'value',0.5)


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'w'
        next_channel_Callback(hObject, eventdata, handles);
    case 's'
        prev_channel_Callback(hObject, eventdata, handles);
    case 'c'
        confirm_t_Callback(hObject, eventdata, handles);
    otherwise
end


% --- Executes on button press in exportdata.
function exportdata_Callback(hObject, eventdata, handles)
% hObject    handle to exportdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.UserData.t_res_steA = handles.t_res(handles.idx_steA);
handles.UserData.t_res_WIND = handles.t_res(handles.idx_WIND);
handles.UserData.t_res_steB = handles.t_res(handles.idx_steB);
handles.UserData.t_res = handles.t_res;
handles.UserData.harmo_f = [get(handles.checkbox1,'value'),...
    get(handles.checkbox2,'value'),get(handles.checkbox3,'value')];
handles.UserData.level=6;

mdata=handles.UserData;
save([handles.UserData.fname_wind(end-15:end-8),'.mat'],'mdata');


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
