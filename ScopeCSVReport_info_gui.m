function varargout = ScopeCSVReport_info_gui(varargin)
% SCOPECSVREPORT_INFO_GUI MATLAB code for ScopeCSVReport_info_gui.fig
%      SCOPECSVREPORT_INFO_GUI, by itself, creates a new SCOPECSVREPORT_INFO_GUI or raises the existing
%      singleton*.
%
%      H = SCOPECSVREPORT_INFO_GUI returns the handle to a new SCOPECSVREPORT_INFO_GUI or the handle to
%      the existing singleton*.
%
%      SCOPECSVREPORT_INFO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCOPECSVREPORT_INFO_GUI.M with the given input arguments.
%
%      SCOPECSVREPORT_INFO_GUI('Property','Value',...) creates a new SCOPECSVREPORT_INFO_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScopeCSVReport_info_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScopeCSVReport_info_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScopeCSVReport_info_gui

% Last Modified by GUIDE v2.5 20-Jan-2016 07:02:00

% Begin initialization code - [DO NOT EDIT]
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScopeCSVReport_info_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ScopeCSVReport_info_gui_OutputFcn, ...
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
% End initialization code - [/DO NOT EDIT]

% --- Executes just before ScopeCSVReport_info_gui is made visible.
function ScopeCSVReport_info_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScopeCSVReport_info_gui (see VARARGIN)

% Choose default command line output for ScopeCSVReport_info_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes ScopeCSVReport_info_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ScopeCSVReport_info_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

initialize_gui(gcbf, handles, true);

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
if isfield(handles, 'metricdata') && ~isreset
    return;
end

% handles.metricdata.density = 0;
% handles.metricdata.volume  = 0;

% set(handles.density, 'String', handles.metricdata.density);
% set(handles.volume,  'String', handles.metricdata.volume);
% set(handles.mass, 'String', 0);

% set(handles.unitgroup, 'SelectedObject', handles.english);
% 
% set(handles.text4, 'String', 'lb/cu.in');
% set(handles.text5, 'String', 'cu.in');
% set(handles.text6, 'String', 'lb');

% Update handles structure
guidata(handles.figure1, handles);

% --- Executes during object deletion, before destroying properties.
function uitable1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in run_pushbutton.
function run_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to run_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in defaults_pushbutton.
function defaults_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to defaults_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ink_checkbox.
function ink_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to ink_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ink_checkbox


% --- Executes on button press in event_checkbox.
function event_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to event_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of event_checkbox


% --- Executes on button press in stats_checkbox.
function stats_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to stats_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stats_checkbox


% --- Executes on button press in hist_checkbox.
function hist_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to hist_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of hist_checkbox



function ch1Thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch1Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch1Thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of ch1Thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function ch1Thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch1Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch2Thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch2Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch2Thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of ch2Thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function ch2Thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch2Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch3Thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch3Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch3Thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of ch3Thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function ch3Thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch3Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ch4Thresh_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ch4Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ch4Thresh_edit as text
%        str2double(get(hObject,'String')) returns contents of ch4Thresh_edit as a double


% --- Executes during object creation, after setting all properties.
function ch4Thresh_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ch4Thresh_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fPath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fPath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fPath_edit as text
%        str2double(get(hObject,'String')) returns contents of fPath_edit as a double
% fName = 


% --- Executes during object creation, after setting all properties.
function fPath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fPath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function manSerialIn_edit_Callback(hObject, eventdata, handles)
% hObject    handle to manSerialIn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manSerialIn_edit as text
%        str2double(get(hObject,'String')) returns contents of manSerialIn_edit as a double


% --- Executes during object creation, after setting all properties.
function manSerialIn_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manSerialIn_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in singleFileSel_but.
function singleFileSel_but_Callback(hObject, eventdata, handles)
% hObject    handle to singleFileSel_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of singleFileSel_but


% --- Executes on button press in multFileSel_but.
function multFileSel_but_Callback(hObject, eventdata, handles)
% hObject    handle to multFileSel_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multFileSel_but


% --- Executes on button press in browse_pushBut.
function browse_pushBut_Callback(hObject, eventdata, handles)
% hObject    handle to browse_pushBut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in serialSelFname_but.
function serialSelFname_but_Callback(hObject, eventdata, handles)
% hObject    handle to serialSelFname_but (see GCBO)
%                                                                                                                                                                  
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of serialSelFname_but


% --- Executes on button press in serlialNum_but.
function serlialNum_but_Callback(hObject, eventdata, handles)
% hObject    handle to serlialNum_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of serlialNum_but


% --- Executes on button press in serialMan_but.
function serialMan_but_Callback(hObject, eventdata, handles)
% hObject    handle to serialMan_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of serialMan_but


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over singleFileSel_but.
function singleFileSel_but_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to singleFileSel_but (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in spect_checkbox.
function spectral_analysis_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to spect_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spect_checkbox


% --- Executes on button press in spect_checkbox.
function spect_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to spect_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of spect_checkbox


% --- Executes on button press in notch_checkbox.
function notch_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to notch_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of notch_checkbox



function notch_edit_Callback(hObject, eventdata, handles)
% hObject    handle to notch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notch_edit as text
%        str2double(get(hObject,'String')) returns contents of notch_edit as a double


% --- Executes during object creation, after setting all properties.
function notch_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
