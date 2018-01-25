function varargout = visualize_opt(varargin)

% visualize_opt opens a graphical interface for prepearing
% settings of optimisation of supervised models.
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
                   'gui_OpeningFcn', @visualize_opt_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_opt_OutputFcn, ...
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


% --- Executes just before visualize_opt is made visible.
function visualize_opt_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 36.5294 151.2857 22.9412]);
set(handles.visualize_opt,'Position',[103.8571 36.5294 151.2857 22.9412]);
set(handles.text21,'Position',[89.8 16.6923 20.2 1.4615]);
set(handles.pop_menu_train,'Position',[117.8 16.9231 21 1.6923]);
set(handles.text20,'Position',[89.8 1.6923 27.2 1.5385]);
set(handles.pop_menu_optfun,'Position',[117.8 1.7692 21 1.6923]);
set(handles.text19,'Position',[89.8 3.6154 27.2 1.5385]);
set(handles.pop_menu_repeat,'Position',[117.8 3.7692 21 1.6923]);
set(handles.button_epoch,'Position',[75.2 6.9231 6.6 1.7692]);
set(handles.button_size,'Position',[75.2 9.3846 6.6 1.7692]);
set(handles.text18,'Position',[4.4 11.4615 32.4 1.1538]);
set(handles.text17,'Position',[89.8 5.8462 27.2 1.1538]);
set(handles.edit_scalar,'Position',[117.8 5.7692 6 1.5385]);
set(handles.text16,'Position',[5.2 16.2308 17.4 1.2308]);
set(handles.pop_menu_topol,'Position',[5.2 13.7692 38.8 2.4615]);
set(handles.checkbox_absolute_range,'Position',[89.8 9.5385 34.4 1.1538]);
set(handles.text14,'Position',[89.8 7.7692 27.2 1.1538]);
set(handles.text13,'Position',[89.8 10.8462 27.2 1.5385]);
set(handles.text12,'Position',[89.8 12.7692 27.2 1.5385]);
set(handles.text11,'Position',[89.8 15 21.8 1.2308]);
set(handles.text10,'Position',[89.8 18.6923 20.2 1.4615]);
set(handles.edit_cv_groups,'Position',[74.8 15.6923 6 1.4615]);
set(handles.pop_menu_assignation,'Position',[117.8 10.9231 21 1.6923]);
set(handles.edit_initial_learning_rate,'Position',[117.8 7.6923 6 1.5385]);
set(handles.edit_final_learning_rate,'Position',[126.4 7.6923 6 1.5385]);
set(handles.pop_menu_scaling,'Position',[117.8 12.9231 21 1.6923]);
set(handles.pop_menu_init,'Position',[117.8 14.9231 21 1.6923]);
set(handles.pop_menu_bound,'Position',[117.8 18.9231 21 1.6923]);
set(handles.text9,'Position',[89.2 21.1538 19.8 1.1538]);
set(handles.frame3,'Position',[87.4 1.1538 52.6 20.3846]);
set(handles.text8,'Position',[52.2 19.6154 20.8 1.1538]);
set(handles.text7,'Position',[5.2 19.6154 11 1.1538]);
set(handles.text6,'Position',[52.4 14 22 3.4615]);
set(handles.pop_menu_cv_type,'Position',[52.2 17.9231 27.8 1.6923]);
set(handles.text4,'Position',[51.6 20.9231 25.2 1.3846]);
set(handles.frame2,'Position',[49.8 13.3846 33.4 8.1538]);
set(handles.text3,'Position',[4.4 21.1538 18.2 1.2308]);
set(handles.text_epoch,'Position',[5 7.2308 69.8 1.1538]);
set(handles.pop_menu_model_type,'Position',[5.2 17.1538 38.8 2.4615]);
set(handles.button_advanced,'Position',[53.4 3.2308 30 1.7692]);
set(handles.button_cancel,'Position',[26.8 3.2308 20 1.7692]);
set(handles.button_calculate_model,'Position',[3 3.2308 20 1.7692]);
set(handles.text_size,'Position',[4.8 9.7692 69.8 1.1538]);
set(handles.frame1,'Position',[2.8 13.3846 44 8.1538]);
set(handles.frame4,'Position',[2.6 6 80.8 5.8462]);
set(handles.output,'Position',[103.8571 36.5294 151.2857 22.9412]);
movegui(handles.visualize_opt,'center')
handles.data = varargin{1};
handles.number_of_samples = size(handles.data,1);
handles.model_is_present = varargin{2};
handles.class_is_present = 1;

% prepare advanced show
handles.show_advanced = 0;
update_advanced_form(handles)

% initialize values
handles.domodel = 0;
% set method combo
str_disp={};
str_disp{1} = 'counter propagation (supervised)';
str_disp{2} = 'supervised kohonen maps (supervised)';
str_disp{3} = 'XY-Fused network (supervised)';
set(handles.pop_menu_model_type,'String',str_disp);

% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    mcalc = varargin{3};
    handles.load_settings = mcalc.net.settings;
    handles = model_values(handles);
else
    handles = init_values(handles);
    set(handles.pop_menu_model_type,'Value',1)
end

% initialise combo for repetitions 
for k=1:5
    str_disp{k} = num2str(k);
end
set(handles.pop_menu_repeat,'String',str_disp);
set(handles.pop_menu_repeat,'Value',5)

% initialise combo for optimisation function
str_disp={};
str_disp{1} = 'NER test balanced';
str_disp{2} = 'NER test';
set(handles.pop_menu_optfun,'String',str_disp);

% enable/disable buttons
handles = initial_enable_disable(handles);

% initialise neuron and epoch banks
handles.ep_bank = [50 100 150 200 250 300 350];
handles.ns_bank = [4 6 8 10 12 14 16];
handles = write_banks(handles);

guidata(hObject, handles);
uiwait(handles.visualize_opt);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_opt_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    varargout{1} = handles.settings;
    varargout{2} = handles.cv;
    varargout{3} = handles.ns_bank;
    varargout{4} = handles.ep_bank;
    varargout{5} = handles.rep_model;
    varargout{6} = handles.opt_fun;
    varargout{7} = handles.domodel;
    delete(handles.visualize_opt)
else
    handles.settings = NaN;
    handles.cv = NaN;
    handles.ns_bank = NaN;
    handles.ep_bank = NaN;
    handles.rep_model = NaN;
    handles.opt_fun = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings;
    varargout{2} = handles.cv;
    varargout{3} = handles.ns_bank;
    varargout{4} = handles.ep_bank;
    varargout{5} = handles.rep_model;
    varargout{6} = handles.opt_fun;
    varargout{7} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
errortype = check_settings(handles);
if strcmp(errortype,'none')
    [handles.settings,handles.cv] = build_settings(handles);
    handles.rep_model = get(handles.pop_menu_repeat,'Value');
    handles.opt_fun   = get(handles.pop_menu_optfun,'Value');
    handles.domodel = 1;
    guidata(hObject,handles)
    uiresume(handles.visualize_opt)
else
    errordlg(errortype,'loading error') 
end

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
handles.cv = NaN;
handles.rep_model = NaN;
handles.opt_fun   = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_opt)

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
function pop_menu_optfun_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_optfun.
function pop_menu_optfun_Callback(hObject, eventdata, handles)

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
function pop_menu_cv_type_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_cv_type.
function pop_menu_cv_type_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit_cv_groups_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function edit_cv_groups_Callback(hObject, eventdata, handles)

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
function pop_menu_repeat_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_repeat.
function pop_menu_repeat_Callback(hObject, eventdata, handles)

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

% --- Executes on button press in button_epoch.
function button_epoch_Callback(hObject, eventdata, handles)
bank = visualize_opt_banks(handles.ep_bank,'epoch');
if length(bank) > 1
    handles.ep_bank = bank;
    handles = write_banks(handles);
end
guidata(hObject, handles);

% --- Executes on button press in button_size.
function button_size_Callback(hObject, eventdata, handles)
bank = visualize_opt_banks(handles.ns_bank,'size');
if length(bank) > 1
    handles.ns_bank = bank;
    handles = write_banks(handles);
end
guidata(hObject, handles);

% ------------------------------------------------------------------
function [settings,cv] = build_settings(handles);
if get(handles.pop_menu_model_type,'Value') == 1
    type = 'cpann';
elseif get(handles.pop_menu_model_type,'Value') == 2
    type = 'skn';
else
    type = 'xyf';
end
nsize  = NaN;
epochs = NaN;
if get(handles.pop_menu_topol,'Value') == 1
    topol = 'square';
else
    topol = 'hexagonal';
end
if get(handles.pop_menu_bound,'Value') == 1
    bound = 'toroidal';
else
    bound = 'normal';
end
if get(handles.pop_menu_train,'Value') == 1
    training = 'batch';
else
    training = 'sequential';
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

settings         = [];
settings.name    = ['som_settings_' type];
settings.net_type = type;          % net type
settings.nsize   = nsize;          % net size
settings.epochs  = epochs;         % number of total epochs
settings.bound   = bound;          % boundary condition ('toroidal' or 'normal')
settings.training = training;      % training algorithm ('batch' or 'sequential')
settings.init    = init;           % weight initialisation ('random' or 'eigen')
settings.a_max   = a_max;          % initial learning rate
settings.a_min   = a_min;          % final learning rate
settings.topol    = topol;         % topology condition ('square' or 'hexagonal')
settings.absolute_range = absolute_range; % absolute or normal range scaling
settings.scaling = scaling;        % data scaling prior to automatic range scaling
settings.show_bar = 1;             % show waitbar
settings.ass_meth = get(handles.pop_menu_assignation,'Value');  % assignation method for cpann
if strcmp(type,'skn')
    settings.scalar = str2num(get(handles.edit_scalar,'String'));  % skn class scaling factor
end

cv.type   = get(handles.pop_menu_cv_type,'Value') - 1;
if cv.type == 0
    cv.type = 3;
end
cv.groups = str2num(get(handles.edit_cv_groups,'String'));

% ------------------------------------------------------------------
function update_advanced_form(handles)
width_full    = 143;
width_reduced = 86;
if handles.show_advanced == 1
    Pos = get(handles.visualize_opt,'Position');
    Pos(3) = width_full;
    set(handles.visualize_opt,'Position',Pos)
    set(handles.button_advanced,'String','Hide advanced settings <<')
else
    Pos = get(handles.visualize_opt,'Position');
    Pos(3) = width_reduced;
    set(handles.visualize_opt,'Position',Pos)
    set(handles.button_advanced,'String','Show advanced settings >>')
end

% ------------------------------------------------------------------
function handles = initial_enable_disable(handles)
if handles.class_is_present
    set(handles.pop_menu_cv_type,'Enable','on')
    set(handles.edit_cv_groups,'Enable','on')
    set(handles.pop_menu_assignation,'Enable','on')
    set(handles.pop_menu_model_type,'Enable','on')
    if get(handles.pop_menu_model_type,'Value') == 2
        set(handles.edit_scalar,'Enable','on')
    else
        set(handles.edit_scalar,'Enable','off')
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
function handles = type_enable_disable(handles)
if get(handles.pop_menu_model_type,'Value') == 2
    set(handles.edit_scalar,'Enable','on')
else
    set(handles.edit_scalar,'Enable','off')
end

% ------------------------------------------------------------------
function handles = write_banks(handles);

str_size = ['Neurons (on each side) to be optimised: [' num2str(handles.ns_bank(1))];
for k = 2:length(handles.ns_bank)
    str_size = [str_size '; ' num2str(handles.ns_bank(k))];
end
str_size = [str_size ']'];

str_epoch = ['Training epochs to be optimised: [' num2str(handles.ep_bank(1))];
for k = 2:length(handles.ep_bank)
    str_epoch = [str_epoch '; ' num2str(handles.ep_bank(k))];
end
str_epoch = [str_epoch ']'];

set(handles.text_size,'String',str_size)
set(handles.text_epoch,'String',str_epoch)

% ------------------------------------------------------------------
function handles = init_values(handles)
set(handles.edit_cv_groups,'String',10)
set(handles.pop_menu_topol,'Value',1)
set(handles.pop_menu_bound,'Value',1)
set(handles.pop_menu_train,'Value',1)
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
    set(handles.pop_menu_model_type,'Value',1)
elseif strcmp(s.name,'som_settings_skn')
    set(handles.pop_menu_model_type,'Value',2)    
else
    set(handles.pop_menu_model_type,'Value',3)
end
set(handles.edit_cv_groups,'String',10)
if strcmp(s.bound,'toroidal')
    set(handles.pop_menu_bound,'Value',1)
else
    set(handles.pop_menu_bound,'Value',2)
end
if strcmp(s.training,'batch')
    set(handles.pop_menu_train,'Value',1)
else
    set(handles.pop_menu_train,'Value',2)
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
set(handles.edit_initial_learning_rate,'String',s.a_max)
set(handles.edit_final_learning_rate,'String',s.a_min)
set(handles.checkbox_absolute_range,'Value',s.absolute_range)

% ------------------------------------------------------------------
function errortype = check_settings(handles)
errortype = 'none';
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
    for k=1:length(handles.ns_bank)
        r = rem(handles.ns_bank(k),2);
        if r ~= 0
            errortype = 'hexagonal topology and toroidal boundary condition require even numbers of neurons';
            return
        end
    end
end

