function errortype = cpann_check(X,class,settings,model,type)

% multiple checks for cpann inputs
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
        errortype = check_classes(class,errortype);
        errortype = check_data(X,class,errortype);
        errortype = check_settings(settings,errortype);
        
    case {'cv'}
        errortype = check_data(X,class,errortype);
        errortype = check_classes(class,errortype);
        errortype = check_settings(settings,errortype);
        
    case {'pred'}
        errortype = check_layer(X,model,errortype);

end

% -------------------------------------------------------------------------

function errortype = check_classes(class,errortype)

% number of classes 
if max(class) < 2                                         
    errortype = 'input error: not enough classes (only one class detected)';
    return
end

% no zeros
if length(find(class==0)) > 0                                         
    errortype = 'input error: class labels equal to zero are not allowed';
    return
end

% class labels are consecutive 
for g=1:max(class)
    cla_lab(g) = length(find(class == g));
end
if length(find(cla_lab == 0));     
    errortype = (['class labels must  be numbers from 1 to G (where G is the total number of classes) ' ...
                'i.e. the first class should be labelled as 1, the second one as 2 and so on.']);
    return
end

% -------------------------------------------------------------------------

function errortype = check_data(X,class,errortype)

% data structure
if  ndims(X) < 2 | ndims(X) > 2                 
    errortype = 'input error: wrong data structure, data must be a 2 way data matrix';
    return
end

% class size
if size(class,2) > 1                            
    chk = 0;
    errortype = 'input error: the class must be defined as a vector of dimension: samples x 1';
    return
end

% no. of samples for data and class matrices
if size(class,1) ~= size(X,1)                   
    chk = 0;
    errortype = 'input error: data and class must have the same number of rows (objects)';
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

if ~isfield(settings,'ass_meth')                   
    errortype = 'input error: ass_meth is not defined in the setting structure';
    return
end

if strcmp(settings.topol,'hexagonal') & strcmp(settings.bound,'toroidal') & rem(settings.nsize,2)>0   
    errortype = 'input error: if topology is hexagonal and boundary condition is toroidal, the number of neurons for each side of the map must be an even number';
    return
end

% -------------------------------------------------------------------------

function errortype = check_layer(X,model,errortype)

if  size(X,2) ~= size(model.net.W,3)                 
    errortype = 'input error: the number of variables (columns) in X are different with respect to the number of layers in the model';
    return
end