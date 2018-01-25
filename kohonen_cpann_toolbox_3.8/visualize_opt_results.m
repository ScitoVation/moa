function varargout = visualize_opt_results(varargin)

% visualize_opt_results opens a graphical interface to
% visualize the optimisation results.
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
                   'gui_OpeningFcn', @visualize_opt_results_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_opt_results_OutputFcn, ...
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


% --- Executes just before visualize_opt_results is made visible.
function visualize_opt_results_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 28.2941 134.7143 31.1765]);
set(handles.visualize_opt_results,'Position',[103.8571 28.2941 134.7143 31.1765]);
set(handles.button_save,'Position',[107.6 24.5385 20.8 1.7692]);
set(handles.text_crit,'Position',[109.4 14.2308 19 1.1538]);
set(handles.text_freq,'Position',[109.4 15.3846 19 1.1538]);
set(handles.text_epochs,'Position',[109.2 16.5385 16.6 1.1538]);
set(handles.text_size,'Position',[109.2 17.6923 20.8 1.1538]);
set(handles.text1,'Position',[108.6 19.3077 21.2 1.1538]);
set(handles.button_select,'Position',[113.2 11.8462 14.6 1.7692]);
set(handles.button_table,'Position',[107.4 27.3077 21 1.8462]);
set(handles.button_export,'Position',[107.6 21.8462 20.8 1.7692]);
set(handles.frame1,'Position',[107.4 11.0769 25 8.5385]);
set(handles.bubbleplot,'Position',[12.8 3.6154 91.4 26.3846]);
set(handles.output,'Position',[103.8571 28.2941 134.7143 31.1765]);
movegui(handles.visualize_opt_results,'center');
handles.opt_res = varargin{1};
handles.C = opt_eval(handles.opt_res,0);
handles.ns_bank = handles.opt_res.settings.ns_bank;
handles.ep_bank = handles.opt_res.settings.ep_bank;

update_plot(handles,0,0);

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_opt_results_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% -------------------------------------------------------------
function button_export_Callback(hObject, eventdata, handles)
update_plot(handles,1,0);

% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
visualize_export(handles.opt_res,'opt')

% -------------------------------------------------------------
function button_table_Callback(hObject, eventdata, handles)
Cprint = prepeare_table(handles.C);
assignin('base','tmp_view',Cprint);
openvar('tmp_view');

% -------------------------------------------------------------
function button_select_Callback(hObject, eventdata, handles)
select_bubble(handles)

% -------------------------------------------------------------
function update_plot(handles,external,closest)

if external; figure; title('bubble plot'); set(gcf,'color','white'); box on; else; axes(handles.bubbleplot); end
cla;
opt_bubbleplot(handles.C,handles.ns_bank,handles.ep_bank,0,closest)

% -------------------------------------------------------------
function Cprint = prepeare_table(C)

Cprint{1,1} = 'neurons';
Cprint{1,2} = 'epochs';
Cprint{1,3} = 'frequency';
Cprint{1,4} = 'optimisation criterion';
for i=1:size(C,1)
    Cprint{i+1,1} = [num2str(C(i,1)) 'x' num2str(C(i,1))];
    Cprint{i+1,2} = num2str(C(i,2));
    Cprint{i+1,3} = num2str(C(i,3));
    Cprint{i+1,4} = num2str(C(i,4));
end

% -------------------------------------------------------------
function select_bubble(handles)

C = handles.C;
Xd = C(:,3:4);
[x_sel,y_sel] = ginput(1);
xd = [x_sel y_sel];
D_squares_x = (sum(xd'.^2))'*ones(1,size(Xd,1));
D_squares_w = sum(Xd'.^2);
D_product   = - 2*(xd*Xd');
D = (D_squares_x + D_squares_w + D_product).^0.5;
[d_min,closest] = min(D);

update_plot(handles,0,closest)

ns = C(closest,1); ep = C(closest,2);
freq = round(1000*C(closest,3))/1000; 
crit = round(1000*C(closest,4))/1000;
set(handles.text_size,'String',['neurons: ' num2str(ns) 'x' num2str(ns)]);
set(handles.text_epochs,'String',['epochs: ' num2str(ep)]);
set(handles.text_freq,'String',['frequency: ' num2str(freq)]);
set(handles.text_crit,'String',['opt. criterion: ' num2str(crit)]);

