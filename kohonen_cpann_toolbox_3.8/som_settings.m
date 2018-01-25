function settings = som_settings(type)

% default setting structure for Kohonen maps and supervised artificial neural networks (CPANNs, XYFs, SKNs)
% som_settings build a default structure with all the parameter needed to perform calculations
% 
% settings = som_settings(type);
%
% input:
%   type                        type of settings
%                               'kohonen' for an unsupervised kohonen network.
%                               'cpann'   for a classification model based on counterpropagation artificial neural networks (CPANNs)
%                               'skn'     for a classification model based on supervised kohonen networks (SKNs)
%                               'xyf'     for a classification model based on XY-fused networks (XYFs) 
% 
% output:
%   settings is a structure, with the following fields
%   settings.net_type           type of the network ('kohonen' or 'cpann' or 'skn' or 'xyf')
%   settings.nsize              number of neurons for each side of the map (default = NaN)
%   settings.epochs             number of total epochs (default = NaN)
%   settings.topol              topology condition ('square' or 'hexagonal') (default = 'square')
%   settings.bound              boundary condition ('toroidal' or 'normal', defualt = 'toroidal')
%   settings.training           training algorithm ('sequential' or 'batch', default = 'batch')
%   settings.init               weight initialisation ('random' or 'eigen', defualt = 'random')
%   settings.a_max              initial learning rate (any real number between 0 and 1), defualt = 0.5
%   settings.a_min              final learning rate (any real number between 0 and a_max), defualt = 0.01
%   settings.scaling            data scaling (prior to automatic range scaling), default = 'none'
%                               if scaling = 'none' no scaling
%                               if scaling = 'cent' centering
%                               if scaling = 'scal' variance scaling
%                               if scaling = 'auto' for autoscaling (centering + variance scaling)
%   settings.absolute_range     automatic range scaling
%                               if absolute_range = 0 (default), range scaling is applied separatly on each column (variable)
%                               if absolute_range = 1, range scaling is applied on the absolute maximum and
%                               minimum values of the data
%   settings.show_bar           show waitbar during calculation 
%                               if show_bar = 0 (default), trained epochs are shown on the command window
%                               if show_bar = 1, the waitbar is shown
%                               if show_bar = 2, nothing is shown
%   settings.ass_meth           assignation method (only for cpann, xyf, skn), defualt = 1
%                               if ass_meth = 1 -> maximum weigth
%                               if ass_meth = 2 -> maximum difference over threshold
%                               if ass_meth = 3 -> maximum weigth over threshold
%                               if ass_meth = 4 -> smoothed weight over threshold
%   settings.scalar             scalar is a coefficient for tuninng effect of class membership on input map (only for SKN), defualt = 1
% 
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio & Mahdi Vasighi
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

settings          = [];
settings.name     = ['som_settings_' type];
settings.net_type = type;         % net type
settings.nsize    = NaN;          % net size
settings.epochs   = NaN;          % number of total epochs
settings.topol    = 'square';     % topology condition ('square' or 'hexagonal')
settings.bound    = 'toroidal';   % boundary condition ('toroidal' or 'normal')
settings.training = 'batch';      % training algorithm ('sequential' or 'batch')
settings.init     = 'random';     % initialisation of weights ('random' or 'eigen')
settings.a_max    = 0.5;          % initial learning rate
settings.a_min    = 0.01;         % final learning rate
settings.scaling  = 'none';       % data scaling prior to automatic range scaling
settings.absolute_range = 0;      % automatic range scaling
settings.show_bar = 0;            % show waitbar during calculation
if ~strcmp(type,'kohonen')
    settings.ass_meth = 1;        % assignation method for cpann, skn and xyf
end
if strcmp(type,'skn')
    settings.scalar = 1;          % assignation scalar value for skn.
end