function errortype = kohonen_check(X,settings,model,type)

% multiple checks for kohonen inputs
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

errortype = 'none';
switch type
    
    case {'model'}
        errortype = check_data(X,errortype);
        errortype = check_settings(settings,errortype);
                
    case {'pred'}
        errortype = check_layer(X,model,errortype);

end

% -------------------------------------------------------------------------

function errortype = check_data(X,errortype)

% data structure
if  ndims(X) < 2 | ndims(X) > 2                 
    errortype = 'input error: wrong data structure, data must be a 2 way data matrix';
    return
end

% -------------------------------------------------------------------------

function errortype = check_settings(settings,errortype)

if  isnan(settings.nsize)                 
    errortype = 'input error: the map size (settings.nsize) is not defined in the setting structure';
    return
end

if  isnan(settings.epochs)                 
    errortype = 'input error: the number of epochs (settings.epochs) is not defined in the setting structure';
    return
end

% -------------------------------------------------------------------------

function errortype = check_layer(X,model,errortype)

if  size(X,2) ~= size(model.net.W,3)                 
    errortype = 'input error: the number of variables (columns) in X are different with respect to the number of layers in the model';
    return
end