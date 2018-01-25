function varargout = visualize_predict_samples(varargin)

% visualize_predict_samples opens a graphical interface for visualizing
% results achieved in the model_gui procedure.
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
                   'gui_OpeningFcn', @visualize_predict_samples_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_predict_samples_OutputFcn, ...
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


% --- Executes just before visualize_predict_samples is made visible.
function visualize_predict_samples_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 44.2941 74.1429 15.1765]);
set(handles.visualize_predict_samples,'Position',[103.8571 44.2941 74.1429 15.1765]);
set(handles.button_view_cm,'Position',[42.2 6.9231 26.4 1.7692]);
set(handles.button_view_topmap,'Position',[42.2 9.2308 26.6 1.7692]);
set(handles.button_class_weights,'Position',[42.2 2.3846 26.4 1.7692]);
set(handles.button_class_calc,'Position',[42 4.6154 26.6 1.7692]);
set(handles.pred_listbox_param,'Position',[4 2.2308 35.4 6]);
set(handles.pred_text_error,'Position',[4.2 8.6154 33.4 4.6154]);
set(handles.text1,'Position',[4 13.5385 30.6 1.2308]);
set(handles.frame1,'Position',[1.2 1.3846 70.8 12.5385]);
set(handles.output,'Position',[103.8571 44.2941 74.1429 15.1765]);
movegui(handles.visualize_predict_samples,'center');
handles.pred = varargin{1};
handles.class_true = varargin{2};
handles.sample_labels = varargin{3};
handles.model = varargin{4};
% enable/disable and update
handles = enable_disable(handles);
handles = update_pred(handles);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_predict_samples_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function pred_listbox_param_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pred_listbox_param.
function pred_listbox_param_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_class_calc.
function button_class_calc_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.pred.class_pred);
openvar('tmp_view');

% --- Executes on button press in button_class_weights.
function button_class_weights_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.pred.class_weights);
openvar('tmp_view');

% --- Executes on button press in button_view_topmap.
function button_view_topmap_Callback(hObject, eventdata, handles)
open_top_map(handles)

% --- Executes on button press in button_view_cm.
function button_view_cm_Callback(hObject, eventdata, handles)
class_param = cpann_class_param(handles.pred.class_pred,handles.class_true);
conf_mat = class_param.conf_mat;
assignin('base','tmp_view',conf_mat);
openvar('tmp_view');

% -------------------------------------------------------------------------
function handles = enable_disable(handles);
if ~strcmp(handles.pred.type,'kohonen')
    if length(handles.class_true) > 0
        set(handles.button_view_cm,'enable','on');
    else
        set(handles.button_view_cm,'enable','off');
    end
    set(handles.button_class_calc,'enable','on');    
    set(handles.button_class_weights,'enable','on');  
else
    set(handles.button_view_cm,'enable','off');
    set(handles.button_class_calc,'enable','off');    
    set(handles.button_class_weights,'enable','off');  
end

% -------------------------------------------------------------------------
function open_top_map(handles);
pred_res.pred = handles.pred;
pred_res.class = handles.class_true;
pred_res.sample_labels = handles.sample_labels;
visualize_model(handles.model,handles.model.labels.sample_labels,handles.model.labels.variable_labels,pred_res)

% -------------------------------------------------------------------------
function handles = update_pred(handles)

if length(handles.class_true) > 0
    class_param = cpann_class_param(handles.pred.class_pred,handles.class_true);
    
    nformat2 = '%1.2f';
    nformat3 = '%1.3f';
    hr  = sprintf('\n');
    hspace = '       ';
    er  = sprintf(nformat3,class_param.er);
    ner = sprintf(nformat3,class_param.ner);    
    na  = sprintf(nformat3,class_param.not_ass);
    ac  = sprintf(nformat3,class_param.accuracy);
    na_num = class_param.not_ass;
    sp  = class_param.specificity;
    sn  = class_param.sensitivity;
    pr  = class_param.precision;
    num_class = max(handles.class_true);
    
    % error rates
    str_er{1} = ['error rate: ' er];
    str_er{2} = ['non-error rate: ' ner];
    str_er{3} = ['accuracy: ' ner];
    if na_num > 0
        str_er{4} = ['not-assigned: ' na];
    end
    
    % Specificity & Co.
    str_sp{1} = ['class' '   ' 'Spec' '      ' 'Sens' '      ' 'Prec'];
    for k=1:num_class
        str_sp{k + 1} = ['  ' num2str(k)];
        sp_in = sprintf(nformat2,sp(k));
        sn_in = sprintf(nformat2,sn(k));
        pr_in = sprintf(nformat2,pr(k));
        str_sp{k + 1} = [str_sp{k + 1} hspace sp_in hspace sn_in hspace pr_in];
    end
else
    str_sp = '';
    str_er = 'error rates not calculated since class for predicted samples not loaded';
end
set(handles.pred_text_error,'String',str_er);
set(handles.pred_listbox_param,'String',str_sp);
