function model = model_cpann(X,class,settings)

% counterpropagation artificial neural networks (CPANNs)
% model_cpann builds a classification model based on CPANNs
% 
% model = model_cpann(X,class,settings);
%
% input:
%   X           data [n x p], n samples, p variables
%   class       class vector [n x 1], numerical labels
%   settings    setting structure
% 
% output:
%   model is a structure, with the following fields
%   model.net.W             kohonen weights [size x size x p]
%   model.net.W_out         output weights [size x size x c]
%   model.net.neuron_ass    assignation of neurons [size x size]
%   model.scal              structure containing scaling parameters
%   model.res.top_map       sample position in the kohonen map [n x 2]
%   model.res.class_true    original class vector
%   model.res.class_calc    calculated class [n x 1]
%   model.res.class_weights output weights associated to samples [n x c]
%   model.res.class_param   structure containing confusion matrix, 
%                           error rate, non-error rate, specificity, 
%                           precision and sensitivity
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
errortype = cpann_check(X,class,settings,[],'model');  
if ~strcmp(errortype,'none')
    disp(errortype)
    model = NaN;
    return
end

% data scaling
[Xsca,scal] = som_scaling(X,settings);

% calculates the map
[net,count_epo] = som_net(Xsca,settings,class);

% assigns neurons to classes
method = settings.ass_meth;
thr_assign(1) = NaN;
thr_assign(2) = 0.3;
thr_assign(3) = 0.5;
thr_assign(4) = 0.5;
neuron_ass = cpann_assign_neuron(net.W_out,method,thr_assign);

% projects the samples on the topmap and assigns samples to classes
W_reshape = reshape(permute(net.W,[2 1 3]),[settings.nsize*settings.nsize size(Xsca,2)]);
for i = 1:size(X,1)
    x_in = Xsca(i,:);
    winner = som_winner(x_in,W_reshape);
    [pos(i,1),pos(i,2)] = som_which_neuron(winner,size(W_reshape,1));
    class_calc(i) = neuron_ass(pos(i,1),pos(i,2));
    class_weights(i,:) = net.W_out(pos(i,1),pos(i,2),:);
end

% calculates classification parameters
class_param = cpann_class_param(class_calc,class);

% saves results
model.type = 'cpann';
model.net = net;
model.net.neuron_ass = neuron_ass;
model.scal = scal;
model.res.top_map = pos;
model.res.class_true = class;
model.res.class_calc  = class_calc';
model.res.class_weights = class_weights;
model.res.class_param = class_param;

if count_epo < settings.epochs
    model = NaN;
end