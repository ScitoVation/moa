function varargout = visualize_settings(varargin)

% visualize_settings opens a graphical interface for prepearing
% settings of neural networks in the model_gui procedure.
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
                   'gui_OpeningFcn', @visualize_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_OutputFcn, ...
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


% --- Executes just before visualize_settings is made visible.
function visualize_settings_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 36.8235 151 22.6471]);
set(handles.visualize_settings,'Position',[103.8571 36.8235 151 22.6471]);
set(handles.text18,'Position',[89.8 16.5385 20.2 1.4615]);
set(handles.pop_menu_train,'Position',[117.8 16.6923 21 1.6923]);
set(handles.text17,'Position',[89.8 3.6154 27.2 1.1538]);
set(handles.edit_scalar,'Position',[117.8 3.5385 6 1.5385]);
set(handles.text16,'Position',[5.2 16 17.4 1.2308]);
set(handles.pop_menu_topol,'Position',[5.2 13.5385 38.8 2.4615]);
set(handles.checkbox_absolute_range,'Position',[89.8 7.3077 34.4 1.1538]);
set(handles.text14,'Position',[89.8 5.5385 27.2 1.1538]);
set(handles.text13,'Position',[89.8 10.6154 27.2 1.5385]);
set(handles.text12,'Position',[89.8 12.5385 27.2 1.5385]);
set(handles.text11,'Position',[89.8 14.7692 21.8 1.2308]);
set(handles.text10,'Position',[89.8 18.5385 20.2 1.4615]);
set(handles.edit_cv_groups,'Position',[75 15.1538 6 1.4615]);
set(handles.edit_neurons,'Position',[37.8 11.8462 7.2 1.4615]);
set(handles.pop_menu_assignation,'Position',[117.8 10.6923 21 1.6923]);
set(handles.edit_initial_learning_rate,'Position',[117.8 5.4615 6 1.5385]);
set(handles.edit_final_learning_rate,'Position',[126.4 5.4615 6 1.5385]);
set(handles.pop_menu_scaling,'Position',[117.8 12.6923 21 1.6923]);
set(handles.pop_menu_init,'Position',[117.8 14.6154 21 1.6923]);
set(handles.pop_menu_bound,'Position',[117.8 18.6923 21 1.6923]);
set(handles.button_load_settings,'Position',[90.8 1.3077 20 1.7692]);
set(handles.button_save_settings,'Position',[117.6 1.3077 20 1.7692]);
set(handles.text9,'Position',[90.2 20.8462 19.8 1.1538]);
set(handles.frame3,'Position',[87.4 0.76923 52.6 20.5385]);
set(handles.text8,'Position',[52.2 19.4615 20.8 1.1538]);
set(handles.text7,'Position',[5.2 19.4615 11 1.1538]);
set(handles.text6,'Position',[52.2 14.7692 21.6 1.6923]);
set(handles.pop_menu_cv_type,'Position',[52.2 17.6923 27.8 1.6923]);
set(handles.text4,'Position',[51.6 20.6923 25.2 1.3846]);
set(handles.frame2,'Position',[49.8 8.0769 33.4 13.2308]);
set(handles.text3,'Position',[4.4 20.9231 18.2 1.2308]);
set(handles.text2,'Position',[5.2 9.3846 25.4 1.1538]);
set(handles.edit_epochs,'Position',[37.8 9.2308 7.2 1.5385]);
set(handles.pop_menu_model_type,'Position',[5.2 16.9231 38.8 2.4615]);
set(handles.button_advanced,'Position',[53.4 5.3077 30 1.7692]);
set(handles.button_cancel,'Position',[26.8 5.3077 20 1.7692]);
set(handles.button_calculate_model,'Position',[3 5.3077 20 1.7692]);
set(handles.text1,'Position',[5.2 11.3077 31.6 1.7692]);
set(handles.frame1,'Position',[2.8 8.0769 44 13.2308]);
set(handles.output,'Position',[103.8571 36.8235 151 22.6471]);
movegui(handles.visualize_settings,'center')
handles.data = varargin{1};
handles.number_of_samples = size(handles.data,1);
handles.class_is_present = varargin{2};
handles.model_is_present = varargin{3};
handles.cv_is_present = varargin{5};

% prepare advanced show
handles.show_advanced = 0;
update_advanced_form(handles)

% initialize values
handles.domodel = 0;
handles.v = ver;
% set method combo
str_disp={};
str_disp{1} = 'kohonen maps (unsupervised)';
str_disp{2} = 'counter propagation (supervised)';
str_disp{3} = 'supervised kohonen maps (supervised)';
str_disp{4} = 'XY-Fused network (supervised)';
set(handles.pop_menu_model_type,'String',str_disp);
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    mcalc = varargin{4};
    handles.load_settings = mcalc.net.settings;
    handles = model_values(handles);
else
    handles = init_values(handles);
    if handles.class_is_present
        set(handles.pop_menu_model_type,'Value',2)
    else
        set(handles.pop_menu_model_type,'Value',1)
    end
end

% if we get a calculated cv, we load the same settings
if handles.cv_is_present == 1
    cvcalc = varargin{6};
    handles.load_settings_cv = cvcalc.settings;
    handles = cv_values(handles);
end

% enable/disable buttons
handles = initial_enable_disable(handles);
handles = cv_enable_disable(handles);

guidata(hObject, handles);
uiwait(handles.visualize_settings);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = handles.settings;
    varargout{2} = handles.cv;
    varargout{3} = handles.domodel;
    delete(handles.visualize_settings)
else
    handles.settings = NaN;
    handles.cv = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings;
    varargout{2} = handles.cv;
    varargout{3} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
errortype = check_settings(handles);
if strcmp(errortype,'none')
    [handles.settings,handles.cv] = build_settings(handles);
    handles.domodel = 1;
    guidata(hObject,handles)
    uiresume(handles.visualize_settings)
else
    errordlg(errortype,'loading error') 
end

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
handles.cv = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings)

% --- Executes on button press in button_advanced.
function button_advanced_Callback(hObject, eventdata, handles)
handles.show_advanced = abs(handles.show_advanced - 1);
update_advanced_form(handles)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pop_menu_model_type_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_model_type.
function pop_menu_model_type_Callback(hObject, eventdata, handles)
handles = type_enable_disable(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_neurons_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_neurons_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_topol_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_topol.
function pop_menu_topol_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_scalar_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_scalar_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_epochs_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_epochs_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_cv_type_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_cv_type.
function pop_menu_cv_type_Callback(hObject, eventdata, handles)
handles = cv_enable_disable(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_cv_groups_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_cv_groups_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_save_settings.
function button_save_settings_Callback(hObject, eventdata, handles)
errortype = check_settings(handles);
if strcmp(errortype,'none')
    [export_settings,cv] = build_settings(handles);
    visualize_export(export_settings,'settings')
else
    errordlg(errortype,'loading error') 
end

% --- Executes on button press in button_load_settings.
function button_load_settings_Callback(hObject, eventdata, handles)
res = visualize_load(4,0);
% if settings are loaded, execute this
if ~isnan(res.loaded_file)
    if res.from_file == 1
        tmp_data = load(res.path);
        settings_from_file = getfield(tmp_data,res.name);
    else
        settings_from_file = evalin('base',res.name);
    end
    % check settings
    errortype = check_loaded_settings(settings_from_file);
    if strcmp(errortype,'none')
        handles = file_values(handles,settings_from_file);
    else
        errordlg(errortype,'loading error')
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_final_learning_rate_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in edit_final_learning_rate
function edit_final_learning_rate_Callback(hObject, eventdata, handles)

function edit_initial_learning_rate_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in edit_initial_learning_rate
function edit_initial_learning_rate_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_bound_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_bound.
function pop_menu_bound_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_train_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_train.
function pop_menu_train_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_init_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_init.
function pop_menu_init_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_scaling_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_scaling.
function pop_menu_scaling_Callback(hObject, eventdata, handles)

% --- Executes on button press in checkbox_absolute_range.
function checkbox_absolute_range_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_assignation_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_assignation.
function pop_menu_assignation_Callback(hObject, eventdata, handles)

% ------------------------------------------------------------------
function [settings,cv] = build_settings(handles);
if get(handles.pop_menu_model_type,'Value') == 1
    type = 'kohonen';
elseif get(handles.pop_menu_model_type,'Value') == 2
    type = 'cpann';
elseif get(handles.pop_menu_model_type,'Value') == 3
    type = 'skn';
else
    type = 'xyf';
end
nsize  = str2num(get(handles.edit_neurons,'String'));
epochs = str2num(get(handles.edit_epochs,'String'));
if get(handles.pop_menu_topol,'Value') == 1
    topol = 'square';
else
    topol = 'hexagonal';
end
if get(handles.pop_menu_train,'Value') == 1
    training = 'batch';
else
    training = 'sequential';
end
if get(handles.pop_menu_bound,'Value') == 1
    bound = 'toroidal';
else
    bound = 'normal';
end
if get(handles.pop_menu_init,'Value') == 1
    init = 'random';
else
    init = 'eigen';
end
if get(handles.pop_menu_scaling,'Value') == 1
    scaling = 'none';
elseif get(handles.pop_menu_scaling,'Value') == 2
    scaling = 'cent';
elseif get(handles.pop_menu_scaling,'Value') == 3
    scaling = 'scal';
else
    scaling = 'auto';
end
a_max = str2num(get(handles.edit_initial_learning_rate,'String'));
a_min = str2num(get(handles.edit_final_learning_rate,'String'));
absolute_range = get(handles.checkbox_absolute_range,'Value');

settings          = [];
settings.name     = ['som_settings_' type];
settings.net_type = type;          % net type
settings.nsize    = nsize;          % net size
settings.epochs   = epochs;         % number of total epochs
settings.bound    = bound;          % boundary condition ('toroidal' or 'normal')
settings.training = training;          % training algorithm ('batch' or 'sequential')
settings.init     = init;           % weight initialisation ('random' or 'eigen')
settings.a_max    = a_max;          % initial learning rate
settings.a_min    = a_min;          % final learning rate
settings.topol    = topol;         % topology condition ('square' or 'hexagonal')
settings.absolute_range = absolute_range; % absolute or normal range scaling
settings.scaling = scaling;        % data scaling prior to automatic range scaling
settings.show_bar = 1;             % show waitbar
if ~strcmp(type,'kohonen')
    settings.ass_meth = get(handles.pop_menu_assignation,'Value');  % assignation method for cpann
end
if strcmp(type,'skn')
    settings.scalar = str2num(get(handles.edit_scalar,'String'));  % skn class scaling factor
end

if get(handles.pop_menu_cv_type,'Value') > 1
    cv.type   = get(handles.pop_menu_cv_type,'Value') - 1;
    cv.groups = str2num(get(handles.edit_cv_groups,'String'));
else
    cv.type   = 'none';
    cv.groups = NaN;
end

% ------------------------------------------------------------------
function update_advanced_form(handles)
width_full    = 143;
width_reduced = 86;
if handles.show_advanced == 1
    Pos = get(handles.visualize_settings,'Position');
    Pos(3) = width_full;
    set(handles.visualize_settings,'Position',Pos)
    set(handles.button_advanced,'String','Hide advanced settings <<')
else
    Pos = get(handles.visualize_settings,'Position');
    Pos(3) = width_reduced;
    set(handles.visualize_settings,'Position',Pos)
    set(handles.button_advanced,'String','Show advanced settings >>')
end

% ------------------------------------------------------------------
function handles = initial_enable_disable(handles)
if handles.class_is_present
    set(handles.pop_menu_cv_type,'Enable','on')
    set(handles.edit_cv_groups,'Enable','on')
    set(handles.pop_menu_assignation,'Enable','on')
    set(handles.pop_menu_model_type,'Enable','on')
    if get(handles.pop_menu_model_type,'Value') == 3
        set(handles.edit_scalar,'Enable','on')
    else
        set(handles.edit_scalar,'Enable','off')
    end
    if get(handles.pop_menu_model_type,'Value') == 1
        set(handles.pop_menu_cv_type,'Enable','off')
    end
else
    set(handles.pop_menu_cv_type,'Enable','off')
    set(handles.edit_cv_groups,'Enable','off')
    set(handles.edit_cv_groups,'String','0')
    set(handles.pop_menu_assignation,'Enable','off')   
    set(handles.pop_menu_model_type,'Enable','off')
    set(handles.edit_scalar,'Enable','off')
end

% ------------------------------------------------------------------
function handles = cv_enable_disable(handles)
if get(handles.pop_menu_cv_type,'Value') == 1
    set(handles.edit_cv_groups,'Enable','off')
else
    set(handles.edit_cv_groups,'Enable','on')
end

% ------------------------------------------------------------------
function handles = type_enable_disable(handles)
if get(handles.pop_menu_model_type,'Value') == 1
    set(handles.pop_menu_assignation,'Enable','off')
    set(handles.pop_menu_cv_type,'Enable','off')
    set(handles.edit_cv_groups,'Enable','off')
    set(handles.pop_menu_cv_type,'Value',1)
    set(handles.edit_scalar,'Enable','off')
else
    set(handles.pop_menu_assignation,'Enable','on')
    set(handles.pop_menu_cv_type,'Enable','on')
    set(handles.pop_menu_cv_type,'Value',1)
    set(handles.edit_cv_groups,'Enable','off')
    if get(handles.pop_menu_model_type,'Value') == 3
        set(handles.edit_scalar,'Enable','on')
    else
        set(handles.edit_scalar,'Enable','off')
    end
end

% ------------------------------------------------------------------
function handles = init_values(handles)
set(handles.edit_neurons,'String',NaN)
set(handles.edit_epochs,'String',NaN)
set(handles.edit_cv_groups,'String',5)
set(handles.pop_menu_topol,'Value',1)
set(handles.pop_menu_train,'Value',1)
set(handles.pop_menu_bound,'Value',1)
set(handles.pop_menu_init,'Value',1)
set(handles.pop_menu_scaling,'Value',1)
set(handles.pop_menu_assignation,'Value',1)
set(handles.checkbox_absolute_range,'Value',0)
set(handles.edit_initial_learning_rate,'String',0.5)
set(handles.edit_final_learning_rate,'String',0.01)
set(handles.edit_scalar,'String',1)

% ------------------------------------------------------------------
function handles = model_values(handles)
s = handles.load_settings;
if strcmp(s.name,'som_settings_cpann')
    set(handles.pop_menu_model_type,'Value',2)
elseif strcmp(s.name,'som_settings_skn')
    set(handles.pop_menu_model_type,'Value',3)    
elseif strcmp(s.name,'som_settings_xyf')
    set(handles.pop_menu_model_type,'Value',4)      
else
    set(handles.pop_menu_model_type,'Value',1)
end
set(handles.edit_neurons,'String',s.nsize)
set(handles.edit_epochs,'String',s.epochs)
set(handles.edit_cv_groups,'String',5)
if strcmp(s.bound,'toroidal')
    set(handles.pop_menu_bound,'Value',1)
else
    set(handles.pop_menu_bound,'Value',2)
end
if strcmp(s.init,'random')
    set(handles.pop_menu_init,'Value',1)
else
    set(handles.pop_menu_init,'Value',2)
end
if strcmp(s.topol,'square')
    set(handles.pop_menu_topol,'Value',1)
else
    set(handles.pop_menu_topol,'Value',2)
end
if isfield(s,'ass_meth')
    set(handles.pop_menu_assignation,'Value',s.ass_meth)
else
    set(handles.pop_menu_assignation,'Value',1)
end
if isfield(s,'scalar')
    set(handles.edit_scalar,'String',s.scalar)
else
    set(handles.edit_scalar,'String',1)
end
if strcmp(s.scaling,'none')
    set(handles.pop_menu_scaling,'Value',1)
elseif strcmp(s.scaling,'cent')
    set(handles.pop_menu_scaling,'Value',2)
elseif strcmp(s.scaling,'scal')
    set(handles.pop_menu_scaling,'Value',3)
else
    set(handles.pop_menu_scaling,'Value',4)
end
if strcmp(s.training,'batch')
    set(handles.pop_menu_train,'Value',1)
else
    set(handles.pop_menu_train,'Value',2)
end
set(handles.edit_initial_learning_rate,'String',s.a_max)
set(handles.edit_final_learning_rate,'String',s.a_min)
set(handles.checkbox_absolute_range,'Value',s.absolute_range)

% ------------------------------------------------------------------
function handles = cv_values(handles)
s = handles.load_settings_cv;
if s.cv_type == 1
    set(handles.pop_menu_cv_type,'Value',2)
else
    set(handles.pop_menu_cv_type,'Value',3)
end
set(handles.edit_cv_groups,'String',s.cv_groups)

% ------------------------------------------------------------------
function handles = file_values(handles,settings_from_file)

set(handles.edit_neurons,'String',settings_from_file.nsize)
set(handles.edit_epochs,'String',settings_from_file.epochs)
if strcmp(settings_from_file.bound,'toroidal')
    set(handles.pop_menu_bound,'Value',1)
else
    set(handles.pop_menu_bound,'Value',2)
end
if strcmp(settings_from_file.topol,'square')
    set(handles.pop_menu_topol,'Value',1)
else
    set(handles.pop_menu_topol,'Value',2)
end
if strcmp(settings_from_file.init,'random')
    set(handles.pop_menu_init,'Value',1)
else
    set(handles.pop_menu_init,'Value',2)
end
if isfield(settings_from_file,'ass_meth')
    if get(handles.pop_menu_model_type,'Value') ~= 1
        set(handles.pop_menu_assignation,'Value',settings_from_file.ass_meth)
    end
end
if isfield(settings_from_file,'scalar')
    set(handles.edit_scalar,'Value',settings_from_file.scalar)
end
if strcmp(settings_from_file.scaling,'none')
    set(handles.pop_menu_scaling,'Value',1)
elseif strcmp(settings_from_file.scaling,'cent')
    set(handles.pop_menu_scaling,'Value',2)
elseif strcmp(settings_from_file.scaling,'scal')
    set(handles.pop_menu_scaling,'Value',3)
else
    set(handles.pop_menu_scaling,'Value',4)
end
if strcmp(settings_from_file.training,'batch')
    set(handles.pop_menu_train,'Value',1)
else
    set(handles.pop_menu_train,'Value',2)
end
set(handles.edit_initial_learning_rate,'String',settings_from_file.a_max)
set(handles.edit_final_learning_rate,'String',settings_from_file.a_min)
set(handles.checkbox_absolute_range,'Value',settings_from_file.absolute_range)

% ------------------------------------------------------------------
function errortype = check_settings(handles)
errortype = 'none';
% neurons and epochs are numbers
[n, status] = str2num(get(handles.edit_neurons,'String'));
if status == 0 | isnan(n) | n < 1 | length(n) > 1
    errortype = 'the number of neurons must be an integer positive number';
    return
end
[e, status] = str2num(get(handles.edit_epochs,'String'));
if status == 0 | isnan(e) | e < 1 | length(e) > 1
    errortype = 'the number of epochs must be an integer positive number';
    return
end
if abs(n - round(n)) > 0.00000001
    errortype = 'the number of neurons must be an integer positive number';
    return    
end
if abs(e - round(e)) > 0.00000001
    errortype = 'the number of epochs must be an integer positive number';
    return    
end
% initial and final rates
[i, status] = str2num(get(handles.edit_initial_learning_rate,'String'));
if status == 0 | isnan(i) | i < 0 | length(i) > 1
    errortype = 'the initial learning rate must be a positive number between 0 and 1';
    return
end
[f, status] = str2num(get(handles.edit_final_learning_rate,'String'));
if status == 0 | isnan(f) | f < 0 | length(f) > 1
    errortype = 'the final learning rate must be a positive number between 0 and 1';
    return
end
if i < 0 | i > 1
    errortype = 'the initial learning rate must be a positive number between 0 and 1';
    return    
end
if f < 0 | f > 1
    errortype = 'the final learning rate must be a positive number between 0 and 1';
    return    
end
if f >= i
    errortype = 'the final learning rate must be lower than the initial learning rate';
    return    
end
% scalar value
if get(handles.pop_menu_model_type,'Value') == 3
    [i, status] = str2num(get(handles.edit_scalar,'String'));
    if status == 0 | isnan(i) | i <= 0 | length(i) > 1
        errortype = 'the skn class scaling factor must be a positive number';
        return
    end
end
% if NaNs and eigen initialisation
if get(handles.pop_menu_init,'Value') == 2
    checknan = length(find(isnan(handles.data)));
    if checknan > 0
        errortype = 'missing values are present in the data; the initialisation based on eigenvalues can not be computed';
        return
    end
end
% if present cv group is number and lower than the number of samples
if get(handles.pop_menu_cv_type,'Value') > 1
    [cv, status] = str2num(get(handles.edit_cv_groups,'String'));
    if status == 0 | isnan(cv) | cv < 2 | length(cv) > 1
        errortype = 'the number of cross-validation groups must be an integer number greater than two';
        return
    end
    if abs(cv - round(cv)) > 0.00000001
        errortype = 'the number of cross-validation groups must be an integer number greater than two';
        return    
    end
    if cv > handles.number_of_samples
        errortype = ['the number of cross-validation groups must be equal or lower to the number of samples (' num2str(handles.number_of_samples) ')'];
        return
    end
end
% odd numbers with hexagonal and toroidal settings
if get(handles.pop_menu_topol,'Value') == 2 & get(handles.pop_menu_bound,'Value') == 1
    r = rem(str2num(get(handles.edit_neurons,'String')),2);
    if r ~= 0
        errortype = 'hexagonal topology and toroidal boundary condition require an even number of neurons';
        return
    end
end

% ------------------------------------------------------------------
function errortype = check_loaded_settings(settings_from_file)
errortype = 'none';
% neurons and epochs are numbers
n = settings_from_file.nsize;
if isnan(n) | n < 1 | length(n) > 1
    errortype = 'setting were not loaded: the number of neurons must be an integer positive number';
    return
end
e = settings_from_file.epochs;
if isnan(e) | e < 1 | length(e) > 1
    errortype = 'setting were not loaded: the number of epochs must be an integer positive number';
    return
end
if abs(n - round(n)) > 0.00000001
    errortype = 'setting were not loaded: the number of neurons must be an integer positive number';
    return    
end
if abs(e - round(e)) > 0.00000001
    errortype = 'setting were not loaded: the number of epochs must be an integer positive number';
    return
end
% initial and final rates
i = settings_from_file.a_max;
if isnan(i) | i < 0 | length(i) > 1
    errortype = 'setting were not loaded: the initial learning rate must be a positive number between 0 and 1';
    return
end
f = settings_from_file.a_min;
if isnan(f) | f < 0 | length(f) > 1
    errortype = 'setting were not loaded: the final learning rate must be a positive number between 0 and 1';
    return
end
if i < 0 | i > 1
    errortype = 'setting were not loaded: the initial learning rate must be a positive number between 0 and 1';
    return
end
if f < 0 | f > 1
    errortype = 'setting were not loaded: the final learning rate must be a positive number between 0 and 1';
    return    
end
if f >= i
    errortype = 'setting were not loaded: the final learning rate must be lower than the initial learning rate';
    return    
end
sb = settings_from_file.show_bar;
if sb ~= 0 & sb ~= 1
    errortype = 'setting were not loaded: the show waitbar value must be 0 or 1';
    return    
end
if ~strcmp(settings_from_file.net_type,'kohonen')
    am = settings_from_file.ass_meth;
    if am ~= 1 & am ~= 2 & am ~= 3
        errortype = 'setting were not loaded: the assignation method value must be 1, 2 or 3';
        return    
    end
end
if strcmp(settings_from_file.net_type,'skn')
    sc = settings_from_file.scalar;
    if sc <=0
        errortype = 'setting were not loaded: skn class scaling factor must be positive';
        return    
    end
end
b = settings_from_file.bound;
if ~strcmp('toroidal',b) & ~strcmp('normal',b)
    errortype = 'setting were not loaded: the bound type must be toroidal or normal';
    return    
end
tr = settings_from_file.training;
if ~strcmp('batch',tr) & ~strcmp('sequential',tr)
    errortype = 'setting were not loaded: the training algorithm must be batch or sequential';
    return    
end
en = settings_from_file.init;
if ~strcmp('random',en) & ~strcmp('eigen',en)
    errortype = 'setting were not loaded: the init type must be random or eigen';
    return
end
sc = settings_from_file.scaling;
if ~strcmp('none',sc) & ~strcmp('cent',sc) & ~strcmp('scal',sc) & ~strcmp('auto',sc)
    errortype = 'setting were not loaded: the scaling type must be none, cent, scal or auto';
    return    
end
ar = settings_from_file.absolute_range;
if ar ~= 0 & ar ~= 1
    errortype = 'setting were not loaded: the normal/absolute range scaling value must be 0 or 1';
    return    
end
tp = settings_from_file.topol;
if ~strcmp('square',tp) & ~strcmp('hexagonal',tp)
    errortype = 'setting were not loaded: the topology type must be square or hexagonal';
    return    
end
