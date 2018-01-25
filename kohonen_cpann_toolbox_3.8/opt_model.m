function opt_res = opt_model(X,class,settings,val_type,num_groups,opt_fun,ns_bank,ep_bank,rep_model)

% opt_model searches the optimal number of neurons and epochs for
% classification model based on SOMSs by means of Genetich Algorithms
% 
% opt_res = opt_model(X,class,settings,val_type,num_groups,opt_fun,ns_bank,ep_bank,rep_model);
%
% input:
%   X                         data [n x p], n samples, p variables
%   class                     class vector [n x 1], numerical labels
%   settings                  setting structure built with som_settings, nsize and epochs must be Nan
%   val_type                  defines the validation procedures
%                             val_type = 1: cross-validation with venetian blinds
%                             val_type = 2: cross-validation with contiguous blocks
%                             val_type = 3: random sets with 20% of samples
%   num_groups                defines the number of cv groups or the number of random sets 
%                             num_groups corresponds to the number of GA runs
%   opt_fun                   defines the optimisation criteria
%                             opt_fun = 1: weighted NER and NER test
%                             opt_fun = 2: NER test
%   ns_bank                   vector [7x1] with the evaluated neuron sizes, e.g. ns_bank=[4 6 8 10 12 14 16];
%   ep_bank                   vector [7x1] with the evaluated training epochs, e.g. ep_bank=[50 100 150 200 250 300 350];
%   rep_model                 repetitions of each classification model (suggested 5), to
%                             avoid noise due to the random initialization of the SOM weights 
%
% output:
%   opt_res is a structure, with the following fields
%   opt_res.chrom:            structure containing the final populations of chromosomes
%                             the number of final populations will be equal
%                             to the number of GA runs (num_groups)
%   opt_res.crit:             structure containing the optimisation criteria corresponding to the chromosomes
%                             stored in chrom
%   opt.settings:             structure containing the settings used in the optimisation
% 
% important:
% - consider that the optimisation process can require time
% - in order to evaluate the optimisation results, use the opt_eval function
% 
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

% checks inputs
topol = settings.topol;
bound = settings.bound;

errortype = opt_check(topol,bound,ns_bank,ep_bank);  
if ~strcmp(errortype,'none')
    disp(errortype)
    opt_res = NaN;
    return
end

nobj = size(X,1);
obj_in_block = fix(nobj/num_groups);
left_over = mod(nobj,num_groups);
st = 1;
en = obj_in_block;

for k=1:num_groups
    in = ones(size(X,1),1);
    if val_type == 1
        out = [k:num_groups:nobj];        
        in(out) = 0;
    elseif val_type == 2
        if left_over == 0
            out = [st:en];
            st =  st + obj_in_block;  en = en + obj_in_block;
        else
            if k < num_groups - left_over
                out = [st:en];
                st =  st + obj_in_block;  en = en + obj_in_block;
            elseif k < num_groups
                out = [st:en + 1];
                st =  st + obj_in_block + 1;  en = en + obj_in_block + 1;
            else
                out = [st:nobj];
            end
        end
        in(out) = 0;
    else
        num_out = round(size(X,1)*0.2);
        for g=1:max(class)
            samples_in_class = length(find(class==g));
            perc_in_class(g) = samples_in_class/size(X,1);
            num_out_in_class(g) = round(num_out*perc_in_class(g));
        end
        for g=1:max(class)
            out_tot = 0;
            in_class = ones(size(X(find(class==g)),1),1);
            while out_tot < num_out_in_class(g);
                r = ceil(rand*size(X(find(class==g)),1));
                if in_class(r) == 1
                    in_class(r) = 0;
                    out_tot = out_tot + 1;
                end
            end
            in(find(class==g)) = in_class;
        end
    end
    canc_groups{k} = in;
end

for k=1:length(canc_groups)
    % split samples in calibration and evaluation sets
    in  = canc_groups{k};
    X_train = X(find(in==1),:);
    X_test  = X(find(in==0),:);
    class_train = class(find(in==1));
    class_test  = class(find(in==0));
    
    % calculates GAs
    disp(['run: ' num2str(k) ' of ' num2str(num_groups)])
    [chrom{k},crit{k},gaset] = opt_ga(X_train,X_test,class_train,class_test,settings,opt_fun,ns_bank,ep_bank,rep_model);
end

opt_res.chrom = chrom;
opt_res.crit  = crit;
opt_res.settings.ep_bank = ep_bank;
opt_res.settings.ns_bank = ns_bank;
opt_res.settings.val_type = val_type;
opt_res.settings.num_groups = num_groups;
opt_res.settings.opt_fun = opt_fun;
opt_res.settings.som_settings = settings;
opt_res.settings.gaset = gaset;
opt_res.settings.rep_model = rep_model;
