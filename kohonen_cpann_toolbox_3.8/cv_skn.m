function cv = cv_skn(X,class,settings,cv_type,cv_groups)

% cross validation for Supervised Kohonen Networks (SKNs)
% cross validation can be performed:
% a) with venetian blinds, i.e. with 3 cv groups the split of the first 
% group will be [1,0,0,1,0,0,....,1,0,0] and so on.
% b) with contiguous blocks, i.e. the split of the first group will be 
% [1,1,1,1,0,0,....,0,0,0] and so on.
% In order to cross validate the model by means of Leave-One-Out just
% select venetian blinds or contiguous blocks and set cv_groups = n
%
% cv = cv_skn(X,class,settings,cv_type,cv_groups);
%
% input:
%   X           data [n x p], n samples, p variables
%   class       class vector [n x 1], numerical labels
%   settings    setting structure
%   cv_type     type of cross validation:
%               if cv_type = 1: venetian blinds
%               if cv_type = 2: contiguous blocks
%   cv_groups   number of cross-validation groups
% 
% output:
%   cv is a structure, with the following fields
%   cv.class_true       class vector [n x 1]
%   cv.class_pred       calculated class in cross validation [n x 1]
%   cv.class_weights    output weights associated to samples [n x c]
%   cv.class_param      structure containing confusion matrix, 
%                       error rate, non-error rate, specificity, 
%                       precision and sensitivity
%   cv.settings         settings structure used for the calculation
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
errortype = cpann_check(X,class,settings,[],'cv');  
if ~strcmp(errortype,'none')
    disp(errortype)
    return
end

if cv_groups == 1
    disp('error: not possible calculating cross-validation with just 1 cross-validation group')
    return    
end

nobj = size(X,1);
pred_cv = zeros(nobj,1);
class_weights_cv = zeros(nobj,max(class));
obj_in_block = fix(nobj/cv_groups);
left_over = mod(nobj,cv_groups);
st = 1;
en = obj_in_block;

for i=1:cv_groups
    % prepares objects
    in = ones(nobj,1);
    if cv_type == 1 % venetian blinds
        out = [i:cv_groups:nobj];
    else % contiguous blocks
        if left_over == 0
            out = [st:en];
            st =  st + obj_in_block;  en = en + obj_in_block;
        else
            if i < cv_groups - left_over
                out = [st:en];
                st =  st + obj_in_block;  en = en + obj_in_block;
            elseif i < cv_groups
                out = [st:en + 1];
                st =  st + obj_in_block + 1;  en = en + obj_in_block + 1;
            else
                out = [st:nobj];
            end
        end
        
    end
    in(out) = 0;
    canc_groups{i} = in;
end

for i=1:length(canc_groups)
    in = canc_groups{i};
    if settings.show_bar == 0
        disp(['cross validating group ' num2str(i)])
    else
        settings.show_bar_text = ['cross validating group ' num2str(i) ' of ' num2str(cv_groups) ', please wait...'];
    end
    X_training = X(find(in==1),:);
    X_test = X(find(in==0),:);
    class_training = class(find(in==1));
    class_test = class(find(in==0));
    % calculates model
    model = model_skn(X_training,class_training,settings);
    if isstruct(model)
        pred = pred_skn(X_test,model);
        pred_cv(find(in==0)) = pred.class_pred;
        class_weights_cv(find(in==0),:) = pred.class_weights;
    else
        cv = NaN;
        return
    end
end

if isfield(settings,'show_bar_text')
    settings = rmfield(settings,'show_bar_text');
end

class_param = cpann_class_param(pred_cv,class);

% saves results
cv.type = 'skn';
cv.class_true = class;
cv.class_pred = pred_cv;
cv.class_weights = class_weights_cv;
cv.class_param = class_param;
cv.settings = settings;
cv.settings.cv_type = cv_type;
cv.settings.cv_groups = cv_groups;