function Wnew = som_update(x,W,winner,act_epoch,U)

% som_update updates kohonen weights for sequential learning
%
% Wnew = som_update(x,W,winner,act_epoch,U)
%
% input:
%   x           sample [1 x c]
%   W           unfolded kohonen weights [size*size x c]
%   winner      winner neuron
%   act_epoch   number of actual epoch
%   U           structure with updating parameters
% 
% output:
%   Wnew       unfolded updated kohonen weights [size*size x c]
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

Wnew = W;
where_notnan = ~isnan(x);
D = U.update{act_epoch};
D = D(:,winner);
D = D(logical(ones(size(D,1),1)),ones(sum(where_notnan),1));
where = logical(where_notnan);
x_diff = x(ones(size(W,1),1),where);
if sum(where_notnan) == size(x,2)
    Wnew = W + D.*(x_diff - W);
else
    Wnew(:,find(where_notnan)) = W(:,find(where_notnan)) + D.*(x_diff - W(:,find(where_notnan)));
end