function [winner,d_min] = som_winner(x_in,W)

% som_winner calculates the winner neuron 
% (based on euclidean distance)
%
% winner = som_winner(x_in,W);
%
% input:
%   x_in        sample [1 x p]
%   W           unfolded kohonen weights [size*size x p]
% 
% output:
%   winner      winner neuron
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

if length(find(isnan(x_in)))== 0
    Dx = W - x_in(ones(size(W,1),1),logical(ones(1,length(x_in))));
    [d_min,winner] = min(sum((Dx.^2)'));
else
    d_min = NaN;
    for m = 1:size(W,1)
        d = dist_calc(x_in,W(m,:));
        if isnan(d_min)|d < d_min
            winner = m;
            d_min = d;
        end    
    end
end

%--------------------------------------------
function D = dist_calc(x_1,x_2,dist);

d = (x_1 - x_2).^2;
D = (sum(d(~isnan(d))))^0.5;  