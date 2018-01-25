function [winner,d_min] = som_winner_xyf(x_in,class_in,W,W_out,alfa)

% som_winner_xyf calculates the winner neuron in X-Y fused networks
% (based on euclidean distance adn fused similarity)
%
% winner = som_winner(x_in,W);
%
% input:
%   x_in        sample [1 x p]
%   class_in    class  [1 x number of classes]
%   W           unfolded kohonen weights [size*size x p]
%   W_out       unfolded output weights [size*size x number of classes]
%   alfa        regulates the effect of input and output on fused similarity 
% 
% output:
%   winner      winner neuron
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio & Mahdi Vasighi
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

%Updated in version 3.0 >
if isempty(find(isnan(x_in)==1))
    D_squares_x = (sum(x_in'.^2))'*ones(1,size(W,1));
    D_squares_y = (sum(class_in'.^2))'*ones(1,size(W_out,1));
    D_squares_w = sum(W'.^2);
    D_squares_wo = sum(W_out'.^2);
    D_product_x   = - 2*(x_in*W');
    D_product_y   = - 2*(class_in*W_out');
    
    D_x = (D_squares_x + D_squares_w + D_product_x).^0.5;
    D_y = (D_squares_y + D_squares_wo + D_product_y).^0.5;
    
    D=alfa*D_x+(1-alfa)*D_y;

%Updated in version 3.0 <

    [d_min,winner] = min(D);
else
    d_min = NaN;
    for m = 1:size(W,1)
        dx = dist_calc(x_in,W(m,:));
        %Added in version 3.0 >
        dy = dist_calc(class_in,W_out(m,:));
        d = alfa*dx+(1-alfa)*dy;
        %Added in version 3.0 <
        if isnan(d_min)||d < d_min
            winner = m;
            d_min = d;
        end    
    end
end

%--------------------------------------------
function D = dist_calc(x_1,x_2,dist)

d = (x_1 - x_2).^2;
D = (sum(d(~isnan(d))))^0.5;  