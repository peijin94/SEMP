function varargout = frequencyChannels(varargin)
% FREQUENCYCHANNELS MATLAB code for frequencyChannels.fig
%      FREQUENCYCHANNELS, by itself, creates a new FREQUENCYCHANNELS or raises the existing
%      singleton*.
%
%      H = FREQUENCYCHANNELS returns the handle to a new FREQUENCYCHANNELS or the handle to
%      the existing singleton*.
%
%      FREQUENCYCHANNELS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FREQUENCYCHANNELS.M with the given input arguments.
%
%      FREQUENCYCHANNELS('Property','Value',...) creates a new FREQUENCYCHANNELS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before frequencyChannels_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to frequencyChannels_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help frequencyChannels

% Last Modified by GUIDE v2.5 12-May-2018 09:46:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frequencyChannels_OpeningFcn, ...
                   'gui_OutputFcn',  @frequencyChannels_OutputFcn, ...
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


% --- Executes just before frequencyChannels is made visible.
function frequencyChannels_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to frequencyChannels (see VARARGIN)

% Choose default command line output for frequencyChannels
handles.output = hObject;

if ~isempty(hObject.UserData)
    if hObject.UserData.level>3
        semp_data=hObject.UserData;

        handles.UserData=semp_data;

        handles.t_start = min(semp_data.T_ste(:));
        handles.t_stop  = max(semp_data.T_ste(:));
        handles.t_dur = max(semp_data.T_ste(:))-min(semp_data.T_ste(:));

        
        handles.t1_m=0;
        handles.t2_m=max(handles.UserData.T_ste_m(:));

        axes(handles.axes1)
        h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_A_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        colormap(color_vacu)
        shading interp

        axes(handles.axes2)
        h=pcolor(handles.UserData.T_wind_small,handles.UserData.F_wind_small,handles.UserData.S_wind_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        colormap(color_vacu)
        shading interp

        axes(handles.axes3)
        h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_B_small);
        h.EdgeColor='none';
        set(gca,'clim',[1,25])
        set(gca, 'YScale', 'log')
        ylim([20 1.4e4])
        set(gca,'Layer','top')
        colormap(color_vacu)
        shading interp

        handles.upper1=handles.UserData.upper1;
        handles.upper2=handles.UserData.upper2;
        handles.upper3=handles.UserData.upper3;
        handles.lower1=handles.UserData.lower1;
        handles.lower2=handles.UserData.lower2;
        handles.lower3=handles.UserData.lower3;
        handles.steps1=handles.UserData.steps1;
        handles.steps2=handles.UserData.steps2;
        handles.steps3=handles.UserData.steps3;

        [x,y] = gen_fline(handles.upper1,handles.lower1,handles.steps1,handles.t1_m,handles.t2_m);
        axes(handles.axes1)
        hold on;
        handles.freq_line1=plot(x,y,'k');
        
        [x,y] = gen_fline(handles.upper2,handles.lower2,handles.steps2,handles.t1_m,handles.t2_m);
        axes(handles.axes2)    
        hold on;
        handles.freq_line2=plot(x,y,'k');
        
        [x,y] = gen_fline(handles.upper3,handles.lower3,handles.steps3,handles.t1_m,handles.t2_m);
        axes(handles.axes3)
        hold on;
        handles.freq_line3=plot(x,y,'k');
        
        set(handles.e_step1,'string',num2str(handles.steps1))
        set(handles.e_step2,'string',num2str(handles.steps2))
        set(handles.e_step3,'string',num2str(handles.steps3))

    else
    
    semp_data=hObject.UserData;
    
    handles.UserData=semp_data;
    
    handles.t_start = min(semp_data.T_ste(:));
    handles.t_stop  = max(semp_data.T_ste(:));
    handles.t_dur = max(semp_data.T_ste(:))-min(semp_data.T_ste(:));
    
    handles.UserData.T_ste_m  = (handles.UserData.T_ste-handles.UserData.t1)*24*60;
    handles.UserData.T_wind_m = (handles.UserData.T_wind-handles.UserData.t1)*24*60;

    handles.t1_m=0;
    handles.t2_m=max(handles.UserData.T_ste_m(:));

    handles.UserData.T_ste_small   = handles.UserData.T_ste_m(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);
    handles.UserData.T_wind_small  = handles.UserData.T_wind_m(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);
    handles.UserData.F_ste_small   = handles.UserData.F_ste(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);
    handles.UserData.F_wind_small  = handles.UserData.F_wind(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);
    handles.UserData.S_ste_A_small = handles.UserData.S_ste_A(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);
    handles.UserData.S_wind_small  = handles.UserData.S_wind(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);
    handles.UserData.S_ste_B_small = handles.UserData.S_ste_B(:,handles.UserData.T_ste(1,:)>...
        handles.UserData.t1 & handles.UserData.T_ste(1,:)<handles.UserData.t2);

    
    axes(handles.axes1)
    h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_A_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    colormap(color_vacu)
    shading interp
    
    axes(handles.axes2)
    h=pcolor(handles.UserData.T_wind_small,handles.UserData.F_wind_small,handles.UserData.S_wind_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    colormap(color_vacu)
    shading interp
    
    axes(handles.axes3)
    h=pcolor(handles.UserData.T_ste_small,handles.UserData.F_ste_small,handles.UserData.S_ste_B_small);
    h.EdgeColor='none';
    set(gca,'clim',[1,25])
    set(gca, 'YScale', 'log')
    ylim([20 1.4e4])
    set(gca,'Layer','top')
    colormap(color_vacu)
    shading interp
    
    handles.upper1=5000;
    handles.upper2=5000;
    handles.upper3=5000;
    
    handles.lower1=200;
    handles.lower2=200;
    handles.lower3=200;
    
    handles.steps1=15;
    handles.steps2=15;
    handles.steps3=15;
    
    [x,y] = gen_fline(handles.upper1,handles.lower1,handles.steps1,handles.t1_m,handles.t2_m);
    
    axes(handles.axes1)
    hold on;
    handles.freq_line1=plot(x,y,'k');
    axes(handles.axes2)    
    hold on;
    handles.freq_line2=plot(x,y,'k');
    axes(handles.axes3)
    hold on;
    handles.freq_line3=plot(x,y,'k');
    
    end
    
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes frequencyChannels wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frequencyChannels_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function e_step1_Callback(hObject, eventdata, handles)
% hObject    handle to e_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_step1 as text
%        str2double(get(hObject,'String')) returns contents of e_step1 as a double
str_step = get(hObject,'String');
if isempty(num2str(str_step))
    set(hObject,'String',num2str(handles.steps1))
end
handles.steps1=round(str2double(str_step));
axes(handles.axes1)
delete(handles.freq_line1)
[x,y]=gen_fline(handles.upper1,handles.lower1,handles.steps1,handles.t1_m,handles.t2_m);
handles.freq_line1=plot(x,y,'k');

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function e_step1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_step1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e_step2_Callback(hObject, eventdata, handles)
% hObject    handle to e_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_step2 as text
%        str2double(get(hObject,'String')) returns contents of e_step2 as a double
str_step = get(hObject,'String');
if isempty(num2str(str_step))
    set(hObject,'String',num2str(handles.steps2))
end
handles.steps2=round(str2double(str_step));
axes(handles.axes2)
delete(handles.freq_line2)
[x,y]=gen_fline(handles.upper2,handles.lower2,handles.steps2,handles.t1_m,handles.t2_m);
handles.freq_line2=plot(x,y,'k');

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function e_step2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_step2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function e_step3_Callback(hObject, eventdata, handles)
% hObject    handle to e_step3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e_step3 as text
%        str2double(get(hObject,'String')) returns contents of e_step3 as a double
str_step = get(hObject,'String');
if isempty(num2str(str_step))
    set(hObject,'String',num2str(handles.steps3))
end
handles.steps3=round(str2double(str_step));
axes(handles.axes3)
delete(handles.freq_line3)
[x,y]=gen_fline(handles.upper3,handles.lower3,handles.steps3,handles.t1_m,handles.t2_m);
handles.freq_line3=plot(x,y,'k');

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function e_step3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e_step3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on slider movement.
function lower_s1_Callback(hObject, eventdata, handles)
% hObject    handle to lower_s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_lower = get(handles.lower_s1,'Value');
s_upper = get(handles.upper_s1,'Value');
if s_lower>s_upper
    set(handles.upper_s1,'Value',s_lower+0.08);
    s_upper=s_lower+0.08;
    set(handles.txtupper1,'String', num2str(round(20* 10^(s_upper*log10(1.4e4/20)))));
end
set(handles.txtlower1,'String', num2str(round(20* 10^(s_lower*log10(1.4e4/20)))));
handles.upper1=round(20* 10^(s_upper*log10(1.4e4/20)));
handles.lower1=round(20* 10^(s_lower*log10(1.4e4/20)));

axes(handles.axes1)
delete(handles.freq_line1)
[x,y]=gen_fline(handles.upper1,handles.lower1,handles.steps1,handles.t1_m,handles.t2_m);
handles.freq_line1=plot(x,y,'k');

guidata(hObject, handles);


%f_steps = handles


% --- Executes during object creation, after setting all properties.
function lower_s1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',log10(200/20)/log10(1.4e4/20))


% --- Executes on slider movement.
function upper_s1_Callback(hObject, eventdata, handles)
% hObject    handle to upper_s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_lower = get(handles.lower_s1,'Value');
s_upper = get(handles.upper_s1,'Value');
if s_lower>s_upper
    set(handles.lower_s1,'Value',s_upper-0.08);
    s_lower=s_upper-0.08;
    set(handles.txtlower1,'String', num2str(round(20* 10^(s_lower*log10(1.4e4/20)))));
end
set(handles.txtupper1,'String', num2str(round(20* 10^(s_upper*log10(1.4e4/20)))));
handles.upper1=round(20* 10^(s_upper*log10(1.4e4/20)));
handles.lower1=round(20* 10^(s_lower*log10(1.4e4/20)));

axes(handles.axes1)
delete(handles.freq_line1)
[x,y]=gen_fline(handles.upper1,handles.lower1,handles.steps1,handles.t1_m,handles.t2_m);
handles.freq_line1=plot(x,y,'k');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function upper_s1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_s1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',log10(5000/20)/log10(1.4e4/20))


% --- Executes on slider movement.
function lower_s2_Callback(hObject, eventdata, handles)
% hObject    handle to lower_s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_lower = get(handles.lower_s2,'Value');
s_upper = get(handles.upper_s2,'Value');
if s_lower>s_upper
    set(handles.upper_s2,'Value',s_lower+0.08);
    s_upper=s_lower+0.08;
    set(handles.txtupper2,'String', num2str(round(20* 10^(s_upper*log10(1.4e4/20)))));
end
set(handles.txtlower2,'String', num2str(round(20* 10^(s_lower*log10(1.4e4/20)))));
handles.upper2=round(20* 10^(s_upper*log10(1.4e4/20)));
handles.lower2=round(20* 10^(s_lower*log10(1.4e4/20)));

axes(handles.axes2)
delete(handles.freq_line2)
[x,y]=gen_fline(handles.upper2,handles.lower2,handles.steps2,handles.t1_m,handles.t2_m);
handles.freq_line2=plot(x,y,'k');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lower_s2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',log10(200/20)/log10(1.4e4/20))

% --- Executes on slider movement.
function upper_s2_Callback(hObject, eventdata, handles)
% hObject    handle to upper_s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_lower = get(handles.lower_s2,'Value');
s_upper = get(handles.upper_s2,'Value');
if s_lower>s_upper
    set(handles.lower_s2,'Value',s_upper-0.08);
    s_lower=s_upper-0.08;
    set(handles.txtlower2,'String', num2str(round(20* 10^(s_lower*log10(1.4e4/20)))));
end
set(handles.txtupper2,'String', num2str(round(20* 10^(s_upper*log10(1.4e4/20)))));
handles.upper2=round(20* 10^(s_upper*log10(1.4e4/20)));
handles.lower2=round(20* 10^(s_lower*log10(1.4e4/20)));

axes(handles.axes2)
delete(handles.freq_line2)
[x,y]=gen_fline(handles.upper2,handles.lower2,handles.steps2,handles.t1_m,handles.t2_m);
handles.freq_line2=plot(x,y,'k');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function upper_s2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_s2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',log10(5000/20)/log10(1.4e4/20))

% --- Executes on slider movement.
function lower_s3_Callback(hObject, eventdata, handles)
% hObject    handle to lower_s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_lower = get(handles.lower_s3,'Value');
s_upper = get(handles.upper_s3,'Value');
if s_lower>s_upper
    set(handles.upper_s3,'Value',s_lower+0.08);
    s_upper=s_lower+0.08;
    set(handles.txtupper3,'String', num2str(round(20* 10^(s_upper*log10(1.4e4/20)))));
end
set(handles.txtlower3,'String', num2str(round(20* 10^(s_lower*log10(1.4e4/20)))));
handles.upper3=round(20* 10^(s_upper*log10(1.4e4/20)));
handles.lower3=round(20* 10^(s_lower*log10(1.4e4/20)));

axes(handles.axes3)
delete(handles.freq_line3)
[x,y]=gen_fline(handles.upper3,handles.lower3,handles.steps3,handles.t1_m,handles.t2_m);
handles.freq_line3=plot(x,y,'k');

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lower_s3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',log10(200/20)/log10(1.4e4/20))

% --- Executes on slider movement.
function upper_s3_Callback(hObject, eventdata, handles)
% hObject    handle to upper_s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
s_lower = get(handles.lower_s3,'Value');
s_upper = get(handles.upper_s3,'Value');
if s_lower>s_upper
    set(handles.lower_s3,'Value',s_upper-0.08);
    s_lower=s_upper-0.08;
    set(handles.txtlower3,'String', num2str(round(20* 10^(s_lower*log10(1.4e4/20)))));
end
set(handles.txtupper3,'String', num2str(round(20* 10^(s_upper*log10(1.4e4/20)))));
handles.upper3=round(20* 10^(s_upper*log10(1.4e4/20)));
handles.lower3=round(20* 10^(s_lower*log10(1.4e4/20)));

axes(handles.axes3)
delete(handles.freq_line3)
[x,y]=gen_fline(handles.upper3,handles.lower3,handles.steps3,handles.t1_m,handles.t2_m);
handles.freq_line3=plot(x,y,'k');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function upper_s3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_s3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',log10(5000/20)/log10(1.4e4/20))


function [x,y]=gen_fline(upper,lower,steps,t1,t2)
freqs = logspace(log10(lower), log10(upper), steps);
x = ((mod(1:steps,2)'*[t1,t2])+((1-mod(1:steps,2))'*[t2,t1]))';
y = (freqs'*[1,1])';
x=x(:);
y=y(:);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
handles.UserData.f_res_steA = logspace(log10(handles.lower1), log10(handles.upper1), handles.steps1);
handles.UserData.f_res_WIND = logspace(log10(handles.lower2), log10(handles.upper2), handles.steps2);
handles.UserData.f_res_steB = logspace(log10(handles.lower3), log10(handles.upper3), handles.steps3);

handles.UserData.upper1=handles.upper1;
handles.UserData.upper2=handles.upper2;
handles.UserData.upper3=handles.upper3;
handles.UserData.lower1=handles.lower1;
handles.UserData.lower1=handles.lower2;
handles.UserData.lower1=handles.lower3;

handles.UserData.level=4;

guidata(hObject,handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.UserData.f_res_steA = logspace(log10(handles.lower1), log10(handles.upper1), handles.steps1);
handles.UserData.f_res_WIND = logspace(log10(handles.lower2), log10(handles.upper2), handles.steps2);
handles.UserData.f_res_steB = logspace(log10(handles.lower3), log10(handles.upper3), handles.steps3);

handles.UserData.upper1=handles.upper1;
handles.UserData.upper2=handles.upper2;
handles.UserData.upper3=handles.upper3;
handles.UserData.lower1=handles.lower1;
handles.UserData.lower2=handles.lower2;
handles.UserData.lower3=handles.lower3;
handles.UserData.steps1=handles.steps1;
handles.UserData.steps2=handles.steps2;
handles.UserData.steps3=handles.steps3;

if handles.UserData.level<=4
    handles.UserData.level=4;
end

arrivalTime('UserData',handles.UserData);

guidata(hObject,handles)
