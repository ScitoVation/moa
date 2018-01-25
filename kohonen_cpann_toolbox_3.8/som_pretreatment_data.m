function [X_scal,param] = som_pretreatment_data(X,pret_type)

% som_pretreatment_data applies pretreatment on training set
%
% [Xsca,scal] = som_pretreatment_data(X,pret_type)
%
% input:
%   X           data [n x p]
%   pret_type:  'none' no scaling
%               'cent' cenering
%               'scal' variance scaling
%               'auto' for autoscaling (centering + variance scaling)
% 
% output:
%   Xscal       scaled data [n x p]
%   param       parameters used for scaling as structure
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

a = mean(X);
s = std(X);

if strcmp(pret_type,'cent')
    amat = repmat(a,size(X,1),1);
    X_scal = X - amat;
elseif strcmp(pret_type,'scal')
    smat = repmat(s,size(X,1),1);
    X_scal = X./smat;  
elseif strcmp(pret_type,'auto')
    amat = repmat(a,size(X,1),1);
    smat = repmat(s,size(X,1),1);
    X_scal = (X - amat)./smat;  
else
    X_scal = X;
end

param.a = a;
param.s = s;
param.pret_type = pret_type;