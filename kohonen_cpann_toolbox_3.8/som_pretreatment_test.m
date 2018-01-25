function [X_scal] = som_pretreatment_test(X,param)

% som_pretreatment_test applies pretreatment on test set
%
% [Xsca] = som_pretreatment_test(X,param)
%
% input:
%   X           data [n x p]
%   param:      output data structure from som_pretreatment_data routine
% 
% output:
%   Xscal       scaled data [n x p]
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

a = param.a;
s = param.s;
pret_type = param.pret_type;

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
