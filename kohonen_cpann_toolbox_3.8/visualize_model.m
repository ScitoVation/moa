function visualize_model(model,sample_labels,variable_labels,pred)

% visualisation of the Kohonen top map results 
% visualize_model opens a GUI figure for exploring the results of Kohonen maps.
% This routine is used in the graphical user interface of the toolbox
%
% visualize_model(model);
%
% input:
%   model               model structure
%
% optional input
%   sample_labels       label vector as cell array [n x 1]
%   variable_labels     label vector as cell array [p x 1]
%   pred                structure containing prediction results
%                       obtained with pred_cpann or pred_kohonen
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

if nargin < 2
    visualize_map(model,{},{},{})
elseif nargin == 2
    visualize_map(model,sample_labels,{},{})
elseif nargin == 3 & length(sample_labels) == 0
    visualize_map(model,{},variable_labels,{})
elseif nargin == 3 & length(variable_labels) == 0
    visualize_map(model,sample_labels,{},{})
elseif nargin == 3
    visualize_map(model,sample_labels,variable_labels,{})
elseif nargin == 4 & length(sample_labels) == 0
    visualize_map(model,{},variable_labels,pred)
elseif nargin == 4 & length(variable_labels) == 0
    visualize_map(model,sample_labels,{},pred)    
elseif nargin == 4
    visualize_map(model,sample_labels,variable_labels,pred)
end