function varargout = visualize_pca(varargin)

% visualize_pca opens a graphical interface for analysing PCA made on weigths
% visualize_maps is called by visualize_map.
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
                   'gui_OpeningFcn', @visualize_pca_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_pca_OutputFcn, ...
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


% --- Executes just before visualize_pca is made visible.
function visualize_pca_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 9.6471 134.5714 49.8235]);
set(handles.visualize_pca,'Position',[103.8571 9.6471 134.5714 49.8235]);
set(handles.vor_lab_chk,'Position',[3 31.3122 19.6 1.3846]);
set(handles.export_text,'Position',[3.8 10.8507 8.4 1.1538]);
set(handles.neuron_text,'Position',[3 25.0045 19.8 1.1538]);
set(handles.pca_title_text,'Position',[3 47.6968 22 1.1538]);
set(handles.neuron_list,'Position',[4.4 16.6199 20.8 7.5385]);
set(handles.score_lab_chk,'Position',[3 35.2353 16.6 1.1538]);
set(handles.loading_title_text,'Position',[39.8 23.543 90.2 1.1538]);
set(handles.score_title_text,'Position',[40.2 48.0814 90.4 1.1538]);
set(handles.eigen_plot_button,'Position',[3 28.8507 23 1.7692]);
set(handles.open_loading_button,'Position',[3 5.2353 23 1.9231]);
set(handles.open_score_button,'Position',[3 8.3122 23 1.7692]);
set(handles.export_button,'Position',[3 2.3122 23 1.7692]);
set(handles.select_button,'Position',[3 13.9276 23 1.7692]);
set(handles.class_pop,'Position',[3 37.3891 23 1.6923]);
set(handles.y_pop,'Position',[14.8 41.0045 11 1.6923]);
set(handles.x_pop,'Position',[3 41.0045 11 1.6923]);
set(handles.scaling_pop,'Position',[3 44.4661 23 1.6923]);
set(handles.var_lab_chk,'Position',[3 33.2353 19.6 1.3846]);
set(handles.frame_selection,'Position',[1.4 12.8507 26 12.4615]);
set(handles.frame5,'Position',[1.4 1.3122 26.2 9.9231]);
set(handles.text1,'Position',[3 46.0814 10.8 1.2308]);
set(handles.text3,'Position',[3 42.543 10 1.2308]);
set(handles.text4,'Position',[14.8 42.543 10.2 1.2308]);
set(handles.text5,'Position',[3 38.6968 23.6 1.4615]);
set(handles.frame_pca,'Position',[1.4 27.543 26 20.4615]);
set(handles.loading_plot,'Position',[39.8 3.3891 91.2 20]);
set(handles.score_plot,'Position',[39.8 27.9276 91.2 20]);
set(handles.output,'Position',[103.8571 9.6471 134.5714 49.8235]);
movegui(handles.visualize_pca,'center');
handles.model = varargin{1};

% set position
FigPos=get(0,'DefaultFigurePosition');
OldUnits = get(hObject, 'Units');
set(hObject, 'Units', 'pixels');
OldPos = get(hObject,'Position');
FigWidth = OldPos(3);
FigHeight = OldPos(4);
ScreenUnits=get(0,'Units');
set(0,'Units','pixels');
ScreenSize=get(0,'ScreenSize');
set(0,'Units',ScreenUnits);
FigPos(1)=1/2*(ScreenSize(3)-FigWidth);
FigPos(2)=2/3*(ScreenSize(4)-FigHeight);
FigPos(3:4)=[FigWidth FigHeight];
set(hObject, 'Position', FigPos);
set(hObject, 'Units', OldUnits);

% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
str_disp{4} = 'range scaling';
set(handles.scaling_pop,'String',str_disp);
set(handles.scaling_pop,'Value',2);

% set x and y combo
str_disp = {};
max_comp = min([size(handles.model.net.W,1)^2 size(handles.model.net.W,3)]);
if max_comp > 15; max_comp = 15; end
for k = 1:max_comp
    str_disp{k} = (['PC ' num2str(k)]);
end
set(handles.x_pop,'String',str_disp);
set(handles.x_pop,'Value',1);
set(handles.y_pop,'String',str_disp);
set(handles.y_pop,'Value',2);

% set class combo
str_disp={};
if strcmp(handles.model.type,'cpann') | strcmp(handles.model.type,'xyf') | strcmp(handles.model.type,'skn')  
    str_disp{1} = 'none';
    for g = 1:max(handles.model.res.class_true)
        str_disp{g + 1} = (['weights of class ' num2str(g)]);
    end
    str_disp{g + 2} = ('assignations');
    set(handles.class_pop,'String',str_disp);
    set(handles.class_pop,'Value',1);
    set(handles.class_pop,'Enable','on');
else
    str_disp{1} = 'none';
    set(handles.class_pop,'String',str_disp);
    set(handles.class_pop,'Value',1);
    set(handles.class_pop,'Enable','off');
end

% set neuron list
set(handles.neuron_list,'Value',1);
set(handles.neuron_list,'Enable','inactive');
set(handles.neuron_list,'String','no selection');

handles = do_pca(handles);
update_plot(handles,[1 1],0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_pca_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function scaling_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in scaling_pop.
function scaling_pop_Callback(hObject, eventdata, handles)
handles = reset_form(handles);
handles = do_pca(handles);
update_plot(handles,[1 1],0)
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function x_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in x_pop.
function x_pop_Callback(hObject, eventdata, handles)
update_plot(handles,[1 1],0)

% --- Executes during object creation, after setting all properties.
function y_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in y_pop.
function y_pop_Callback(hObject, eventdata, handles)
update_plot(handles,[1 1],0)

% --- Executes during object creation, after setting all properties.
function class_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in class_pop.
function class_pop_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes on button press in select_button.
function select_button_Callback(hObject, eventdata, handles)
handles = select_neuron(handles);
guidata(hObject, handles);

% --- Executes on button press in export_button.
function export_button_Callback(hObject, eventdata, handles)
visualize_export(handles.pcamodel,'pca')

% --- Executes on button press in open_score_button.
function open_score_button_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],1)

% --- Executes on button press in open_loading_button.
function open_loading_button_Callback(hObject, eventdata, handles)
update_plot(handles,[0 1],1)

% --- Executes on button press in score_lab_chk.
function score_lab_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes on button press in var_lab_chk.
function var_lab_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[0 1],0)

% --- Executes on button press in vor_lab_chk.
function vor_lab_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes on button press in eigen_plot_button.
function eigen_plot_button_Callback(hObject, eventdata, handles)
eigenvalues_plot(handles);

% --- Executes during object creation, after setting all properties.
function neuron_list_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in neuron_list.
function neuron_list_Callback(hObject, eventdata, handles)

% ---------------------------------------------------------
function handles = do_pca(handles)

if strcmp(handles.model.type,'cpann') | strcmp(handles.model.type,'xyf') | strcmp(handles.model.type,'skn')  
    W_out = permute(handles.model.net.W_out,[2 1 3]);
    [n,s2,c] = size(W_out);
    W_out=reshape(W_out,n*s2,c);
end
W = permute(handles.model.net.W,[2 1 3]);
[n,s2,p] = size(W);
W=reshape(W,n*s2,p);
neurons=n^2;

num_comp = min([neurons p]);
if num_comp > 15; num_comp = 15; end;

% scaling
scaling_index = get(handles.scaling_pop,'Value');
m = mean(W);
s = std(W);
mw = min(W);
Mw = max(W);
if scaling_index == 1 % no scaling
    W_in = W;
elseif scaling_index == 2 % centering, default
    for i=1:neurons; for j=1:p; W_in(i,j) = W(i,j)-m(j); end; end;
elseif scaling_index == 3 % autoscaling
    for i=1:neurons; for j=1:p; W_in(i,j) = (W(i,j)-m(j))/s(j); end; end;
elseif scaling_index == 4 % range scaling
    for i=1:neurons; for j=1:p; W_in(i,j) = (W(i,j)-mw(j))/(Mw(j) - mw(j)); end; end;    
end

% diagonalisation
[T,E,L] = svd(W_in,0);
eigmat = E;
E = diag(E).^2/(size(W,1)-1);
exp_var = E/sum(E);
E = E(1:num_comp);
exp_var = exp_var(1:num_comp);
for k=1:num_comp
    cum_var(k) = sum(exp_var(1:k)); 
end
L = L(:,1:num_comp);
T = W_in*L;
T = T(:,1:num_comp);

% save results
pcamodel.W = W;
if strcmp(handles.model.type,'cpann') | strcmp(handles.model.type,'xyf') | strcmp(handles.model.type,'skn')  
    pcamodel.W_out = W_out;
end
pcamodel.exp_var = exp_var;
pcamodel.cum_var = cum_var;
pcamodel.E = E;
pcamodel.L = L;
pcamodel.T = T;
if scaling_index == 1
    scal_type = 'none';
elseif scaling_index == 2
    scal_type = 'center';
elseif scaling_index == 3
    scal_type = 'autoscaling';
elseif scaling_index == 4
    scal_type = 'range';
end
pcamodel.scal = scal_type;
handles.pcamodel = pcamodel;

% ---------------------------------------------------------
function update_plot(handles,update_this,external)

x = get(handles.x_pop, 'Value');
y = get(handles.y_pop, 'Value');
class_in = get(handles.class_pop, 'Value') - 1;
label_scores = get(handles.score_lab_chk, 'Value');
label_loadings = get(handles.var_lab_chk, 'Value');
do_voronoi = get(handles.vor_lab_chk, 'Value');

% settings
if strcmp(handles.model.type,'cpann') | strcmp(handles.model.type,'xyf') | strcmp(handles.model.type,'skn')  
    W_out = handles.pcamodel.W_out;
end
T = handles.pcamodel.T;
L = handles.pcamodel.L;
exp_var = handles.pcamodel.exp_var;
lab_x = (['PC ' num2str(x) ' - EV = ' num2str(round(exp_var(x)*10000)/100) '%']);
lab_y = (['PC ' num2str(y) ' - EV = ' num2str(round(exp_var(y)*10000)/100) '%']);
col_ass = visualize_colors;
        
% display scores
if update_this(1)
    if external; figure; title('score plot'); set(gcf,'color','white'); box on; else; axes(handles.score_plot); end
    cla;
    hold on
    if do_voronoi
        [v_vor,c_vor] = voronoin([T(:,x) T(:,y)]);
    end
    if class_in == 0
        if do_voronoi
            for i = 1:length(c_vor); if all(c_vor{i}~=1); patch(v_vor(c_vor{i},1),v_vor(c_vor{i},2),'w'); end; end
        end
        plot(T(:,x),T(:,y),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','w')
    elseif class_in <= max(handles.model.res.class_true);
        if do_voronoi
            for i = 1:length(c_vor); if all(c_vor{i}~=1); c = W_out(i,class_in); patch(v_vor(c_vor{i},1),v_vor(c_vor{i},2),[1-c 1-c 1-c]); end; end
        end
        for i=1:size(T,1)
            c = W_out(i,class_in);
            if do_voronoi; mec = [c c c]; else mec = 'k'; end
            plot(T(i,x),T(i,y),'o','MarkerEdgeColor',mec,'MarkerSize',5,'MarkerFaceColor',[1-c 1-c 1-c])
        end
    else
        neuron_ass = permute(handles.model.net.neuron_ass,[2 1]);
        [n,s2] = size(neuron_ass);
        neuron_ass = reshape(neuron_ass,n*s2,1);
        if do_voronoi
            for i = 1:length(c_vor); if all(c_vor{i}~=1); c = col_ass(neuron_ass(i)+1,:); patch(v_vor(c_vor{i},1),v_vor(c_vor{i},2),c); end; end
        end
        for i=1:size(T,1)
            c = col_ass(neuron_ass(i)+1,:);
            plot(T(i,x),T(i,y),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',c)
        end
    end
    if label_scores; range_span = (max(T(:,x)) - min(T(:,x))); plot_label(T,x,y,'k',[1:size(T,1)],range_span); end
    xlabel(lab_x)
    ylabel(lab_y)
    range_x = max(T(:,x)) - min(T(:,x)); add_space_x = range_x/20;
    range_y = max(T(:,y)) - min(T(:,y)); add_space_y = range_y/20;
    x_lim = [min(T(:,x))-add_space_x max(T(:,x))+add_space_x];
    y_lim = [min(T(:,y))-add_space_y max(T(:,y))+add_space_y];
    if y_lim(1) < 0 & y_lim(2) > 0; line(x_lim,[0 0],'Color','k','LineStyle',':'); end
    if x_lim(1) < 0 & x_lim(2) > 0; line([0 0],y_lim,'Color','k','LineStyle',':'); end
    axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
    hold off
end

% display loadings
if update_this(2)
    if external; figure; title('loading plot'); set(gcf,'color','white'); box on; else; axes(handles.loading_plot); end
    cla;
    hold on
    plot(L(:,x),L(:,y),'o','MarkerEdgeColor','r','MarkerSize',2,'MarkerFaceColor','r')
    if label_loadings
        range_span = (max(L(:,x)) - min(L(:,x)));
        if isfield(handles.model,'labels')
            if length(handles.model.labels.variable_labels) == 0
                plot_label(L,x,y,'k',[1:size(L,1)],range_span); 
            else
                plot_string_label(L,x,y,'k',handles.model.labels.variable_labels,range_span); 
            end
        else
            plot_label(L,x,y,'k',[1:size(L,1)],range_span); 
        end    
    end
    xlabel(lab_x)
    ylabel(lab_y)
    ML = max(max(abs(L(:,[x y]))));
    range_x = ML*2; add_space_x = range_x/10;
    range_y = ML*2; add_space_y = range_y/10;
    x_lim = [-ML-add_space_x ML+add_space_x];
    y_lim = [-ML-add_space_y ML+add_space_y];
    line(x_lim,[0 0],'Color','k','LineStyle',':')
    line([0 0],y_lim,'Color','k','LineStyle',':')
    axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
    hold off
end

% ---------------------------------------------------------
function handles = reset_form(handles)

set(handles.x_pop,'Value',1);
set(handles.y_pop,'Value',2);
% set(handles.class_pop,'Value',1);
% set(handles.score_lab_chk,'Value',0);
% set(handles.var_lab_chk,'Value',0);
% set(handles.vor_lab_chk,'Value',0);
set(handles.neuron_list,'Value',1);
set(handles.neuron_list,'String','no selection');

% ---------------------------------------------------------
function eigenvalues_plot(handles)

E = handles.pcamodel.E;
exp_var = handles.pcamodel.exp_var;
cum_var = handles.pcamodel.cum_var;
num_comp = length(E);
marker_size = 15;

figure
subplot(3,1,1)
hold on
plot(E,'k')
plot(E,'.k','MarkerSize',marker_size)
ylim = get(gca, 'YLim');
axis([0.6 (num_comp + 0.4) ylim(1) ylim(2)])
set(gca,'xtick',[1:num_comp]);
hold off
ylabel('eigenvalues')
set(gca,'YGrid','on','GridLineStyle',':')
box on
title('profiles of eigenvalues and explained variance')

subplot(3,1,2)
hold on
plot(exp_var*100,'k')
plot(exp_var*100,'.k','MarkerSize',marker_size)
ylim = get(gca, 'YLim');
axis([0.6 (num_comp + 0.4) 0 100])
set(gca,'xtick',[1:num_comp]);
hold off
ylabel('exp var (%)')
box on
set(gca,'YGrid','on','GridLineStyle',':')

subplot(3,1,3)
hold on
plot(cum_var*100,'k')
plot(cum_var*100,'.k','MarkerSize',marker_size)
ylim = get(gca, 'YLim');
axis([0.6 (num_comp + 0.4) ylim(1) 100])
set(gca,'xtick',[1:num_comp]);
hold off
ylabel('cum exp var (%)')
xlabel('principal components')
set(gca,'YGrid','on','GridLineStyle',':')
box on
set(gcf,'color','white')

% ---------------------------------------------------------
function handles = select_neuron(handles)

label_scores = get(handles.score_lab_chk, 'Value');
T = handles.pcamodel.T;
x = get(handles.x_pop, 'Value');
y = get(handles.y_pop, 'Value');
Xd = T(:,[x y]);
[x_sel,y_sel] = ginput(1);
xd = [x_sel y_sel];
D_squares_x = (sum(xd'.^2))'*ones(1,size(Xd,1));
D_squares_w = sum(Xd'.^2);
D_product   = - 2*(xd*Xd');
D = (D_squares_x + D_squares_w + D_product).^0.5;
[d_min,closest] = min(D);

update_plot(handles,[1 0],0)
axes(handles.score_plot);
hold on
plot(T(closest,x),T(closest,y),'o','MarkerEdgeColor','r','MarkerSize',8)
plot(T(closest,x),T(closest,y),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','r')
if label_scores; range_span = (max(T(:,x)) - min(T(:,x))); plot_label(T(closest,:),x,y,'r',closest,range_span); end
hold off

[cord_row,cord_col] = som_which_neuron(closest,size(T,1));
in = find(handles.model.res.top_map(:,1) == cord_row & handles.model.res.top_map(:,2) == cord_col);
if length(in) > 0
    for k=1:length(in) 
        if length(handles.model.labels.sample_labels) == 0
            cur_labs{k} = num2str(in(k)); 
        else
            cur_labs{k} = [num2str(in(k)) ' - ' handles.model.labels.sample_labels{in(k)}];
        end
    end
else
    cur_labs{1} = 'none';
end

%set(handles.neuron_text,'String',[' Samples in neuron ' num2str(closest) ':']);
set(handles.neuron_list,'Value',1);
set(handles.neuron_list,'String',cur_labs);

% ---------------------------------------------------------
function plot_label(X,x,y,col,lab,range_span)

add_span = range_span/100;
for j=1:size(X,1); text(X(j,x)+add_span,X(j,y),num2str(lab(j)),'Color',col); end;

% ---------------------------------------------------------
function plot_string_label(X,x,y,col,lab,range_span)

add_span = range_span/100;
for j=1:size(X,1); text(X(j,x)+add_span,X(j,y),lab{j},'Color',col); end;

