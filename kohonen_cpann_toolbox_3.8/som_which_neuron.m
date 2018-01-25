function [cord_row,cord_col] = som_which_neuron(ind,W_reshape_size)

% som_which_neuron finds the map coordinates of a neuron
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

cord_col = mod(ind,W_reshape_size^0.5);
if cord_col == 0
    cord_col = W_reshape_size^0.5; 
end
cord_row = (ind - cord_col)/(W_reshape_size^0.5) + 1;