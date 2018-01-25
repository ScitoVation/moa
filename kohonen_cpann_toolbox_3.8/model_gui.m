function varargout = model_gui(varargin)

% model_gui opens the main GUI figure for calculating Kohonen maps, CPANNs, XY-Fs and SKNs;
% in order to open the graphical interface, just type on the matlab command line:
%
% model_gui
%
% there are no inputs, data can be loaded and saved directly from the 
% graphical interface
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
                   'gui_OpeningFcn', @model_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @model_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before model_gui is made visible.
function model_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 46 99.5714 11.9412]);
set(handles.model_gui,'Position',[103.8571 46 99.5714 11.9412]);
set(handles.button_predict_samples,'Position',[74 1.3077 23 1.7692]);
set(handles.button_view_top_map,'Position',[74 6.4615 23 1.7692]);
set(handles.button_view_results,'Position',[74 3.8462 23 1.7692]);
set(handles.button_calculate,'Position',[74 8.8462 23 1.7692]);
set(handles.listbox_model,'Position',[38.6 1.1538 33 9.6154]);
set(handles.listbox_data,'Position',[3 1.1538 33 9.6154]);
set(handles.output,'Position',[103.8571 46 99.5714 11.9412]);
movegui(handles.model_gui,'center');

% initialize handles
handles = init_handles(handles);

% enable/disable buttons and menu
handles = enable_disable(handles);

% updtae list boxes
update_listbox_data(handles)
update_listbox_model(handles)

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = model_gui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_file_load_data_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.data == 1
    q = questdlg('Data are alreday loaded. Do you wish to overwrite them?','loading data','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes')
    res = visualize_load(1,0);
    if isnan(res.loaded_file)
        if handles.present.data  == 0
            handles.present.data  = 0;
        else
            handles.present.data  = 1;
        end
    elseif res.from_file == 1
        handles.present.data  = 1;
        if handles.present.model == 2; handles.present.model = 1; end % model becames loaded instead of calculated
        tmp_data = load(res.path);
        handles.data.X = getfield(tmp_data,res.name);
        handles.data.name_data = res.name;
        handles = reset_class(handles);
        handles = reset_pred(handles);
        handles = reset_opt(handles);
        handles = reset_labels(handles);
    else
        handles.present.data  = 1;
        if handles.present.model == 2; handles.present.model = 1; end % model becames loaded instead of calculated
        handles.data.X = evalin('base',res.name);
        handles.data.name_data = res.name;
        handles = reset_class(handles);
        handles = reset_pred(handles);
        handles = reset_opt(handles);
        handles = reset_labels(handles);
    end
    handles = enable_disable(handles);
    update_listbox_data(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_class_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.class == 1
    q = questdlg('Class is alreday loaded. Do you wish to overwrite it?','loading class','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes') 
    res = visualize_load(2,size(handles.data.X,1));
    if isnan(res.loaded_file)
        if handles.present.class  == 0
            handles.present.class  = 0;
        else
            handles.present.class  = 1;
        end
    elseif res.from_file == 1
        handles.present.class  = 1;
        tmp_data = load(res.path);
        handles.data.class = getfield(tmp_data,res.name);
        if size(handles.data.class,2) > size(handles.data.class,1)
            handles.data.class = handles.data.class';
        end
        handles.data.name_class = res.name;
        handles = reset_pred(handles);
    else
        handles.present.class  = 1;
        handles.data.class = evalin('base',res.name);
        if size(handles.data.class,2) > size(handles.data.class,1)
            handles.data.class = handles.data.class';
        end
        handles.data.name_class = res.name;
        handles = reset_pred(handles);
    end
    handles = enable_disable(handles);
    update_listbox_data(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_model_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.model > 0
    q = questdlg('Model is alreday loaded/calculated. Do you wish to overwrite it?','loading model','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes') 
    res = visualize_load(3,0);
    if isnan(res.loaded_file)
        if handles.present.model  == 0
            handles.present.model  = 0;
        else
            handles.present.model  = 1;
        end
    elseif res.from_file == 1
        handles.present.model  = 1;
        tmp_data = load(res.path);
        handles.data.model = getfield(tmp_data,res.name);
        handles.data.name_model = res.name;
        handles = reset_pred(handles);
    else
        handles.present.model  = 1;
        handles.data.model = evalin('base',res.name);
        handles.data.name_model = res.name;
        handles = reset_pred(handles);
    end
    handles = enable_disable(handles);
    update_listbox_model(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_optimisation_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.opt > 0
    q = questdlg('Optimisation results are alreday loaded/calculated. Do you wish to overwrite them?','loading model','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes') 
    res = visualize_load(7,0);
    if isnan(res.loaded_file)
        if handles.present.opt  == 0
            handles.present.opt  = 0;
        else
            handles.present.opt  = 1;
        end
    elseif res.from_file == 1
        handles.present.opt  = 1;
        tmp_data = load(res.path);
        handles.data.opt_res = getfield(tmp_data,res.name);
    else
        handles.present.opt  = 1;
        handles.data.opt_res = evalin('base',res.name);
    end
    handles = enable_disable(handles);
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_labels_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_file_load_sample_labels_Callback(hObject, eventdata, handles)
res = visualize_load(5,size(handles.data.X,1));
if isnan(res.loaded_file)
    if handles.present.sample_labels == 0
        handles.present.sample_labels  = 0;
    else
        handles.present.sample_labels  = 1;
    end
elseif res.from_file == 1
    handles.present.sample_labels  = 1;
    tmp_data = load(res.path);
    handles.data.sample_labels = getfield(tmp_data,res.name);
    if size(handles.data.sample_labels,2) > size(handles.data.sample_labels,1)
        handles.data.sample_labels = handles.data.sample_labels';
    end
else
    handles.present.sample_labels  = 1;
    handles.data.sample_labels = evalin('base',res.name);
    if size(handles.data.sample_labels,2) > size(handles.data.sample_labels,1)
        handles.data.sample_labels = handles.data.sample_labels';
    end
end
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_load_variable_labels_Callback(hObject, eventdata, handles)
res = visualize_load(6,size(handles.data.X,2));
if isnan(res.loaded_file)
    if handles.present.variable_labels == 0
        handles.present.variable_labels  = 0;
    else
        handles.present.variable_labels  = 1;
    end
elseif res.from_file == 1
    handles.present.variable_labels  = 1;
    tmp_data = load(res.path);
    handles.data.variable_labels = getfield(tmp_data,res.name);
    if size(handles.data.variable_labels,2) > size(handles.data.variable_labels,1)
        handles.data.variable_labels = handles.data.variable_labels';
    end
else
    handles.present.variable_labels  = 1;
    handles.data.variable_labels = evalin('base',res.name);
    if size(handles.data.variable_labels,2) > size(handles.data.variable_labels,1)
        handles.data.variable_labels = handles.data.variable_labels';
    end
end
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_save_model_Callback(hObject, eventdata, handles)
visualize_export(handles.data.model,'model')

% --------------------------------------------------------------------
function m_file_save_cross_validation_Callback(hObject, eventdata, handles)
visualize_export(handles.data.cv,'cv')

% --------------------------------------------------------------------
function m_file_save_optimisation_Callback(hObject, eventdata, handles)
visualize_export(handles.data.opt_res,'opt')

% --------------------------------------------------------------------
function m_file_save_prediction_Callback(hObject, eventdata, handles)
visualize_export(handles.data.pred,'pred')

% --------------------------------------------------------------------
function m_file_clear_data_Callback(hObject, eventdata, handles)
handles = reset_data(handles);
handles = reset_class(handles);
handles = reset_opt(handles);
handles = reset_pred(handles);
handles = reset_labels(handles);
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_clear_model_Callback(hObject, eventdata, handles)
handles = reset_model(handles);
handles = reset_cv(handles);
handles = reset_pred(handles);
handles = enable_disable(handles);
update_listbox_model(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_clear_labels_Callback(hObject, eventdata, handles)
handles = reset_labels(handles);
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_exit_Callback(hObject, eventdata, handles)
close

% --------------------------------------------------------------------
function m_view_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_view_data_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.data.X);
openvar('tmp_view');

% --------------------------------------------------------------------
function m_view_class_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.data.class);
openvar('tmp_view');

% --------------------------------------------------------------------
function m_view_plot_samples_Callback(hObject, eventdata, handles)
plot_samples(handles)

% --------------------------------------------------------------------
function m_view_plot_mean_Callback(hObject, eventdata, handles)
plot_mean(handles)

% --------------------------------------------------------------------
function m_view_plot_univariate_Callback(hObject, eventdata, handles)
if handles.present.variable_labels == 1
    varlab_here = handles.data.variable_labels;
else
    varlab_here = {};
end
if handles.present.sample_labels == 1
    samplelab_here = handles.data.sample_labels;
else
    samplelab_here = {};
end
visualize_variable(handles.data.X,handles.data.class,varlab_here,samplelab_here)

% --------------------------------------------------------------------
function m_calculate_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_calculate_model_Callback(hObject, eventdata, handles)
handles = do_model(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_opt_model_Callback(hObject, eventdata, handles)
handles = optimise_model(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_results_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_results_classification_Callback(hObject, eventdata, handles)
open_view_results(handles)

% --------------------------------------------------------------------
function m_results_top_map_Callback(hObject, eventdata, handles)
open_top_map(handles)

% --------------------------------------------------------------------
function m_results_optimisation_Callback(hObject, eventdata, handles)
visualize_opt_results(handles.data.opt_res);

% --------------------------------------------------------------------
function m_predict_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_predict_samples_Callback(hObject, eventdata, handles)
handles = predict_samples(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_help_html_Callback(hObject, eventdata, handles)
h1 = ['A complete HTML guide on how to calculate' sprintf('\n') 'Kohonen and CPANN networks is provided.'];
hr = sprintf('\n');
h3 = ['Look for the help.htm file in the toolbox folder' sprintf('\n') 'and open it in your favourite browser!'];
web('help.htm')
helpdlg([h1 hr h3],'HTML help')

% --------------------------------------------------------------------
function m_help_cite_Callback(hObject, eventdata, handles)
h1 = ['The toolbox is freeware and may be used (but not modified) if proper reference is given to the authors. Preferably refer to the following papers:'];
hr = sprintf('\n');
h3 = ['Ballabio D, Consonni V, Todeschini R. (2009) The Kohonen and CP-ANN toolbox: a collection of MATLAB modules for Self Organizing Maps and Counterpropagation Artificial Neural Networks. Chemometrics and Intelligent Laboratory Systems, 98, 115-122'];
h4 = ['Ballabio D, Vasighi M. (2012) A MATLAB Toolbox for Self Organizing Maps and supervised neural network learning strategies. Chemometrics and Intelligent Laboratory Systems, 118, 24-32'];
helpdlg([h1 hr hr h3 hr hr h4],'HTML help')

% --------------------------------------------------------------------
function m_about_Callback(hObject, eventdata, handles)
h1 = 'Kohonen and CP-ANN toolbox for MATLAB version 3.8';
hr = sprintf('\n');
h2 = 'Milano Chemometrics and QSAR Research Group ';
h3 = 'University of Milano-Bicocca, Italy';
h4 = 'http://michem.disat.unimib.it/chm';
helpdlg([h1 hr h2 hr h3 hr h4],'HTML help')

% --- Executes during object creation, after setting all properties.
function listbox_data_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox_data.
function listbox_data_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox_model_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox_model.
function listbox_model_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_calculate.
function button_calculate_Callback(hObject, eventdata, handles)
handles = do_model(handles);
guidata(hObject,handles)

% --- Executes on button press in button_view_results.
function button_view_results_Callback(hObject, eventdata, handles)
open_view_results(handles)

% --- Executes on button press in button_view_top_map.
function button_view_top_map_Callback(hObject, eventdata, handles)
open_top_map(handles)

% --- Executes on button press in button_predict_samples.
function button_predict_samples_Callback(hObject, eventdata, handles)
handles = predict_samples(handles);
guidata(hObject,handles)

% ------------------------------------------------------------------------
function handles = optimise_model(handles);

model = NaN;
cv = NaN;
% open do settings
[settings,cv_settings,ns_bank,ep_bank,rep_model,opt_fun,domodel] = visualize_opt(handles.data.X,handles.present.model,handles.data.model);

if domodel
    % check constant variables
    [errortype,iscost] = check_constant(handles);
    if iscost
        warndlg(errortype,'warning') 
    end
    % check for errors in contiguos blocks or venetian blinds
    err_cv = check_cv_err(handles.data.class,cv_settings.type,cv_settings.groups);
    if err_cv == 1
        meth{1} = 'venetian blinds';
        meth{2} = 'contiguous blocks';
        str = ['cross validation failed: samples are not correctly distributed with '...
                meth{cv_settings.type} '; try to use other cross validation procedures or'...
                ' a different number of cross-validation groups.'];
        warndlg(str,'cross validation')
    else
        % dialog form time warning
        hr = sprintf('\n');
        str = ['Optimisation will be run on the MATLAB command window. ' hr ...
               'Pay attention, it could require time, especially for large data sets. ' hr ...
               'In order to save time, you can directly run the optimisation on the command window: type "help opt_model" to find out how. ' hr hr ...
               'Proceed with the optimisation now?'];
        q = questdlg(str,'run optimisation','yes','no','yes');
        if strcmp(q,'yes')
            % activate pointer
            set(handles.model_gui,'Pointer','watch')
            % run optimisation
            opt_res = opt_model(handles.data.X,handles.data.class,settings,cv_settings.type,cv_settings.groups,opt_fun,ns_bank,ep_bank,rep_model);
            % open optimisation results
            visualize_opt_results(opt_res);
            if isstruct(opt_res)
                handles.data.opt_res = opt_res;
                handles.present.opt = 1;
            end
            % disable pointer, update model listbox
            set(handles.model_gui,'Pointer','arrow')
            handles = enable_disable(handles);
        end        
    end
else
    set(handles.model_gui,'Pointer','arrow')
end

% ------------------------------------------------------------------------
function handles = do_model(handles)

model = NaN;
cv = NaN;
% open do settings
[settings,cv_settings,domodel] = visualize_settings(handles.data.X,handles.present.class,handles.present.model,handles.data.model,handles.present.cv,handles.data.cv);

if domodel
    % activate pointer
    set(handles.model_gui,'Pointer','watch')
    % check constant variables
    [errortype,iscost] = check_constant(handles);
    if iscost
        warndlg(errortype,'warning') 
    end
    % run model and cv
    if strcmp(settings.net_type,'cpann')
        model = model_cpann(handles.data.X,handles.data.class,settings);
        if ~strcmp(cv_settings.type,'none')
            % check for errors in contiguos blocks or venetian blinds
            err_cv = check_cv_err(handles.data.class,cv_settings.type,cv_settings.groups);
            if err_cv == 1
                meth{1} = 'venetian blinds';
                meth{2} = 'contiguous blocks';
                str = ['cross validation failed: samples are not correctly distributed with '...
                      meth{cv_settings.type} '; try to use other cross validation procedures or'...
                      ' a different number of cross-validation groups.'];
                warndlg(str,'cross validation')
            else
                cv = cv_cpann(handles.data.X,handles.data.class,settings,cv_settings.type,cv_settings.groups);
            end
        end
    elseif strcmp(settings.net_type,'xyf')
        model = model_xyf(handles.data.X,handles.data.class,settings);
        if ~strcmp(cv_settings.type,'none')
            % check for errors in contiguos blocks or venetian blinds
            err_cv = check_cv_err(handles.data.class,cv_settings.type,cv_settings.groups);
            if err_cv == 1
                meth{1} = 'venetian blinds';
                meth{2} = 'contiguous blocks';
                str = ['cross validation failed: samples are not correctly distributed with '...
                      meth{cv_settings.type} '; try to use other cross validation procedures or'...
                      ' a different number of cross-validation groups.'];
                warndlg(str,'cross validation')
            else
                cv = cv_xyf(handles.data.X,handles.data.class,settings,cv_settings.type,cv_settings.groups);
            end
        end
    elseif strcmp(settings.net_type,'skn')
        model = model_skn(handles.data.X,handles.data.class,settings);
        if ~strcmp(cv_settings.type,'none')
            % check for errors in contiguos blocks or venetian blinds
            err_cv = check_cv_err(handles.data.class,cv_settings.type,cv_settings.groups);
            if err_cv == 1
                meth{1} = 'venetian blinds';
                meth{2} = 'contiguous blocks';
                str = ['cross validation failed: samples are not correctly distributed with '...
                      meth{cv_settings.type} '; try to use other cross validation procedures or'...
                      ' a different number of cross-validation groups.'];
                warndlg(str,'cross validation')
            else
                cv = cv_skn(handles.data.X,handles.data.class,settings,cv_settings.type,cv_settings.groups);
            end
        end
    else
        model = model_kohonen(handles.data.X,settings);
    end
    % check if model and cv are calculated
    if isstruct(model)
        handles.data.model = model;
        if handles.present.sample_labels == 1
            handles.data.model.labels.sample_labels = handles.data.sample_labels;
        else
            handles.data.model.labels.sample_labels = {};
        end
        if handles.present.variable_labels == 1
            handles.data.model.labels.variable_labels = handles.data.variable_labels;
        else
            handles.data.model.labels.variable_labels = {};
        end
        handles.present.cv = 0;
        handles.data.cv = [];
        handles.present.model = 2;
        handles.data.name_model = 'calculated';
        handles = reset_pred(handles);
    end
    if isstruct(cv)
        handles.data.cv = cv;
        handles.present.cv = 1;
    end
    % disable pointer, update model listbox
    set(handles.model_gui,'Pointer','arrow')
    update_listbox_model(handles)
    handles = enable_disable(handles);
else
    set(handles.model_gui,'Pointer','arrow')
end

% ------------------------------------------------------------------------
function update_listbox_data(handles)
if handles.present.data == 0
    set(handles.listbox_data,'String','data not loaded');
else
    str{1} = ['data: loaded'];
    str{2} = ['name: ' handles.data.name_data];
    str{3} = ['samples: ' num2str(size(handles.data.X,1))];
    str{4} = ['variables: ' num2str(size(handles.data.X,2))];
    if handles.present.sample_labels
        str{5} = ['sample labels: loaded'];
    else
        str{5} = ['sample labels: not loaded'];
    end
    if handles.present.variable_labels
        str{6} = ['variable labels: loaded'];
    else
        str{6} = ['variable labels: not loaded'];
    end  
    if handles.present.class == 1
        str{7} = ['class: loaded'];
        str{8} = ['name: ' handles.data.name_class];
        str{9} = ['number of classes: ' num2str(max(handles.data.class))];
    end
    set(handles.listbox_data,'String',str);
end

% ------------------------------------------------------------------------
function update_listbox_model(handles)
if handles.present.model == 0
    set(handles.listbox_model,'String','model not loaded/calculated');
else
    w = handles.data.model.net.settings.nsize;
    e = handles.data.model.net.settings.epochs;
    l = size(handles.data.model.net.W,3);
    t = handles.data.model.net.settings.topol;
    tr = handles.data.model.net.settings.training;
    if handles.present.model == 1
        str{1} = ['model: loaded'];
    elseif handles.present.model == 2
        str{1} = ['model: calculated'];
    end    
    if strcmp(handles.data.model.type,'cpann')
        str{2} = ['model type: cpann'];
    elseif strcmp(handles.data.model.type,'xyf')
        str{2} = ['model type: xyf'];
    elseif strcmp(handles.data.model.type,'skn')
        str{2} = ['model type: skn'];
    else
        str{2} = ['model type: kohonen map'];
    end
    str{3} = ['layers (variables): ' num2str(l)];
    str{4} = ['neurons: ' num2str(w) 'x' num2str(w)];
    str{5} = ['epochs: ' num2str(e)];
    str{6} = ['topology: ' t];
    str{7} = ['training: ' tr];
    if ~strcmp(handles.data.model.type,'kohonen_map')
        nformat2 = '%1.2f';
        er  = sprintf(nformat2,handles.data.model.res.class_param.er);
        ner = sprintf(nformat2,handles.data.model.res.class_param.ner);    
        str{8} = ['error rate: ' er];
        str{9} = ['non-error rate: ' ner];
    end
    set(handles.listbox_model,'String',str);
end

% ------------------------------------------------------------------------
function open_top_map(handles)
if handles.present.pred == 1
    pred_res.pred = handles.data.pred;
    if handles.present.class == 1
        pred_res.class = handles.data.class;
    else
        pred_res.class = [];
    end
    if handles.present.sample_labels == 1
        pred_res.sample_labels = handles.data.sample_labels;
    else
        pred_res.sample_labels = {};
    end
    visualize_model(handles.data.model,handles.data.model.labels.sample_labels,handles.data.model.labels.variable_labels,pred_res)
else
    visualize_model(handles.data.model,handles.data.model.labels.sample_labels,handles.data.model.labels.variable_labels)
end

% ------------------------------------------------------------------------
function open_view_results(handles)
visualize_view_results(handles.data)

% ------------------------------------------------------------------------
function handles = predict_samples(handles)
% check data and model size
if size(handles.data.model.net.W,3) == size(handles.data.X,2)
    errortype = 'none';
else
    errortype = ['mismatch in the number of variables: data have ' num2str(size(handles.data.X,2)) ...
                 ' variables, but model was calculated with ' num2str(size(handles.data.model.net.W,3)) ' variables'];
end
if strcmp(errortype,'none')
    % predict samples
    if ~strcmp(handles.data.model.type,'kohonen_map')
        pred = pred_cpann(handles.data.X,handles.data.model);
    else
        pred = pred_kohonen(handles.data.X,handles.data.model);
    end
    if isstruct(pred)
        handles.data.pred = pred;
        handles.present.pred = 1;
        if handles.present.class == 1
            class = handles.data.class;
        else
            class = [];
        end
        if handles.present.sample_labels == 1
            sample_labels = handles.data.sample_labels;
        else
            sample_labels = {};
        end
        visualize_predict_samples(handles.data.pred,class,sample_labels,handles.data.model)
    end
else
    errordlg(errortype,'error comparing data and model sizes') 
end
handles = enable_disable(handles);

% ------------------------------------------------------------------------
function handles = init_handles(handles)
handles.present.data  = 0;
handles.present.class = 0;
handles.present.model = 0;  % = 1 is loaded, = 2 is calculated
handles.present.cv    = 0;
handles.present.opt   = 0;
handles.present.pred  = 0;
handles.present.sample_labels = 0;
handles.present.variable_labels = 0;
handles.data.name_class = [];
handles.data.name_data = [];
handles.data.name_model = [];
handles.data.X = [];
handles.data.class = [];
handles.data.model = [];
handles.data.cv = [];
handles.data.opt = [];
handles.data.pred = [];

% ------------------------------------------------------------------------
function handles = reset_data(handles);
handles.present.data  = 0;
handles.data.X = [];
handles.data.name_data = [];

% ------------------------------------------------------------------------
function handles = reset_class(handles);
handles.present.class = 0;
handles.data.name_class = [];
handles.data.class = [];

% ------------------------------------------------------------------------
function handles = reset_model(handles);
handles.present.model = 0;
handles.data.name_model = [];
handles.data.model = [];

% ------------------------------------------------------------------------
function handles = reset_opt(handles);
handles.present.opt = 0;
handles.data.opt = [];

% ------------------------------------------------------------------------
function handles = reset_pred(handles);
handles.present.pred = 0;
handles.data.pred = [];

% ------------------------------------------------------------------------
function handles = reset_cv(handles);
handles.present.cv = 0;
handles.data.cv = [];

% ------------------------------------------------------------------------
function handles = reset_labels(handles);
handles.present.sample_labels = 0;
handles.present.variable_labels = 0;
handles.data.sample_labels = [];
handles.data.variable_labels = [];

% -------------------------------------------------------------------------
function plot_mean(handles)

X = handles.data.X;
class = handles.data.class;
col_ass = visualize_colors;

if length(class) == 0
    P = mean(X);
else
    for g=1:max(class)
        in = find(class == g);
        P(g,:) = mean(X(in,:));
    end
end

figure
hold on
if length(class) == 0
    plot(P,'Color','r')
    if size(P,2) < 20
        plot(P,'o','MarkerEdgeColor','k','MarkerFaceColor','r')
    end
else
    for g=1:max(class)
        color_in = col_ass(g+1,:);
        str_legend{g} = ['class ' num2str(g)];
        plot(P(g,:),'Color',color_in)
    end
    if size(P,2) < 20
        for g=1:max(class)
            color_in = col_ass(g+1,:);
            plot(P(g,:),'o','MarkerEdgeColor','k','MarkerFaceColor',color_in)
        end
    end
    legend(str_legend)
end

hold off
box on
xlabel('variables')
ylabel('data means')
range_y = max(max(P)) - min(min(P)); 
add_space_y = range_y/20;
y_lim = [min(min(P))-add_space_y max(max(P))+add_space_y];
axis([0.5 size(P,2)+0.5 y_lim(1) y_lim(2)])
if size(P,2) < 20
    set(gca,'XTick',[1:size(P,2)])
    if handles.present.variable_labels == 1
        set(gca,'XTickLabel',handles.data.variable_labels)    
    end
end

set(gcf,'color','white')
title('variable mean profile')

% -------------------------------------------------------------------------
function plot_samples(handles)

X = handles.data.X;
class = handles.data.class;
col_ass = visualize_colors;

figure
hold on
if length(class) == 0
    plot(X','Color','r')
else
    for g=1:max(class) % plot first sample of each class
        in = find(class==g); in = in(1);
        color_in = col_ass(g+1,:);
        str_legend{g} = ['class ' num2str(g)];
        plot(X(in,:)','Color',color_in)
    end
    legend(str_legend)
    for g=1:max(class) % plot other samples of each class
        in = find(class==g); in = in(2:end);
        color_in = col_ass(g+1,:);
        plot(X(in,:)','Color',color_in)
    end
end

hold off
box on
xlabel('variables')
ylabel('data')
range_y = max(max(X)) - min(min(X)); 
add_space_y = range_y/20;
y_lim = [min(min(X))-add_space_y max(max(X))+add_space_y];
axis([0.5 size(X,2)+0.5 y_lim(1) y_lim(2)])
if size(X,2) < 20
    set(gca,'XTick',[1:size(X,2)])
    if handles.present.variable_labels == 1
        set(gca,'XTickLabel',handles.data.variable_labels)    
    end
end

set(gcf,'color','white')
title('sample profiles')

% ------------------------------------------------------------------------
function err_cv = check_cv_err(class,cv_type,cv_groups);
nobj = length(class);
err_cv = 0;
obj_in_block = fix(nobj/cv_groups);
left_over = mod(nobj,cv_groups);
st = 1;
en = obj_in_block;
if cv_type < 3 % not random sets
    for i=1:cv_groups
        % prepares objects
        in = ones(nobj,1);
        if cv_type == 1 % venetian blinds
            out = [i:cv_groups:nobj];
        else % contiguous blocks
            if left_over == 0
                out = [st:en];
                st =  st + obj_in_block;  en = en + obj_in_block;
            else
                if i < cv_groups - left_over
                    out = [st:en];
                    st =  st + obj_in_block;  en = en + obj_in_block;
                elseif i < cv_groups
                    out = [st:en + 1];
                    st =  st + obj_in_block + 1;  en = en + obj_in_block + 1;
                else
                    out = [st:nobj];
                end
            end
        end
        in(out) = 0;
        class_training = class(find(in==1));
        class_test = class(find(in==0));
        % check class partition
        cin = [1:max(class)];
        for g = 1:length(cin);
            rep = length(find(class_training == g));
            if rep == 0
                err_cv = 1;
                return
            end
        end
    end
end

% ------------------------------------------------------------------------
function handles = enable_disable(handles)

if handles.present.data == 0
    set(handles.button_calculate,'Enable','off');
    set(handles.m_file_load_class,'Enable','off');    
    set(handles.m_file_clear_data,'Enable','off');
    set(handles.m_calculate_model,'Enable','off');
    set(handles.m_view_data,'Enable','off');
    set(handles.m_view_plot_samples,'Enable','off');
    set(handles.m_view_plot_mean,'Enable','off');
    set(handles.m_view_plot_univariate,'Enable','off');
    set(handles.m_file_load_sample_labels,'Enable','off');   
    set(handles.m_file_load_variable_labels,'Enable','off'); 
else
    set(handles.button_calculate,'Enable','on');
    set(handles.m_file_clear_data,'Enable','on');
    set(handles.m_calculate_model,'Enable','on');
    set(handles.m_file_load_class,'Enable','on');
    set(handles.m_view_data,'Enable','on');
    set(handles.m_view_plot_samples,'Enable','on');
    set(handles.m_view_plot_mean,'Enable','on');
    set(handles.m_view_plot_univariate,'Enable','on');
    set(handles.m_file_load_sample_labels,'Enable','on');   
    set(handles.m_file_load_variable_labels,'Enable','on');
end

if handles.present.class == 0
    set(handles.m_view_class,'Enable','off');
    set(handles.m_opt_model,'Enable','off');
else
    set(handles.m_view_class,'Enable','on');   
    set(handles.m_opt_model,'Enable','on');
end

if handles.present.model == 0
    set(handles.button_view_results,'Enable','off');
    set(handles.button_view_top_map,'Enable','off');
    set(handles.m_file_save_model,'Enable','off');
    set(handles.m_file_clear_model,'Enable','off');
    set(handles.m_results_classification,'Enable','off');
    set(handles.m_results_top_map,'Enable','off');
else
    set(handles.button_view_top_map,'Enable','on');
    set(handles.m_file_save_model,'Enable','on');
    set(handles.m_file_clear_model,'Enable','on');
    set(handles.m_results_top_map,'Enable','on');
    if ~strcmp(handles.data.model.type,'kohonen_map')
        set(handles.m_results_classification,'Enable','on');
        set(handles.button_view_results,'Enable','on');
    else
        set(handles.m_results_classification,'Enable','off');
        set(handles.button_view_results,'Enable','off');
    end
end

if handles.present.opt == 0
    set(handles.m_file_save_optimisation,'Enable','off');
    set(handles.m_results_optimisation,'Enable','off');
else
    set(handles.m_file_save_optimisation,'Enable','on');
    set(handles.m_results_optimisation,'Enable','on');
end

% predict new samples is active when
% 1. model is loaded and data are already loaded
% 2. data are loaded and model is already loaded
% is not active when
% 3. model is calculated with the loaded data
if handles.present.model == 1 & handles.present.data == 1
    set(handles.m_predict_samples,'Enable','on');
    set(handles.button_predict_samples,'Enable','on');
else
    set(handles.m_predict_samples,'Enable','off');
    set(handles.button_predict_samples,'Enable','off');
end

if handles.present.cv == 0
    set(handles.m_file_save_cross_validation,'Enable','off');
else
    set(handles.m_file_save_cross_validation,'Enable','on');
end

if handles.present.sample_labels | handles.present.variable_labels
    set(handles.m_file_clear_labels,'Enable','on');
else
    set(handles.m_file_clear_labels,'Enable','off');
end

if handles.present.pred
    set(handles.m_file_save_prediction,'Enable','on');
else
    set(handles.m_file_save_prediction,'Enable','off');
end

% ------------------------------------------------------------------
function [errortype,iscost] = check_constant(handles);
errortype = 'none';
iscost = 0;
X = handles.data.X;
s = std(X);
var_is_const = find(s < 0.000000000001);
if length(var_is_const) > 0
    str = 'Pay attention: variables';
    for k=1:length(var_is_const); str = [str ' ' num2str(var_is_const(k))]; end;
    str= [str ' are constant or nearly constant.' sprintf('\n') 'Constant variables can introduce errors when scaling data'];
    errortype = str;
    iscost = 1;
end