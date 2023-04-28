function varargout = loadData(varargin)
% LOADDATA MATLAB code for loadData.fig
%      LOADDATA, by itself, creates a new LOADDATA or raises the existing
%      singleton*.
%
%      H = LOADDATA returns the handle to a new LOADDATA or the handle to
%      the existing singleton*.
%
%      LOADDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADDATA.M with the given input arguments.
%
%      LOADDATA('Property','Value',...) creates a new LOADDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before loadData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to loadData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help loadData

% Last Modified by GUIDE v2.5 11-May-2018 21:22:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @loadData_OpeningFcn, ...
                   'gui_OutputFcn',  @loadData_OutputFcn, ...
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


% --- Executes just before loadData is made visible.
function loadData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to loadData (see VARARGIN)

% Choose default command line output for loadData
handles.output = hObject;
semp_data=hObject.UserData;
if isempty(semp_data)
    semp_data.level=0;
elseif semp_data.level>=1
    set(handles.dir_wind   , 'String' , semp_data.fname_wind);
    set(handles.dir_stereo , 'String' , semp_data.fname_stereo);
end
handles.UserData=semp_data;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes loadData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = loadData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.UserData;


% --- Executes on button press in loadwind.
function loadwind_Callback(hObject, eventdata, handles)
% hObject    handle to loadwind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
[FileName,PathName,~] = uigetfile('*.cdf','Select wind data');
set(handles.dir_wind,'String',FileName)
handles.UserData.fname_wind=[PathName,FileName];

if (~strcmp(get(handles.dir_stereo,'String'),'dir')) &&...
        (~strcmp(get(handles.dir_wind,'String'),'dir'))
    handles.UserData.level=1;
    disp('level 1')
end

guidata(hObject, handles);


% --- Executes on button press in loadstereo.
function loadstereo_Callback(hObject, eventdata, handles)
% hObject    handle to loadstereo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,~] = uigetfile('*.cdf','Select stereo data');
set(handles.dir_stereo,'String',FileName)
handles.UserData.fname_stereo=[PathName,FileName];

if (~strcmp(get(handles.dir_stereo,'String'),'dir')) &&...
        (~strcmp(get(handles.dir_wind,'String'),'dir'))
    handles.UserData.level=1;
    disp('level 1')
end

guidata(hObject, handles);



% --- Executes on button press in nextstep.
function nextstep_Callback(hObject, eventdata, handles)
% hObject    handle to nextstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.UserData.level>2)
    selectTimeRange('UserData',handles.UserData);
elseif (~strcmp(get(handles.dir_stereo,'String'),'dir')) &&...
        (~strcmp(get(handles.dir_wind,'String'),'dir'))
    handles.UserData.level=1;
    [handles.UserData.T_ste,handles.UserData.T_wind,...
        handles.UserData.F_ste,handles.UserData.F_wind,...
        handles.UserData.freq_ste,handles.UserData.freq_wind,...
        handles.UserData.S_ste_A,handles.UserData.S_wind,handles.UserData.S_ste_B] = ...
        read_data_wind_stereo(handles.UserData.fname_stereo,handles.UserData.fname_wind);
    handles.UserData.level=2;
    disp('level 2')
    
    handles.UserData.v_sw    = str2num(get(handles.edit_sw,'string'));
    handles.UserData.r_ste_A_AU  = str2num(get(handles.edit_r_ste_A, 'string'));
    handles.UserData.r_WIND_AU   = str2num(get(handles.edit_r_wind,  'string'));
    handles.UserData.r_ste_B_AU  = str2num(get(handles.edit_r_ste_B, 'string'));
    handles.UserData.angel_A = str2num(get(handles.edit_a_ste_A, 'string'));
    handles.UserData.angel_W = str2num(get(handles.edit_a_wind,  'string'));
    handles.UserData.angel_B = str2num(get(handles.edit_a_ste_B, 'string'));
    
    guidata(hObject,handles);
    
    selectTimeRange('UserData',handles.UserData);
end
guidata(hObject,handles);



function edit_r_ste_A_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r_ste_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r_ste_A as text
%        str2double(get(hObject,'String')) returns contents of edit_r_ste_A as a double


% --- Executes during object creation, after setting all properties.
function edit_r_ste_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r_ste_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_r_wind_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r_wind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r_wind as text
%        str2double(get(hObject,'String')) returns contents of edit_r_wind as a double


% --- Executes during object creation, after setting all properties.
function edit_r_wind_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r_wind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_r_ste_B_Callback(hObject, eventdata, handles)
% hObject    handle to edit_r_ste_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_r_ste_B as text
%        str2double(get(hObject,'String')) returns contents of edit_r_ste_B as a double


% --- Executes during object creation, after setting all properties.
function edit_r_ste_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_r_ste_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_a_ste_A_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a_ste_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a_ste_A as text
%        str2double(get(hObject,'String')) returns contents of edit_a_ste_A as a double


% --- Executes during object creation, after setting all properties.
function edit_a_ste_A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a_ste_A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_a_wind_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a_wind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a_wind as text
%        str2double(get(hObject,'String')) returns contents of edit_a_wind as a double


% --- Executes during object creation, after setting all properties.
function edit_a_wind_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a_wind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_a_ste_B_Callback(hObject, eventdata, handles)
% hObject    handle to edit_a_ste_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_a_ste_B as text
%        str2double(get(hObject,'String')) returns contents of edit_a_ste_B as a double


% --- Executes during object creation, after setting all properties.
function edit_a_ste_B_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_a_ste_B (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load data from mat file
[fname,pname,~] = uigetfile('*.mat','Import data');
tmp_data_read = load([pname,fname]);
handles.UserData = tmp_data_read.mdata;
tmp_data = tmp_data_read.mdata;
set(handles.dir_wind,'string',tmp_data.fname_wind)
set(handles.dir_stereo,'string',tmp_data.fname_stereo)
set(handles.edit_sw,'string',num2str(tmp_data.v_sw))

set(handles.edit_r_ste_A, 'string',num2str(tmp_data.r_ste_A_AU))
set(handles.edit_r_wind,  'string',num2str(tmp_data.r_WIND_AU))
set(handles.edit_r_ste_B, 'string',num2str(tmp_data.r_ste_B_AU))

set(handles.edit_a_ste_A, 'string',num2str(tmp_data.angel_A))
set(handles.edit_a_wind,  'string',num2str(tmp_data.angel_W))
set(handles.edit_a_ste_B, 'string',num2str(tmp_data.angel_B))

guidata(hObject,handles);



function edit_sw_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sw as text
%        str2double(get(hObject,'String')) returns contents of edit_sw as a double


% --- Executes during object creation, after setting all properties.
function edit_sw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
