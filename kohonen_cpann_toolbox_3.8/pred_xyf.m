function pred = pred_xyf(X,model)

% prediction of unknown samples with X-Y fused networks (XY-Fs)
% pred_xyf predicts classes of unknown samples by using a previuos model
% built by means of XY-Fs (model_xyf)
% 
% pred = pred_xyf(X,model);
%
% input:
%   X                       data [n x p], n samples, p variables
%   model                   model structure built with model_xyf
% 
% output:
%   pred is a structure, with the following fields
%   pred.class_pred         predicted class [n x 1]
%   pred.class_weights      output weights associated to samples [n x c]
%   pred.top_map            sample position in the kohonen map [n x 2]
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
errortype = cpann_check(X,[],[],model,'pred');  
if ~strcmp(errortype,'none')
    disp(errortype)
    pred = NaN;
    return
end

% data scaling
[Xsca,scal] = som_scaling(X,[],model);

% projects the samples on the topmap and assigns samples to classes
nsize = size(model.net.W,1);
W_reshape = reshape(permute(model.net.W,[2 1 3]),[nsize*nsize size(X,2)]);
for i = 1:size(X,1)
    x_in = Xsca(i,:);
    winner = som_winner(x_in,W_reshape);
    [pos(i,1),pos(i,2)] = som_which_neuron(winner,size(W_reshape,1));
    class_pred(i) = model.net.neuron_ass(pos(i,1),pos(i,2));
    class_weights(i,:) = model.net.W_out(pos(i,1),pos(i,2),:);
end

% saves results
pred.type = 'xyf';
pred.class_pred = class_pred';
pred.class_weights = class_weights;
pred.top_map = pos;