function varargout = selectTimeRange(varargin)
% SELECTTIMERANGE MATLAB code for selectTimeRange.fig
%      SELECTTIMERANGE, by itself, creates a new SELECTTIMERANGE or raises the existing
%      singleton*.
%
%      H = SELECTTIMERANGE returns the handle to a new SELECTTIMERANGE or the handle to
%      the existing singleton*.
%
%      SELECTTIMERANGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTTIMERANGE.M with the given input arguments.
%
%      SELECTTIMERANGE('Property','Value',...) creates a new SELECTTIMERANGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before selectTimeRange_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to selectTimeRange_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help selectTimeRange

% Last Modified by GUIDE v2.5 05-May-2018 22:21:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @selectTimeRange_OpeningFcn, ...
                   'gui_OutputFcn',  @selectTimeRange_OutputFcn, ...
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


% --- Executes just before selectTimeRange is made visible.
function selectTimeRange_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to selectTimeRange (see VARARGIN)

% Choose default command line output for selectTimeRange
handles.output = hObject;

if ~isempty(hObject.UserData)
    
    if hObject.UserData.level>2
        semp_data=hObject.UserData;

        handles.t_start = min(semp_data.T_ste(:));
        handles.t_stop  = max(semp_data.T_ste(:));
        handles.t_dur = max(semp_data.T_ste(:))-min(semp_data.T_ste(:));

        handles.t1 = min(semp_data.T_ste(:));
        handles.t2 = min(semp_data.T_ste(:)) +1/14.4;

        axes(handles.axes1)
        h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_A);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        datetick('x','HH:MM','keeplimits')
        colormap(color_vacu)

        axes(handles.axes2)
        h=pcolor(semp_data.T_wind,semp_data.F_wind,semp_data.S_wind);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        datetick('x','HH:MM','keeplimits')
        colormap(color_vacu)

        axes(handles.axes3)
        h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_B);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        datetick('x','HH:MM','keeplimits')
        colormap(color_vacu)
        handles.UserData=semp_data;

        axes(handles.axes4)
        h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_A);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        xlim([semp_data.t1,semp_data.t2])
        set(gca,'Layer','top')
        datetick('x','HH:MM','keeplimits')
        colormap(color_vacu)

        axes(handles.axes5)
        h=pcolor(semp_data.T_wind,semp_data.F_wind,semp_data.S_wind);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        xlim([semp_data.t1,semp_data.t2])
        set(gca,'Layer','top')
        datetick('x','HH:MM','keeplimits')
        colormap(color_vacu)

        axes(handles.axes6)
        h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_B);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        xlim([semp_data.t1,semp_data.t2])
        set(gca,'Layer','top')
        datetick('x','HH:MM','keeplimits')
        colormap(color_vacu)
        
        set(handles.edit1,'string',datestr(semp_data.t1,'HH:MM'))
        set(handles.edit2,'string',datestr(semp_data.t2,'HH:MM'))
        
        set(handles.slider1, 'Value', (semp_data.t1-handles.t_start)/(handles.t_stop-handles.t_start));
        set(handles.slider2, 'Value', (semp_data.t2-handles.t_start)/(handles.t_stop-handles.t_start));  

        handles.t1 = semp_data.t1;
        handles.t2 = semp_data.t2;        
        
        handles.UserData=semp_data;
    else
    semp_data=hObject.UserData;

    handles.t_start = min(semp_data.T_ste(:));
    handles.t_stop  = max(semp_data.T_ste(:));
    handles.t_dur = max(semp_data.T_ste(:))-min(semp_data.T_ste(:));
    
    handles.t1 = min(semp_data.T_ste(:));
    handles.t2 = min(semp_data.T_ste(:)) +1/14.4;
    
    axes(handles.axes1)
    h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_A);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    datetick('x','HH:MM','keeplimits')
    colormap(color_vacu)
    
    axes(handles.axes2)
    h=pcolor(semp_data.T_wind,semp_data.F_wind,semp_data.S_wind);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    datetick('x','HH:MM','keeplimits')
    colormap(color_vacu)

    axes(handles.axes3)
    h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_B);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    datetick('x','HH:MM','keeplimits')
    colormap(color_vacu)
    handles.UserData=semp_data;
    
    axes(handles.axes4)
    h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_A);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    xlim([handles.t_start,handles.t_start+1/14.4])
    set(gca,'Layer','top')
    datetick('x','HH:MM','keeplimits')
    colormap(color_vacu)
    
    axes(handles.axes5)
    h=pcolor(semp_data.T_wind,semp_data.F_wind,semp_data.S_wind);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    xlim([handles.t_start,handles.t_start+1/14.4])
    set(gca,'Layer','top')
    datetick('x','HH:MM','keeplimits')
    colormap(color_vacu)

    axes(handles.axes6)
    h=pcolor(semp_data.T_ste,semp_data.F_ste,semp_data.S_ste_B);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    xlim([handles.t_start,handles.t_start+1/14.4])
    set(gca,'Layer','top')
    datetick('x','HH:MM','keeplimits')
    colormap(color_vacu)
    handles.UserData=semp_data;
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes selectTimeRange wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = selectTimeRange_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s_cur=get(hObject,'Value');
s_2 = get(handles.slider2,'Value');
if s_2<s_cur
    set(handles.slider2, 'Value', min(1,s_cur+1.5/144));
    s_2=s_cur+1.5/144;
elseif s_2>s_cur+1/14.4
    set(handles.slider2, 'Value', s_cur+1/14.4);
    s_2=s_cur+1/14.4;
end
handles.t1=handles.t_start+(handles.t_dur)*s_cur;
handles.t2=handles.t_start+(handles.t_dur)*s_2;

    axes(handles.axes4)
    set(gca,'xlim',[handles.t1,handles.t2])
    axes(handles.axes5)
    set(gca,'xlim',[handles.t1,handles.t2])
    axes(handles.axes6)
    set(gca,'xlim',[handles.t1,handles.t2])

set(handles.edit1,'string',datestr(handles.t1,'HH:MM'))
set(handles.edit2,'string',datestr(handles.t2,'HH:MM'))

guidata(hObject, handles);
    

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_cur=get(hObject,'Value');
s_1 = get(handles.slider1,'Value');
if s_1>s_cur
    set(handles.slider1, 'Value', max(0,s_cur-1.5/144));
    s_1=s_cur-1.5/144;
elseif s_1<s_cur-1/14.4
    set(handles.slider1, 'Value', s_cur-1/14.4);
    s_1=s_cur-1/14.4;
end
handles.t1=handles.t_start+(handles.t_dur)*s_1;
handles.t2=handles.t_start+(handles.t_dur)*s_cur;

    axes(handles.axes4)
    set(gca,'xlim',[handles.t1,handles.t2])
    axes(handles.axes5)
    set(gca,'xlim',[handles.t1,handles.t2])
    axes(handles.axes6)
    set(gca,'xlim',[handles.t1,handles.t2])

set(handles.edit1,'string',datestr(handles.t1,'HH:MM'))
set(handles.edit2,'string',datestr(handles.t2,'HH:MM'))

guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'value',100/1440)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','00:00')



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String','01:40')


% --- Executes on slider movement.
function slider_color_Callback(hObject, eventdata, handles)
% hObject    handle to slider_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


cscale=get(hObject,'Value')*50;

semp_data=handles.UserData;
    axes(handles.axes1)
    set(gca,'clim',[1,cscale])
    axes(handles.axes2)
    set(gca,'clim',[1,cscale])
    axes(handles.axes3)
    set(gca,'clim',[1,cscale])
    axes(handles.axes4)
    set(gca,'clim',[1,cscale])
    axes(handles.axes5)
    set(gca,'clim',[1,cscale])
    axes(handles.axes6)
    set(gca,'clim',[1,cscale])
    

% --- Executes during object creation, after setting all properties.
function slider_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);

end
set(hObject,'Value',0.5)


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.UserData.t1 = handles.t1;
handles.UserData.t2 = handles.t2;
if handles.UserData.level <= 3
    handles.UserData.level =3;
end

% pass the data to the next step
frequencyChannels('UserData',handles.UserData);
guidata(hObject, handles);
