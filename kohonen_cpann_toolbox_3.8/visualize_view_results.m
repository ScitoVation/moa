function varargout = visualize_view_results(varargin)

% visualize_view_results opens a graphical interface for visualizing
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
                   'gui_OpeningFcn', @visualize_view_results_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_view_results_OutputFcn, ...
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


% --- Executes just before visualize_view_results is made visible.
function visualize_view_results_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 29.1765 74 30.2941]);
set(handles.view_results,'Position',[103.8571 29.1765 74 30.2941]);
set(handles.button_roc_curves,'Position',[42.2 24.6154 26.6 1.7692]);
set(handles.cv_button_view_cm,'Position',[42.2 7 26.4 1.7692]);
set(handles.cv_button_class_weights,'Position',[42 3 26.4 1.7692]);
set(handles.cv_button_class_calc,'Position',[41.8 5 26.6 1.7692]);
set(handles.cv_listbox_param,'Position',[3.8 2.8462 35.4 6]);
set(handles.cv_text_error,'Position',[4 9.2308 33 4.6154]);
set(handles.text3,'Position',[4 14.2308 17.6 1.1538]);
set(handles.frame2,'Position',[1.2 1.6154 70.4 13.0769]);
set(handles.button_view_cm,'Position',[42.2 22.5385 26.4 1.7692]);
set(handles.button_class_profile,'Position',[42.2 26.6923 26.6 1.7692]);
set(handles.button_class_weights,'Position',[42.2 18.3846 26.4 1.7692]);
set(handles.button_class_calc,'Position',[42 20.4615 26.6 1.7692]);
set(handles.fit_listbox_param,'Position',[4 17.4615 35.4 6]);
set(handles.fit_text_error,'Position',[4.6 23.6923 31.8 4.6154]);
set(handles.text1,'Position',[4 28.4615 7 1.3077]);
set(handles.frame1,'Position',[1.2 16.2308 70.6 12.7692]);
set(handles.output,'Position',[103.8571 29.1765 74 30.2941]);
movegui(handles.view_results,'center');
in = varargin{1};
handles.model = in.model;
handles.cv = in.cv;
handles = update_fitting(handles);

% enable/disable
handles = enable_disable(handles);
handles = update_cv(handles);

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_view_results_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function fit_listbox_param_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in fit_listbox_param.
function fit_listbox_param_Callback(hObject, eventdata, handles)

% --- Executes on button press in button_class_calc.
function button_class_calc_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.model.res.class_calc);
openvar('tmp_view');

% --- Executes on button press in button_class_weights.
function button_class_weights_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.model.res.class_weights);
openvar('tmp_view');

% --- Executes on button press in button_class_profile.
function button_class_profile_Callback(hObject, eventdata, handles)
plot_class_profiles(handles.model)

% --- Executes on button press in button_roc_curves.
function button_roc_curves_Callback(hObject, eventdata, handles)
plot_roc_curves(handles.model)

% --- Executes on button press in button_view_cm.
function button_view_cm_Callback(hObject, eventdata, handles)
conf_mat = print_conf_mat(handles.model.res.class_param.conf_mat);
assignin('base','tmp_view',conf_mat);
openvar('tmp_view');

% --- Executes during object creation, after setting all properties.
function cv_listbox_param_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in cv_listbox_param.
function cv_listbox_param_Callback(hObject, eventdata, handles)

% --- Executes on button press in cv_button_class_calc.
function cv_button_class_calc_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.cv.class_pred);
openvar('tmp_view');

% --- Executes on button press in cv_button_class_weights.
function cv_button_class_weights_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.cv.class_weights);
openvar('tmp_view');

% --- Executes on button press in cv_button_view_cm.
function cv_button_view_cm_Callback(hObject, eventdata, handles)
conf_mat = print_conf_mat(handles.cv.class_param.conf_mat);
assignin('base','tmp_view',conf_mat);
openvar('tmp_view');

% -------------------------------------------------------------------------
function handles = enable_disable(handles);
if isstruct(handles.cv)
    set(handles.cv_button_view_cm,'Enable','on')
    set(handles.cv_button_class_calc,'Enable','on')
    set(handles.cv_button_class_weights,'Enable','on')
else
    set(handles.cv_button_view_cm,'Enable','off')
    set(handles.cv_button_class_calc,'Enable','off')
    set(handles.cv_button_class_weights,'Enable','off')    
end

% -------------------------------------------------------------------------
function handles = update_cv(handles)
if isstruct(handles.cv)
    nformat2 = '%1.2f';
    nformat3 = '%1.3f';
    hr  = sprintf('\n');
    hspace = '       ';
    er  = sprintf(nformat3,handles.cv.class_param.er);
    ner = sprintf(nformat3,handles.cv.class_param.ner);    
    na  = sprintf(nformat3,handles.cv.class_param.not_ass);
    ac  = sprintf(nformat3,handles.cv.class_param.accuracy);
    na_num = handles.cv.class_param.not_ass;
    sp  = handles.cv.class_param.specificity;
    sn  = handles.cv.class_param.sensitivity;
    pr  = handles.cv.class_param.precision;
    num_class = max(handles.model.res.class_true);

    % error rates
    str_er{1} = ['error rate: ' er];
    str_er{2} = ['non-error rate: ' ner];
    str_er{3} = ['accuracy: ' ac];
    if na_num > 0
        str_er{4} = ['not-assigned: ' na];
    end
    set(handles.cv_text_error,'String',str_er);
        
    % Specificity & Co.
    str_sp{1} = ['class' '   ' 'Spec' '      ' 'Sens' '      ' 'Prec'];
    for k=1:num_class
        str_sp{k + 1} = ['  ' num2str(k)];
        sp_in = sprintf(nformat2,sp(k));
        sn_in = sprintf(nformat2,sn(k));
        pr_in = sprintf(nformat2,pr(k));
        str_sp{k + 1} = [str_sp{k + 1} hspace sp_in hspace sn_in hspace pr_in];
    end

    set(handles.cv_listbox_param,'String',str_sp);
else
    str_er = 'not calculated';
    str_sp = '';
    set(handles.cv_text_error,'String',str_er);
    set(handles.cv_listbox_param,'String',str_sp);
end
% -------------------------------------------------------------------------
function handles = update_fitting(handles)

nformat2 = '%1.2f';
nformat3 = '%1.3f';
hr  = sprintf('\n');
hspace = '       ';
er  = sprintf(nformat3,handles.model.res.class_param.er);
ner = sprintf(nformat3,handles.model.res.class_param.ner);    
na  = sprintf(nformat3,handles.model.res.class_param.not_ass);
ac  = sprintf(nformat3,handles.model.res.class_param.accuracy);
na_num = handles.model.res.class_param.not_ass;
sp  = handles.model.res.class_param.specificity;
sn  = handles.model.res.class_param.sensitivity;
pr  = handles.model.res.class_param.precision;
num_class = max(handles.model.res.class_true);

% error rates
str_er{1} = ['error rate: ' er];
str_er{2} = ['non-error rate: ' ner];
str_er{3} = ['accuracy: ' ac];
if na_num > 0
    str_er{4} = ['not-assigned: ' na];
end
set(handles.fit_text_error,'String',str_er);

% Specificity & Co.
str_sp{1} = ['class' '   ' 'Spec' '      ' 'Sens' '      ' 'Prec'];
for k=1:num_class
    str_sp{k + 1} = ['  ' num2str(k)];
    sp_in = sprintf(nformat2,sp(k));
    sn_in = sprintf(nformat2,sn(k));
    pr_in = sprintf(nformat2,pr(k));
    str_sp{k + 1} = [str_sp{k + 1} hspace sp_in hspace sn_in hspace pr_in];
end

set(handles.fit_listbox_param,'String',str_sp);

% -------------------------------------------------------------------------
function plot_class_profiles(model)

col_ass = visualize_colors;

% calc class means
n = model.net.settings.nsize;
W = reshape(model.net.W,n*n,size(model.net.W,3));
assign = reshape(model.net.neuron_ass,n*n,1);
cnt = 0;
m = zeros(max(model.res.class_true),size(model.net.W,3));
for g=1:max(model.res.class_true)
    in = find(assign == g);
    if length(in) == 0
        m(g,:) = 0;
    elseif length(in) == 1
        m(g,:) = W(in,:);
    else
        m(g,:) = mean(W(in,:));
    end
end
figure
hold on
for g=1:max(model.res.class_true)
    color_in = col_ass(g+1,:);
    str_legend{g} = ['class ' num2str(g)];
    plot(m(g,:),'Color',color_in)
    legend(str_legend)
    box on
    % legend('boxoff')
end
if size(m,2) < 20
    for g=1:max(model.res.class_true)
        color_in = col_ass(g+1,:);
        plot(m(g,:),'o','MarkerEdgeColor','k','MarkerFaceColor',color_in)
    end
end
hold off
xlabel('variables')
ylabel('weights')
axis([0.5 size(m,2)+0.5 0 1])
if size(m,2) < 20
    set(gca,'XTick',[1:size(m,2)])
end
set(gcf,'color','white')
title('variable profiles for each class')

% -------------------------------------------------------------------------
function S = print_conf_mat(conf_mat);

S{1,1} = 'real/predicted';
for g=1:size(conf_mat,1)
    S{1,g+1} = ['class ' num2str(g)];    
end
S{1,size(conf_mat,1) + 2}=['not assigned']; 
for g=1:size(conf_mat,1)
    S{g+1,1} = ['class ' num2str(g)]; 
    for k=1:size(conf_mat,2)
        S{g+1,k+1} = num2str(conf_mat(g,k));    
    end
end

% -------------------------------------------------------------------------
function plot_roc_curves(model)

step = 0.01;
thr = [0:step:1];
for g=1:max(model.res.class_true)
    % calc values of specificity and sensitivity
    sp(g,1) = 0; sn(g,1) = 1;
    for t = 1:length(thr)
        [sp(g,t+1),sn(g,t+1)] = calc_class_rates(model,thr(t),g);
    end
    sp(g,end+1) = 1; sn(g,end+1) = 0;
end
disp_roc(sp,sn)

% ----------------------------------------------------------
function [sp,sn] = calc_class_rates(model,thr,which_class)

pos   = model.res.top_map;
W_out = model.net.W_out;
class_true = model.res.class_true;
class = ones(length(class_true),1);
class(find(class_true ~= which_class)) = 2;

for k = 1:size(W_out,1)
    for j = 1:size(W_out,2)
        w_class = W_out(k,j,which_class);
        if w_class > thr
            neuron_ass(k,j) = 1; % class for ROC
        else
            neuron_ass(k,j) = 2; % all others classes
        end    
    end
end

for i = 1:size(pos,1)
    class_calc(i) = neuron_ass(pos(i,1),pos(i,2));
end
class_calc = class_calc';

% calculates classification parameters
class_param = cpann_class_param(class_calc,class);

TP = class_param.conf_mat(1,1);
FP = class_param.conf_mat(2,1);
FN = class_param.conf_mat(1,2);
TN = class_param.conf_mat(2,2);
sp = TN/(FP + TN);
sn = TP/(FN + TP);

% ----------------------------------------------------------
function disp_roc(sp,sn)
num_class = size(sn,1);
figure
hold on
cnt = 0;
set(gcf,'color','white')
for g=1:num_class
    % roc curve
    cnt = cnt + 1;
    subplot(ceil(num_class/2),2,cnt)
    plot(1-sp(g,:),sn(g,:),'b','LineWidth',1.5)
    patch([1-sp(g,:) 1],[sn(g,:) 0],'b','FaceAlpha',0.3)
    axis([0 1 0 1])
    box on
    set(gca,'xtick',[0 0.5 1])
    set(gca,'ytick',[0 0.5 1])
    xlabel('1 - specificity')
    ylabel('sensitivity')
    title(['class ' num2str(g)])
    % axis square
end




