function C = opt_eval(opt_res,do_plot)

% opt_eval reads the results of the optimisation performed by means of GAs and makes a polot (optional)
% 
% C = opt_eval(opt_res,do_plot);
% 
% input:
% opt_res       structure containing optimisation results produced by opt_model
% do_plot       id do_plot is 1, a bubble plot representing the
%               optimisation results is made
%
% output:
% C             is a matrix containing the optimisation results. 
%               Each row of this matrix represent an architecture, 
%               the first columns collects the number of neurons
%               the second column collects the number of epochs
%               the third column collects the frequency of selection in the final GA populations
%               the fourth column collects the average of the optimisation criteria
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

chrom = opt_res.chrom;
crit = opt_res.crit;
num_runs = length(chrom);
ns_bank = opt_res.settings.ns_bank;
ep_bank = opt_res.settings.ep_bank;
add_label = 1;

% adds all the final populations
chrom_tot = [];
crit_tot  = [];
for k = 1:num_runs
    chrom_tot = [chrom_tot; chrom{k}];
    crit_tot  = [crit_tot; crit{k}];
end

% decode size and epochs
for k = 1:size(chrom_tot,1)
    [ep,ns] = opt_decode_2(chrom_tot(k,:),ns_bank,ep_bank);
    chrom_tot_tmp(k,1) = ns;
    chrom_tot_tmp(k,2) = ep;
    chrom_tot_tmp(k,3) = crit_tot(k);
end
chrom_tot = chrom_tot_tmp;

% find equal models
cnt = 0;
for n =1:length(ns_bank)
    ns = ns_bank(n);
    for e =1:length(ep_bank)
        cnt = cnt + 1;
        ep = ep_bank(e);
        in = find(chrom_tot(:,1) == ns & chrom_tot(:,2) == ep);
        % save size, epochs, frequency and mean of opitisation criteria
        C(cnt,1) = ns; 
        C(cnt,2) = ep; 
        C(cnt,3) = length(in)/num_runs;
        if length(in) > 0
            C(cnt,4) = mean(chrom_tot(in,3)); 
        else
            C(cnt,4) = 0; 
        end
    end
end

% delete architectures never selected and sort with frequency and then criteria
in = find(C(:,3) > 0);
C = C(in,:);
[n,w] = sort(-C(:,3));
C = C(w,:);
for k=1:size(C,1)
    infreq = C(k,3);
    in = find(C(:,3) == infreq);
    Ctmp = C(in,:);
    [n,w] = sort(-Ctmp(:,4));
    C(in,:) = Ctmp(w,:);
end

% do bubble plot, starting from big sizes
if do_plot
    opt_bubbleplot(C,ns_bank,ep_bank,1,0)
end

% -------------------------------------------------------------------------
function [ep,ns] = opt_decode_2(chrom,ns_bank,ep_bank)

% Decode network settings from binary to normal
ep = ep_bank(sum(chrom(4:6).*2.^[0 1 2]));
ns = ns_bank(sum(chrom(1:3).*2.^[0 1 2]));

% -------------------------------------------------------------------------
function settings = opt_decode(chrom,method,ns_bank,ep_bank)

% Decode network settings from binary to normal
settings          = som_settings(method);
settings.show_bar = 2;

settings.epochs   = ep_bank(sum(chrom(4:6).*2.^[0 1 2]));
settings.nsize    = ns_bank(sum(chrom(1:3).*2.^[0 1 2]));