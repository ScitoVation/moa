function [Xsca,scal] = som_scaling(X,settings,model)

% som_scaling applies range scaling inbetween 0 and 1 and (if defined
% in the model settings), scaling prior to range scaling.
% If model (optional) is an input, then data are scaled on the basis
% of the scaling parameters of the model (scaling of test samples)
%
% [Xsca,scal] = som_scaling(X,settings,model)
%
% input:
%   X           data [n x p]
%   settings    setting structure
%
% optional input:
%   model       model structure
% 
% output:
%   X           scaled data [n x p]
%   scal        scaling informations as structure
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm


if nargin < 3
    % applies data scaling defined in the settings
    [X,param] = som_pretreatment_data(X,settings.scaling);
    
    % applies automatic range scaling on training samples
    if settings.absolute_range == 0
        for j=1:size(X,2)
            min_var(j) = min(X(:,j));
            max_var(j) = max(X(:,j));
            for i=1:size(X,1)
                if (max_var(j) - min_var(j)) == 0
                    Xsca(i,j) = 0; 
                else
                    Xsca(i,j) = (X(i,j) - min_var(j))/(max_var(j) - min_var(j)); 
                end
            end
        end 
        scal.type = 'range_scaling';
        scal.min_var = min_var;
        scal.max_var = max_var;
        scal.prior_scal = param;
    else % applies absolute automatic range scaling on training samples
        min_var = min(min(X));
        max_var = max(max(X));
        for j=1:size(X,2)
            for i=1:size(X,1)
                if (max_var - min_var) == 0
                    Xsca(i,j) = 0; 
                else
                    Xsca(i,j) = (X(i,j) - min_var)/(max_var - min_var); 
                end
            end
        end
        scal.type = 'absolute_range_scaling';
        scal.min_var = min_var;
        scal.max_var = max_var;
        scal.prior_scal = param;
    end
else % applies range scaling on test samples
    % applies data scaling defined in the settings
    X = som_pretreatment_test(X,model.scal.prior_scal);
    
    % applies automatic range scaling on test samples
    if model.net.settings.absolute_range == 0
        for j=1:size(X,2)
            min_var(j) = model.scal.min_var(j);
            max_var(j) = model.scal.max_var(j);
            for i=1:size(X,1)
                if (max_var(j) - min_var(j)) == 0
                    Xsca(i,j) = 0; 
                else
                    Xsca(i,j) = (X(i,j) - min_var(j))/(max_var(j) - min_var(j)); 
                end
            end
        end
        scal = 0;
    else
        min_var = model.scal.min_var;
        max_var = model.scal.max_var;
        for j=1:size(X,2)
            for i=1:size(X,1)
                if (max_var - min_var) == 0
                    Xsca(i,j) = 0; 
                else
                    Xsca(i,j) = (X(i,j) - min_var)/(max_var - min_var); 
                end
            end
        end
        scal = 0;        
    end
end