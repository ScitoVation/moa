function ind = som_which_col(cord_x,cord_y,W_reshape_size)

% som_which_col changes the map coordinates of a neuron into scalar
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

ind = cord_x*(W_reshape_size^0.5) - (W_reshape_size^0.5 - cord_y);