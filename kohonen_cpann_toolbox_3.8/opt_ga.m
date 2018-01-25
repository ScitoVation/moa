function [chrom,crit,gaset] = opt_ga(X_train,X_test,class_train,class_test,settings,opt_fun,ns_bank,ep_bank,rep_model)

% opt_ga runs Genetich Algorithms to search the optimal number of neurons and epochs for
% classification model based on SOMSs by means of Genetich Algorithms. It's
% used by the main function opt_model
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm


% GA settings
chr = 10;       % number of chromosomes
gnm = 6;        % number of gens
probmut=0.05;   % probability of mutation 
probcross=0.5;  % probability of cross-over
maxeval = 25;   % maximum evalution repetition
maxfreq = 25;   % maximum repetition-frequency of best chromosom
topol = settings.topol;
bound = settings.bound;

% initialization of population
chrom = zeros(1,gnm);
cnt_chr = 1;
while size(chrom,1) < chr
    chrom_tmp = round(rand(1,gnm));
    chrom_status = chrom_check(chrom_tmp,chrom);
    if strcmpi(chrom_status,'ok') 
        chrom(cnt_chr,:) = chrom_tmp;
        cnt_chr = cnt_chr + 1;
    end
end

% evaluation of initial population
disp('population initialisation...')
crit = model_crit(X_train,X_test,class_train,class_test,chrom,rep_model,settings,opt_fun,ns_bank,ep_bank)';

% sorting chromosoms
[sorted_crit,ind_sort] = sort(-crit);
chrom = chrom(ind_sort,:);
crit  = -sorted_crit;
display_best_chrom(chrom,crit,ns_bank,ep_bank,'after initialisation')

% start evolution
eval_count  = size(chrom,1); 
best_freq = 0;
doeval = 1;
chrom_lib = chrom; % library of all evaluated chromosomes
while doeval

    chrom_status1 = 'no';
    chrom_status2 = 'no';
    while ~strcmpi(chrom_status1,'ok') || ~strcmpi(chrom_status2,'ok')
        % selection of two chromosoms
        eval_id    = select_chrom(crit);
        chrom_eval = chrom(eval_id,:);
    
        % crossover on size
        diff = find(chrom_eval(1,1:3) ~= chrom_eval(2,1:3));
        randmat =rand(1,1);
        if randmat < probcross
            chrom_eval(:,1:3) = flipud(chrom_eval(:,1:3));
        end

        % crossover on epochs
        diff = find(chrom_eval(1,4:6) ~= chrom_eval(2,4:6));
        randmat = rand(1,1);
        if randmat < probcross
            chrom_eval(:,4:6) = flipud(chrom_eval(:,4:6));
        end
        
        % mutation
        m = rand(2,gnm);
        [pp,qq] = find(m < probmut);
        for ii=1:length(pp)
            chrom_eval(pp(ii),qq(ii)) = abs(chrom_eval(pp(ii),qq(ii))-1);
        end
    
        %check chromosom status
        chrom_status1=chrom_check(chrom_eval(1,:),chrom_lib);
        chrom_status2=chrom_check(chrom_eval(2,:),chrom_lib);
        
    end
    
    % add selected chromosomes to the chromosomes library
    chrom_lib = [chrom_lib;chrom_eval];
    
    % evaluation of offsprings
    crit_eval = model_crit(X_train,X_test,class_train,class_test,chrom_eval,rep_model,settings,opt_fun,ns_bank,ep_bank)';
    
    % new population
    chrom_new=[chrom;chrom_eval];
    crit_new =[crit;crit_eval];

    % sorting new chromosoms
    [sorted_crit_new,ind_sort]=sort(-crit_new);
    chrom_new=chrom_new(ind_sort,:); % sorting chromosoms
    crit_new=-sorted_crit_new;

    % cutout last two (death of two last chromosom)
    chrom=chrom_new(1:chr,:);
    crit =crit_new(1:chr,:);
    
    eval_count = eval_count + 2;
    if eval_count >= maxeval
        doeval = 0;
    end
    
end

display_best_chrom(chrom,crit,ns_bank,ep_bank,'after evolution')

gaset.chr = chr; % number of chromosomes
gaset.gnm = gnm; % number of gens
gaset.probmut   = probmut; % probability of mutation 
gaset.probcross = probcross; % probability of cross-over
gaset.maxeval   = maxeval; % maximum evalution repetition
gaset.maxfreq   = maxfreq; % maximum repetition-frequency of best chromosom
gaset.rep_model = rep_model; % repetitions of SOM model


% -------------------------------------------------------------------------
function chrom_status = chrom_check(chrom_tmp,chrom)

if sum(chrom_tmp(1:3))>0 && sum(chrom_tmp(4:6))>0 && ~ismember(chrom_tmp,chrom,'rows')
    chrom_status ='ok';
else
    chrom_status ='no';
end


% -------------------------------------------------------------------------
function crit = model_crit(X_train,X_test,class_train,class_test,chrom,rep_model,settings,opt_fun,ns_bank,ep_bank)

method = settings.net_type;
topol = settings.topol;
bound = settings.bound;
for i=1:size(chrom,1)
    [ns,ep] = opt_decode(chrom(i,:),ns_bank,ep_bank);
    settings.nsize  = ns;
    settings.epochs = ep;
    settings.show_bar = 2;
    for k=1:rep_model
        if strcmp(method,'cpann')
            model = model_cpann(X_train,class_train,settings);
        elseif strcmp(method,'xyf')
            model = model_xyf(X_train,class_train,settings);
        elseif strcmp(method,'skn')
            model = model_skn(X_train,class_train,settings);
        end
        NER_train(i,k) = model.res.class_param.ner;
        pred = pred_cpann(X_test,model);
        test_class_param = cpann_class_param(pred.class_pred,class_test);
        NER_test(i,k) = test_class_param.ner;
    end
    if opt_fun == 1
        crit(i)= mean(NER_test(i,:))*(1 - abs(mean(NER_train(i,:)) - mean(NER_test(i,:))));
    else
        crit(i)= mean(NER_test(i,:));
    end
end


% -------------------------------------------------------------------------
function eval_id = select_chrom(crit)

cumcrit = cumsum(crit);
goon = 1;
while goon
    k = rand*cumcrit(length(crit));
    lower = find(cumcrit < k);
    if isempty(lower)
        eval_id(1) = 1;
    else
        eval_id(1) = lower(end);
    end
    k = rand*cumcrit(length(crit));
    lower = find(cumcrit < k);
    if isempty(lower)
        eval_id(2) = 1;
    else
        eval_id(2) = lower(end);
    end
    if eval_id(1) ~= eval_id(2)
        goon = 0;
    end   
end


% -------------------------------------------------------------------------
function [ns,ep] = opt_decode(chrom,ns_bank,ep_bank)

% Decode network settings from binary to normal
ep = ep_bank(sum(chrom(4:6).*2.^[0 1 2]));
ns = ns_bank(sum(chrom(1:3).*2.^[0 1 2]));


% -------------------------------------------------------------------------
function display_best_chrom(chrom,crit,ns_bank,ep_bank,initial_str)

best_chrom = chrom(1,:);
[ns,ep] = opt_decode(best_chrom,ns_bank,ep_bank);
disp([initial_str ' - best optimisation value: ' num2str(crit(1)) ' - size: ' num2str(ns) ' - epochs: ' num2str(ep)]);