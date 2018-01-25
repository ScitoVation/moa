function varargout = visualize_map(varargin)

% visualize_maps opens a graphical interface for visaulising kohonen top map
% visualize_maps is called by visualize_model.
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
                   'gui_OpeningFcn', @visualize_map_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_map_OutputFcn, ...
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


% --- Executes just before visualize_map is made visible.
function visualize_map_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[108.2857 6 160.2857 48.2941]);
set(handles.visualize,'Position',[108.2857 6 160.2857 48.2941]);
set(handles.pca_button,'Position',[5 31.6154 25 1.7692]);
set(handles.save_figure,'Position',[5.4 7.2308 22.2 1.7692]);
set(handles.get_weight_neuron,'Position',[5.4 13.4615 22.4 1.7692]);
set(handles.get_lab_neuron,'Position',[5.6 10.3077 22.2 1.7692]);
set(handles.text3,'Position',[4.8 16.3846 19 1.1538]);
set(handles.frame3,'Position',[3 6 28.8 10.7692]);
set(handles.text2,'Position',[5 27.3846 11.4 1.2308]);
set(handles.text1,'Position',[4.8 45.1538 9.4 1.1538]);
set(handles.pop_label,'Position',[0.033708 0.86306 0.14856 0.031847]);
set(handles.pop_layer,'Position',[0.033708 0.78185 0.14856 0.031847]);
set(handles.update_botton,'Position',[0.031211 0.71178 0.15605 0.036624]);
set(handles.button_left,'Position',[4.4 22.6923 10.2 1.7692]);
set(handles.button_right,'Position',[20.8 22.6923 10.2 1.7692]);
set(handles.button_down,'Position',[12.6 20.2308 10.2 1.7692]);
set(handles.button_up,'Position',[12.6 25 10.2 1.7692]);
set(handles.frame1,'Position',[3 19.3077 29.2 8.5385]);
set(handles.text4,'Position',[5.6 43.3846 13.2 1.1538]);
set(handles.text5,'Position',[5.6 39.4615 15.4 1.1538]);
set(handles.frame2,'Position',[2.6 30.1538 29.4 15.4615]);
set(handles.axes1,'Position',[0.22097 0.022293 0.75031 0.95701]);
set(handles.output,'Position',[108.2857 6 160.2857 48.2941]);
movegui(handles.visualize,'center');
handles.model = varargin{1};

% set temp arrays
handles.temp.top_map = handles.model.res.top_map;
handles.temp.W = handles.model.net.W;
indk = 0; 
for i=1:size(handles.model.net.W,1)
    for j=1:size(handles.model.net.W,2)
        indk = indk + 1;
        handles.temp.neuron_label(i,j)=indk;
    end
end
if ~strcmp(handles.model.type,'kohonen_map')
    handles.temp.W_out = handles.model.net.W_out;
    handles.temp.neuron_ass = handles.model.net.neuron_ass;
end

% set variable combo
num_var = size(handles.model.net.W,3);
str_layer{1} = 'none';
if length(varargin{3}) > 0
    handles.variable_label = varargin{3};
    for j=1:num_var
        str_layer{j+1}  = handles.variable_label{j};
    end
else
    handles.variable_label = {};
    for j=1:num_var
        str_layer{j+1}  = ['variable ' num2str(j)];
    end
end

if ~strcmp(handles.model.type,'kohonen_map')
    num_class = size(handles.model.net.W_out,3);
    s = length(str_layer);
    for j=1:num_class
        str_layer{j+s}  = ['weight class ' num2str(j)];
    end
    str_layer{end + 1}  = ['assignations']; 
end
set(handles.pop_layer,'String',str_layer);
set(handles.pop_layer,'Value',1);

% set label combo
str_disp{1} = 'none';
str_disp{2} = 'ID';
handles.sample_label = [];
count = 3;
if size(varargin{2},1) > 0
    str_disp{count} = 'sample labels';
    handles.sample_label = varargin{2};
    count = count + 1;
end
if ~strcmp(handles.model.type,'kohonen_map')
    str_disp{count} = 'class labels';
    handles.class = handles.model.res.class_true;
end
set(handles.pop_label,'String',str_disp);
set(handles.pop_label,'Value',2);

% set buttons for moving the map
if strcmp(handles.model.net.settings.bound,'normal') 
    set(handles.button_left,'Enable','off');
    set(handles.button_up,'Enable','off');
    set(handles.button_down,'Enable','off');
    set(handles.button_right,'Enable','off');
end

% settings for topology
if strcmp(handles.model.net.settings.topol,'square')
    handles.hexagon_center = NaN;
    handles.temp.hexagon_center = NaN;
    handles.hexagon_first_row = 'none';
else
    handles.hexagon_center = define_hexagon_centers(size(handles.model.net.W,1));
    handles.temp.hexagon_center = handles.hexagon_center;
    handles.hexagon_first_row = 'left';
end

% take predictions if present
if length(varargin{4}) > 0
    handles.pred_present = 1;
    handles.pred_res = varargin{4};
    % add predicted samples
    handles.temp.top_map = [handles.temp.top_map; handles.pred_res.pred.top_map];
else
    handles.pred_present = 0;
end

plot([0 0],'r.')
disp_grid(size(handles.model.net.W,1),handles)
handles = update_plot(handles);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_map_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in update_botton.
function update_botton_Callback(hObject, eventdata, handles)
handles = update_plot(handles);
guidata(hObject,handles)


% --- Executes on button press in pca_button.
function pca_button_Callback(hObject, eventdata, handles)
if length(handles.variable_label) > 0
    handles.model.labels.variable_labels = handles.variable_label;
end
visualize_pca(handles.model)


% --- Executes during object creation, after setting all properties.
function pop_layer_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
guidata(hObject,handles)


% --- Executes on selection change in popupmenu
function pop_layer_Callback(hObject, eventdata, handles)
handles = update_plot(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pop_label_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_label.
function pop_label_Callback(hObject, eventdata, handles)
handles = update_plot(handles);
guidata(hObject,handles);

% --- Executes on button press in button_up.
function button_up_Callback(hObject, eventdata, handles)
handles = move_map(handles,'up');
guidata(hObject,handles)


% --- Executes on button press in botton_down.
function button_down_Callback(hObject, eventdata, handles)
handles = move_map(handles,'down');
guidata(hObject,handles)


% --- Executes on button press in botton_right.
function button_right_Callback(hObject, eventdata, handles)
handles = move_map(handles,'right');
guidata(hObject,handles)


% --- Executes on button press in button_left.
function button_left_Callback(hObject, eventdata, handles)
handles = move_map(handles,'left');
guidata(hObject,handles)


% --- Executes on button press in get_lab_neuron.
function get_lab_neuron_Callback(hObject, eventdata, handles)
handles = set_list_labels(handles);
guidata(hObject,handles)


% --- Executes on button press in get_weight_neuron.
function get_weight_neuron_Callback(hObject, eventdata, handles)
handles = show_weight_neuron(handles);
guidata(hObject,handles)


% --- Executes on button press in save_figure.
function save_figure_Callback(hObject, eventdata, handles)
handles = update_plot(handles);
figure
plot([0 0],'r.')
handles = update_plot(handles);
box on
set(gcf,'color','white')
guidata(hObject,handles)


% ---------------------------------------------------------
function disp_grid(n,handles)

if strcmp(handles.model.net.settings.topol,'square')
    axis([0.5 (n + 0.4999) 0.5 (n + 0.5)])
    tick_pos = 0.5:1:(n + 0.5);
    set(gca,'YTick',tick_pos)
    set(gca,'XTick',tick_pos)
    grid on
    set(gca,'YTickLabel','')
    set(gca,'XTickLabel','')
else
    Cord = handles.temp.hexagon_center;
    for i=1:size(Cord,1)
        for j=1:size(Cord,1)
            [max_x(i,j),max_y(i,j),min_x(i,j),min_y(i,j)] = find_single_hexagon(Cord(i,j,1),Cord(i,j,2));
        end
    end
    max_x = max(max(max_x));
    max_y = max(max(max_y));
    min_x = min(min(min_x));
    min_y = min(min(min_y));
    axis([min_x max_x min_y max_y]);
    axis off
    box on
end


% ---------------------------------------------------------
function handles = update_plot(handles)
cla;
pop_layer_index = get(handles.pop_layer, 'Value');
pop_label_index = get(handles.pop_label, 'Value');

% display weights
if pop_layer_index > 1
    var_in = pop_layer_index - 1;
    disp_weights(handles,var_in);
elseif pop_layer_index == 1 & strcmp(handles.model.net.settings.topol,'hexagonal')
    disp_white_hexagon(handles);
end

% display samples
if pop_label_index > 1
    handles = disp_samples(handles,pop_label_index);
else
    handles.disp_label = [];
end

% display grid
disp_grid(size(handles.model.net.W,1),handles)

% ---------------------------------------------------------
function handles = disp_samples(handles,pop_label_index)
pos = handles.temp.top_map;
num_train = size(handles.model.res.top_map,1);
col_in = get(handles.pop_layer, 'Value');
if col_in > 1
    text_color = 'red';
    text_color_pred = 'red';
else
    text_color = 'black';
    text_color_pred = 'red';
end
disp_label = [];
if pop_label_index == 2
    for j=1:num_train
        store_label{j} = num2str(j);
    end
    if handles.pred_present == 1
        for j=1:size(handles.pred_res.pred.top_map,1)
            store_label{num_train + j} = ['P' num2str(j)];
        end
    end
elseif ~strcmp(handles.model.type,'kohonen_map')
    if pop_label_index == 3 & length(handles.sample_label) > 0
        store_label = handles.sample_label;
        if handles.pred_present == 1 & length(handles.pred_res.sample_labels) > 1
            store_label = [store_label; handles.pred_res.sample_labels];   
        elseif handles.pred_present == 1
            for j=1:size(handles.pred_res.pred.top_map,1)
                store_label{num_train + j} = ['P' num2str(j)];
            end    
        end
    elseif pop_label_index == 3 & length(handles.sample_label) == 0
        for j=1:length(handles.class)
            store_label{j} = num2str(handles.class(j));
        end
        if handles.pred_present == 1 & length(handles.pred_res.class) > 1
            for j=1:length(handles.pred_res.class)
                store_label{num_train + j} = ['P' num2str(handles.pred_res.class(j))];
            end    
        elseif handles.pred_present == 1
            for j=1:size(handles.pred_res.pred.top_map,1)
                store_label{num_train + j} = ['P' num2str(j)];
            end    
        end
    else
        for j=1:length(handles.class)
            store_label{j} = num2str(handles.class(j));
        end
        if handles.pred_present == 1 & length(handles.pred_res.class) > 1
            for j=1:length(handles.pred_res.class)
                store_label{num_train + j} = ['P' num2str(handles.pred_res.class(j))];
            end    
        elseif handles.pred_present == 1
            for j=1:size(handles.pred_res.pred.top_map,1)
                store_label{num_train + j} = ['P' num2str(j)];
            end    
        end
    end
else
    store_label = handles.sample_label;
    if handles.pred_present == 1 & length(handles.pred_res.sample_labels) > 1
        store_label = [store_label; handles.pred_res.sample_labels];   
    elseif handles.pred_present == 1
        for j=1:size(handles.pred_res.pred.top_map,1)
            store_label{num_train + j} = ['P' num2str(j)];
        end    
    end
end

for j=1:length(store_label)
    if iscell(store_label(j))
        disp_label{j} = store_label{j};
    else
        disp_label{j} = num2str(store_label(j));
    end
end   

for i=1:size(pos,1)
    if strcmp(handles.model.net.settings.topol,'square')
        y_pos = size(handles.model.net.W,1) + 1 - pos(i,1) + 0.25 - rand*0.5;
        x_pos = pos(i,2) + 0.3 - rand*0.6;
    else
        x_pos = handles.temp.hexagon_center(pos(i,1),pos(i,2),1) + 0.25 - rand*0.5;
        y_pos = handles.temp.hexagon_center(pos(i,1),pos(i,2),2) + 0.25 - rand*0.5;
    end
    if i > num_train
        text(x_pos,y_pos,disp_label{i},'color',text_color_pred,'FontSize',8);
    else
        text(x_pos,y_pos,disp_label{i},'color',text_color,'FontSize',8);
    end
end

handles.disp_label = disp_label;

% ---------------------------------------------------------
function disp_weights(handles,var_in)
if ~strcmp(handles.model.type,'kohonen_map')
    num_var = size(handles.temp.W,3);
    num_cla = size(handles.temp.W_out,3);
    if var_in <= num_var
        W = squeeze(handles.temp.W(:,:,var_in));
        type = 'var';
    elseif var_in <= num_cla + num_var
        W = squeeze(handles.temp.W_out(:,:,var_in - num_var));
        type = 'cla';
    else
        W = handles.temp.neuron_ass;
        type = 'ass';
        col_ass = visualize_colors;
    end
else
    W = squeeze(handles.temp.W(:,:,var_in));
    type = 'var';
end

hold on
for k=1:size(W,1)
    for j=1:size(W,2)
        if strcmp(type,'ass')
            color_in = col_ass(handles.temp.neuron_ass(j,k) + 1,:);
        else
            color_in = [(1-W(j,k)) (1-W(j,k)) (1-W(j,k))];
        end
        if strcmp(handles.model.net.settings.topol,'square')
            pos_x = k;
            pos_y = size(W,2) + 1 - j;
            area([(pos_x - 0.5) (pos_x + 0.5)],[(pos_y + 0.5) (pos_y + 0.5)],pos_y - 0.5,'FaceColor',color_in);
        else
            Cord = handles.temp.hexagon_center;
            ind = handles.temp.neuron_label(j,k);
            draw_single_hexagon(Cord(j,k,1), Cord(j,k,2), color_in,ind)    
        end
    end
end
hold off


% ---------------------------------------------------------
function handles = move_map(handles,where)
if strcmp(where,'up')
    for i=1:size(handles.temp.top_map,1)
        handles.temp.top_map(i,1) = handles.temp.top_map(i,1) - 1;
        if handles.temp.top_map(i,1) == 0
            handles.temp.top_map(i,1) = size(handles.model.net.W,1);
        end
    end
    for i=1:size(handles.temp.W,1) - 1
        temp_W(i,:,:) = handles.temp.W(i + 1,:,:);
        temp_neuron_label(i,:) = handles.temp.neuron_label(i + 1,:);
    end
    if strcmp(handles.model.net.settings.topol,'hexagonal')
        if strcmp(handles.hexagon_first_row,'left'); 
            move_right = 0.5; handles.hexagon_first_row = 'right';
        else; 
            move_right = -0.5; handles.hexagon_first_row = 'left';
        end
        temp_center(:,:,2) = handles.temp.hexagon_center(:,:,2);
        odd_ind = [1:2:size(handles.temp.hexagon_center,1)];
        even_ind = [2:2:size(handles.temp.hexagon_center,1)];
        temp_center(odd_ind,:,1) = handles.temp.hexagon_center(odd_ind,:,1) + move_right;
        temp_center(even_ind,:,1) = handles.temp.hexagon_center(even_ind,:,1) - move_right;
        handles.temp.hexagon_center = temp_center;
    end
    temp_W(size(handles.temp.W,1),:,:) = handles.temp.W(1,:,:);
    temp_neuron_label(size(handles.temp.W,1),:) = handles.temp.neuron_label(1,:);
    handles.temp.W = temp_W;
    handles.temp.neuron_label = temp_neuron_label;
elseif strcmp(where,'down')
    for i=1:size(handles.temp.top_map,1)
        handles.temp.top_map(i,1) = handles.temp.top_map(i,1) + 1;
        if handles.temp.top_map(i,1) > size(handles.model.net.W,1)
            handles.temp.top_map(i,1) = 1;
        end
    end
    for i=1:size(handles.temp.W,1) - 1
        temp_W(i+1,:,:) = handles.temp.W(i,:,:);
        temp_neuron_label(i+1,:) = handles.temp.neuron_label(i,:);
    end
    if strcmp(handles.model.net.settings.topol,'hexagonal')
        if strcmp(handles.hexagon_first_row,'left'); 
            move_right = 0.5; handles.hexagon_first_row = 'right';
        else; 
            move_right = -0.5; handles.hexagon_first_row = 'left';
        end
        temp_center(:,:,2) = handles.temp.hexagon_center(:,:,2);
        odd_ind = [1:2:size(handles.temp.hexagon_center,1)];
        even_ind = [2:2:size(handles.temp.hexagon_center,1)];
        temp_center(odd_ind,:,1) = handles.temp.hexagon_center(odd_ind,:,1) + move_right;
        temp_center(even_ind,:,1) = handles.temp.hexagon_center(even_ind,:,1) - move_right;
        handles.temp.hexagon_center = temp_center;
    end
    temp_W(1,:,:) = handles.temp.W(size(handles.temp.W,1),:,:);
    temp_neuron_label(1,:) = handles.temp.neuron_label(size(handles.temp.W,1),:);
    handles.temp.W = temp_W;
    handles.temp.neuron_label = temp_neuron_label;
elseif strcmp(where,'right')
    for i=1:size(handles.temp.top_map,1)
        handles.temp.top_map(i,2) = handles.temp.top_map(i,2) + 1;
        if handles.temp.top_map(i,2) > size(handles.model.net.W,2)
            handles.temp.top_map(i,2) = 1;
        end
    end
    for i=1:size(handles.temp.W,2) - 1
        temp_W(:,i+1,:) = handles.temp.W(:,i,:);
        temp_neuron_label(:,i+1) = handles.temp.neuron_label(:,i);
    end
    temp_W(:,1,:) = handles.temp.W(:,size(handles.temp.W,2),:);
    temp_neuron_label(:,1) = handles.temp.neuron_label(:,size(handles.temp.W,2));
    handles.temp.W = temp_W;
    handles.temp.neuron_label = temp_neuron_label;
elseif strcmp(where,'left')
    for i=1:size(handles.temp.top_map,1)
        handles.temp.top_map(i,2) = handles.temp.top_map(i,2) - 1;
        if handles.temp.top_map(i,2) == 0
            handles.temp.top_map(i,2) = size(handles.model.net.W,2);
        end
    end
    for i=1:size(handles.temp.W,2) - 1
        temp_W(:,i,:) = handles.temp.W(:,i+1,:);
        temp_neuron_label(:,i) = handles.temp.neuron_label(:,i+1);
    end
    temp_W(:,size(handles.temp.W,2),:) = handles.temp.W(:,1,:);
    temp_neuron_label(:,size(handles.temp.W,2)) = handles.temp.neuron_label(:,1);
    handles.temp.W = temp_W;
    handles.temp.neuron_label = temp_neuron_label;
end

if ~strcmp(handles.model.type,'kohonen_map')
    if strcmp(where,'up')
        for i=1:size(handles.temp.W_out,1) - 1
            temp_W_out(i,:,:) = handles.temp.W_out(i + 1,:,:);
            temp_neuron_ass(i,:) = handles.temp.neuron_ass(i + 1,:);
        end
        temp_W_out(size(handles.temp.W_out,1),:,:) = handles.temp.W_out(1,:,:);
        temp_neuron_ass(size(handles.temp.W_out,1),:) = handles.temp.neuron_ass(1,:);
        handles.temp.W_out = temp_W_out;
        handles.temp.neuron_ass = temp_neuron_ass;
    elseif strcmp(where,'down')
        for i=1:size(handles.temp.W,1) - 1
            temp_W_out(i+1,:,:) = handles.temp.W_out(i,:,:);
            temp_neuron_ass(i+1,:) = handles.temp.neuron_ass(i,:);
        end
        temp_W_out(1,:,:) = handles.temp.W_out(size(handles.temp.W_out,1),:,:);
        temp_neuron_ass(1,:) = handles.temp.neuron_ass(size(handles.temp.W_out,1),:);
        handles.temp.W_out = temp_W_out;
        handles.temp.neuron_ass = temp_neuron_ass;
    elseif strcmp(where,'right')
        for i=1:size(handles.temp.W_out,2) - 1
            temp_W_out(:,i+1,:) = handles.temp.W_out(:,i,:);
            temp_neuron_ass(:,i+1) = handles.temp.neuron_ass(:,i);
        end
        temp_W_out(:,1,:) = handles.temp.W_out(:,size(handles.temp.W_out,2),:);
        temp_neuron_ass(:,1) = handles.temp.neuron_ass(:,size(handles.temp.W_out,1));
        handles.temp.W_out = temp_W_out;
        handles.temp.neuron_ass = temp_neuron_ass;
    elseif strcmp(where,'left')
        for i=1:size(handles.temp.W_out,2) - 1
            temp_W_out(:,i,:) = handles.temp.W_out(:,i+1,:);
            temp_neuron_ass(:,i) = handles.temp.neuron_ass(:,i+1);
        end
        temp_W_out(:,size(handles.temp.W_out,2),:) = handles.temp.W_out(:,1,:);
        temp_neuron_ass(:,size(handles.temp.W_out,2)) = handles.temp.neuron_ass(:,1);
        handles.temp.W_out = temp_W_out;
        handles.temp.neuron_ass = temp_neuron_ass;
    end
end

handles = update_plot(handles);


% ---------------------------------------------------------
function handles = set_list_labels(handles)
[y,x] = ginput(1);
[cord_y,cord_x] = find_neuron(y,x,handles);
in = find(handles.temp.top_map(:,1) == cord_x & handles.temp.top_map(:,2) == cord_y);
if length(in > 0) & length(handles.disp_label) > 0
    if length(handles.sample_label) > 0 & get(handles.pop_label,'Value') == 3
        for k=1:length(in)
            cur_labs{k} = handles.disp_label{in(k)};
        end    
    else
        cur_labs = handles.disp_label(in);
    end
    visualize_labels(cur_labs);
end


% ---------------------------------------------------------
function handles = show_weight_neuron(handles)
[y,x] = ginput(1);
[cord_y,cord_x] = find_neuron(y,x,handles);
if cord_y > 0 & cord_y <= size(handles.temp.W,1) & cord_x > 0 & cord_x <= size(handles.temp.W,1)
    w = squeeze(handles.temp.W(cord_x,cord_y,:));
    figure
    if length(w) < 20
        bar(w)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','r','FaceAlpha',0.5,'EdgeAlpha',1)
    else
        plot(w,'r')
    end
    ind = handles.temp.neuron_label(cord_x,cord_y);
    title(['kohonen weights of neuron ' num2str(ind) ' (row ' num2str(cord_x) ' - column ' num2str(cord_y) ' in this visualization)'])
    axis([0.5 length(w)+0.5 0 1])
    xlabel('variables')
    ylabel('kohonen weight')
    if length(w) < 20
        if length(handles.variable_label) > 0
            set(gca,'XTickLabel',handles.variable_label)    
        end
    end
    box on
    set(gcf,'color','white')
    % plot of class weight (output weight)
    if ~strcmp(handles.model.type,'kohonen_map')
        w_out = squeeze(handles.temp.W_out(cord_x,cord_y,:));
        figure
        set(gcf,'color','white')
        bar(w_out)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b','FaceAlpha',0.5,'EdgeAlpha',1)
        title(['output weights of neuron ' num2str(ind) ' (row ' num2str(cord_x) ' - column ' num2str(cord_y) ' in this visualization)'])
        axis([0.5 length(w_out)+0.55 0 1])
        xlabel('classes')
        ylabel('output weight')
        box on
    end
end

% ---------------------------------------------------------
function [cord_y,cord_x] = find_neuron(y,x,handles)
if strcmp(handles.model.net.settings.topol,'square')
    x = abs(x - size(handles.model.net.W,1)) + 1;
    cord_x = round(x);
    cord_y = round(y);
else
    C = handles.temp.hexagon_center;
    Cres = reshape(permute(C,[2 1 3]),[size(C,1)*size(C,2) size(C,3)]);
    x_in = [y x];
    D_squares_x = (sum(x_in'.^2))'*ones(1,size(Cres,1));
    D_squares_w = sum(Cres'.^2);
    D_product   = - 2*(x_in*Cres');
    D = (D_squares_x + D_squares_w + D_product).^0.5;
    [d_min,closest] = min(D);
    [cord_x,cord_y] = som_which_neuron(closest,size(Cres,1));
end

% ---------------------------------------------------------
function draw_single_hexagon(x_in, y_in, color_in,neuron_ind)
num_point = 6;
defined_ray = 0.5774;
[y,x] = cylinder(defined_ray,num_point);
y = y(1,:); x = x(1,:);
x = x + x_in;
y = y + y_in;    
area(x,y,max(y),'LineStyle','none','FaceColor',color_in);
plot(x,y,'k');
max_x = max(x);
max_y = max(y);
min_x = min(x);
min_y = min(y);

% ---------------------------------------------------------
function [max_x,max_y,min_x,min_y] = find_single_hexagon(x_in, y_in)
num_point = 6;
defined_ray = 0.5774;
[y,x] = cylinder(defined_ray,num_point);
y = y(1,:); x = x(1,:);
x = x + x_in;
y = y + y_in;    
max_x = max(x);
max_y = max(y);
min_x = min(x);
min_y = min(y);

% ---------------------------------------------------------
function disp_white_hexagon(handles)
Cord = handles.temp.hexagon_center;
hold on;
for k=1:size(handles.model.net.W,1)
    for j=1:size(handles.model.net.W,2)
        ind = handles.temp.neuron_label(k,j);
        draw_single_hexagon(Cord(k,j,1), Cord(k,j,2), [1 1 1],ind) 
    end
end
hold off

% ---------------------------------------------------------
function Cord = define_hexagon_centers(nsize)
hxgrd=som_hex_grid(nsize);
cnt = 0;
for i=1:nsize
    for j=1:nsize
        cnt = cnt + 1;
        Cord(i,j,1) = hxgrd(1,cnt);
        Cord(i,j,2) = hxgrd(2,cnt);
    end
end
Cord(:,:,2) = Cord(:,:,2) - (nsize - 1)/2;
Cord(:,:,2) = -Cord(:,:,2);
Cord(:,:,2) = Cord(:,:,2) + (nsize - 1)/2;
% add one for scale
Cord(:,:,1) = Cord(:,:,1) + 1;

