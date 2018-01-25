function model = model_kohonen(X,settings)

% Kohonen maps
% model_kohonen builds Kohonen maps (self organising maps, SOM)
% 
% model = model_kohonen(X,settings);
% 
% input:
%   X           data [n x p], n samples, p variables
%   settings    setting structure
% 
% output:
%   model is a structure, with the following fields
%   model.net.W             kohonen weights [size x size x p]
%   model.scal              structure containing scaling parameters
%   model.res.top_map       sample position in the kohonen map [n x 2]
% 
% important:
% - to define the settings structure type 'help som_settings'
% - data can be scaled (type help som_settings). After the scaling, 
%   data are always range scaled (inbetween 0 and 1) in order to make 
%   them comparable with net weights
% 
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

% checks
errortype = kohonen_check(X,settings,[],'model');  
if ~strcmp(errortype,'none')
    disp(errortype)
    model = NaN;
    return
end

% data scaling
[Xsca,scal] = som_scaling(X,settings);

% calculates the map
[net,count_epo] = som_net(Xsca,settings);

% projects the samples on the topmap
W_reshape = reshape(permute(net.W,[2 1 3]),[settings.nsize*settings.nsize size(Xsca,2)]);
for i = 1:size(Xsca,1)
    x_in = Xsca(i,:);
    winner = som_winner(x_in,W_reshape);
    [pos(i,1),pos(i,2)] = som_which_neuron(winner,size(W_reshape,1));
end

% saves results
model.type = 'kohonen_map';
model.net = net;
model.scal = scal;
model.res.top_map = pos;

if count_epo < settings.epochs
    model = NaN;
end