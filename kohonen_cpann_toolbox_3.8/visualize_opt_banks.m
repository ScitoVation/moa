function varargout = visualize_opt_banks(varargin)

% visualize_opt_banks opens a graphical interface for entering epoch and
% size bank values for the model optimisation in the model_gui procedure.
% This routine is used in the graphical user interface of the toolbox
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_opt_banks_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_opt_banks_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before visualize_opt_banks is made visible.
function visualize_opt_banks_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 39.5294 33.5714 19.9412]);
set(handles.visualize_opt_banks,'Position',[103.8571 39.5294 33.5714 19.9412]);
set(handles.text_string_7,'Position',[5.4 4.0769 12.6 1.1538]);
set(handles.text_edit_7,'Position',[19.2 4 6 1.3846]);
set(handles.text_string_6,'Position',[5.4 6.1538 12.6 1.1538]);
set(handles.text_edit_6,'Position',[19.2 6.0769 6 1.3846]);
set(handles.text_string_5,'Position',[5.4 8.1538 12.6 1.1538]);
set(handles.text_edit_5,'Position',[19.2 8.0769 6 1.3846]);
set(handles.text_string_4,'Position',[5.4 10.2308 12.6 1.1538]);
set(handles.text_edit_4,'Position',[19.2 10.1538 6 1.3846]);
set(handles.text_string_3,'Position',[5.4 12.2308 12.6 1.1538]);
set(handles.text_edit_3,'Position',[19.2 12.1538 6 1.3846]);
set(handles.text_string_2,'Position',[5.4 14.3077 12.6 1.1538]);
set(handles.text_edit_2,'Position',[19.2 14.2308 6 1.3846]);
set(handles.text_string_1,'Position',[5.4 15.9231 12.6 1.5385]);
set(handles.text_edit_1,'Position',[19.2 16.2308 6 1.3846]);
set(handles.text_title,'Position',[4.6 18.3077 15.4 1.1538]);
set(handles.button_cancel,'Position',[22.6 0.53846 9 1.7692]);
set(handles.button_save,'Position',[3 0.53846 10.8 1.7692]);
set(handles.frame1,'Position',[3 3.2308 28.6 15.3846]);
set(handles.output,'Position',[103.8571 39.5294 33.5714 19.9412]);
movegui(handles.visualize_opt_banks,'center')
handles.bank = varargin{1};
handles.type = varargin{2};
handles = init_labels(handles);

% Update handles structure
guidata(hObject, handles);
uiwait(handles.visualize_opt_banks);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_opt_banks_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = handles.bank;
    delete(handles.visualize_opt_banks)
else
    handles.bank = NaN;
    varargout{1} = handles.bank;
end

% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
errortype = check_banks(handles);
if strcmp(errortype,'none')
    handles.bank = set_banks(handles);
    guidata(hObject,handles);
    uiresume(handles.visualize_opt_banks);
else
    errordlg(errortype,'loading error') 
end

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.bank = NaN;
guidata(hObject,handles);
uiresume(handles.visualize_opt_banks)

% --- Executes during object creation, after setting all properties.
function text_edit_1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_edit_2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_edit_3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_edit_4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_edit_5_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_5_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_edit_6_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_6_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function text_edit_7_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function text_edit_7_Callback(hObject, eventdata, handles)

% -------------------------------------------------------------
function bank = set_banks(handles)

bank(1) = str2num(get(handles.text_edit_1,'String'));
bank(2) = str2num(get(handles.text_edit_2,'String'));
bank(3) = str2num(get(handles.text_edit_3,'String'));
bank(4) = str2num(get(handles.text_edit_4,'String'));
bank(5) = str2num(get(handles.text_edit_5,'String'));
bank(6) = str2num(get(handles.text_edit_6,'String'));
bank(7) = str2num(get(handles.text_edit_7,'String'));

% -------------------------------------------------------------
function handles = init_labels(handles)

if strcmp(handles.type,'size')
    set(handles.visualize_opt_banks,'name','neuron settings')
    set(handles.text_title,'String',' Neuron bank: ')
    str = 'Neurons';
else
    set(handles.visualize_opt_banks,'name','epoch settings')
    set(handles.text_title,'String',' Epoch bank: ')
    str = 'Epochs';
end

set(handles.text_string_1,'String',[str  ' 1:'])
set(handles.text_string_2,'String',[str  ' 2:'])
set(handles.text_string_3,'String',[str  ' 3:'])
set(handles.text_string_4,'String',[str  ' 4:'])
set(handles.text_string_5,'String',[str  ' 5:'])
set(handles.text_string_6,'String',[str  ' 6:'])
set(handles.text_string_7,'String',[str  ' 7:'])

set(handles.text_edit_1,'String',num2str(handles.bank(1)))
set(handles.text_edit_2,'String',num2str(handles.bank(2)))
set(handles.text_edit_3,'String',num2str(handles.bank(3)))
set(handles.text_edit_4,'String',num2str(handles.bank(4)))
set(handles.text_edit_5,'String',num2str(handles.bank(5)))
set(handles.text_edit_6,'String',num2str(handles.bank(6)))
set(handles.text_edit_7,'String',num2str(handles.bank(7)))

% -------------------------------------------------------------
function errortype = check_banks(handles);
errortype = 'none';
% neurons and epochs are numbers
[n, status] = str2num(get(handles.text_edit_1,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end

[n, status] = str2num(get(handles.text_edit_2,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end

[n, status] = str2num(get(handles.text_edit_3,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end

[n, status] = str2num(get(handles.text_edit_4,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end

[n, status] = str2num(get(handles.text_edit_5,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end

[n, status] = str2num(get(handles.text_edit_6,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end

[n, status] = str2num(get(handles.text_edit_7,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'numbers must be integer and higher than 1';
    return
end
