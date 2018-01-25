function varargout = visualize_labels(varargin)

% visualize_labels opens a graphical interface for visaulising labels in kohonen maps
% visualize_labels is used by visualize_map.
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
                   'gui_OpeningFcn', @visualize_labels_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_labels_OutputFcn, ...
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


% --- Executes just before visualize_labels is made visible.
function visualize_labels_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 38.6471 45.5714 20.8235]);
set(handles.visualize_labels,'Position',[103.8571 38.6471 45.5714 20.8235]);
set(handles.list_labels,'Position',[3.8 2.4615 36.2 15.3846]);
set(handles.text1,'Position',[3.4 18.8462 32 1.1538]);
set(handles.frame1,'Position',[1.6 0.92308 41.6 18.3077]);
set(handles.output,'Position',[103.8571 38.6471 45.5714 20.8235]);
movegui(handles.visualize_labels,'center');
cur_labs = varargin{1};
set(handles.list_labels,'Value',1);
set(handles.list_labels,'String',cur_labs);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_labels_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function list_labels_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in list_labels.
function list_labels_Callback(hObject, eventdata, handles)