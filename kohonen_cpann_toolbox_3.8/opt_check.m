function errortype = opt_check(topol,bound,ns_bank,ep_bank)

% multiple checks for otpimisation inputs
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
errortype = check_banks(errortype,topol,bound,ns_bank,ep_bank);

% -------------------------------------------------------------------------
function errortype = check_banks(errortype,topol,bound,ns_bank,ep_bank)

if  length(find(ns_bank < 1))                 
    errortype = 'input error: the neuron number in the size bank must be higher than 1';
    return
end

if  length(find(ep_bank < 1))                
    errortype = 'input error: the epcoh number in the epoch bank must be higher than 1';
    return
end

if strcmp(topol,'hexagonal') & strcmp(bound,'toroidal') 
    for k=1:length(ep_bank)
        if rem(ep_bank(k),2) > 0   
            errortype = 'input error: if topology is hexagonal and boundary condition is toroidal, the number of neurons for each side of the map must be an even number';
            return
        end
    end
end
    