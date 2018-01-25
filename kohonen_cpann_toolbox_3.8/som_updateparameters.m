function [U,Dm] = som_updateparameters(settings,topol,bound,start_epoch,end_epoch)

% som_updateparameters calculates parameters needed to update the Kohonen weights
%
% [U,Dm] = som_updateparameters(settings,topol,bound,start_epoch,end_epoch)
%
% input:
%   settings        structure with net settings
%   topol           topology condition (1 is 'square', 2 is 'hexagonal')
%   bound           boundary condition (1 is 'toroidal', 2 is 'normal')
%   start_epoch     epoch to start the training (usually is 1)
%   end_epoch       epoch to stop the training (total number of epochs is end_epoch - start_epoch)
% 
% output:
%   U               array containing the updating parameters for each neuron in each epoch
%   Dm              distance matrix between neurons (neurons x neurons)
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm


nsize = settings.nsize;
% calculates distance matrix of neurons Dm
if  topol==1
    if bound==1
        rings = (1 + (nsize - 1)/2);
        rings = ceil(rings) - 1;
        Dm = zeros(nsize^2,nsize^2);
        for n = 1:nsize^2
            for r = 1:rings
                list = som_find_neigb(n,r,1,nsize);
                Dm(n,list) = r;
                Dm(list,n) = r; 
            end
        end
    else
        Dm = zeros(nsize^2,nsize^2);
        for n = 1:nsize^2
            for r = 1:nsize-1
                list = som_find_neigb(n,r,0,nsize);
                Dm(n,list) = r;
                Dm(list,n) = r; 
            end
        end
    end
else
    if bound==1
        Dm = som_torhexdist(nsize);
    else
        Dm = som_ntorhexdist(nsize);
    end
end
% calculates updating weigths
for e = start_epoch:end_epoch
    rings = (1 + (settings.nsize - 1)/2);
    rings = rings*(end_epoch - e);
    rings = rings/(end_epoch - 1);
    rings = ceil(rings) - 1;
    if rings < 0; rings = 0; end;
    % calculates the changing rate for each neuron in the ring
    if strcmpi(settings.a_chg,'to_epo') % default
        L = (settings.a_max - settings.a_min);
        L = L*(end_epoch - e);
        L = L/(end_epoch - 1) + settings.a_min;
    else
        ind = ((act_epoch - 1)*tot_obj + 1):act_epoch*tot_obj;
        count_ind = ind(act_obj);
        L = (settings.a_max - settings.a_min);
        L = L*(end_epoch*tot_obj - count_ind);
        L = L/(end_epoch*tot_obj - 1) + settings.a_min;
    end
    Dtmp = L*(1 - Dm/(1 + rings));
    Dtmp(find(Dm > rings)) = 0;
    U.update{e} = Dtmp;
    U.ring(e) = rings;
    U.L(e) = L;
end