function Wnew = cpann_update(x,W,winner,act_epoch,U)

% cpann_update updates CPANN weights
%
% Wnew = cpann_update(x,W,winner,act_epoch,U)
%
% input:
%   x           sample [1 x c]
%   W           unfolded CPANN weights [size*size x c]
%   winner      winner neuron
%   act_epoch   number of actual epoch
%   U           structure with updating parameters
% 
% output:
%   Wnew       unfolded updated CPANN weights [size*size x c]
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

where = ones(1,size(x,2));
D = U.update{act_epoch};
D = D(:,winner);
D = D(logical(ones(size(D,1),1)),ones(sum(where),1));
where = logical(where);
x_diff = x(ones(size(W,1),1),where);
Wnew = W + D.*(x_diff - W);