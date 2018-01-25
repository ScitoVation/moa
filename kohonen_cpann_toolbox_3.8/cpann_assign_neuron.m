function neurons_ass = cpann_assign_neuron(W_out,method,thr)

% cpann_assign_neuron assigns each neuron to a class
%
% neurons_ass = cpann_assign_neuron(W_out,method,thr);
%
% input:
%   W_out           unfolded CPANN weights [size*size x c]
%   method          method of assignation
%                   if method = 1 -> maximum weigth
%                   if method = 2 -> maximum difference over threshold
%                   if method = 3 -> maximum weigth over threshold
%                   if method = 4 -> smoothed weight over threshold
%   thr             threshold for method 2 and 3
% 
% output:
%   neurons_ass     assignation of neurons [size x size]
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

smooth_par = 1.5;

for k = 1:size(W_out,1)
    for j = 1:size(W_out,2)
        if method == 1      % maximum weight
            [m,where] = max(W_out(k,j,:));
            neurons_ass(k,j) = where;
        elseif method == 2  % maximum difference with threshold 
            [val,pos] = sort(squeeze(W_out(k,j,:)));
            delta_class = val(end) - val(end - 1);
            if delta_class > thr(2)
                neurons_ass(k,j) = pos(end);
            else
                neurons_ass(k,j) = 0;
            end
        elseif method == 3  % maximum weight with threshold 
            [m,where] = max(W_out(k,j,:));
            if m > thr(3)
                neurons_ass(k,j) = where;
            else
                neurons_ass(k,j) = 0;
            end    
        elseif method == 4  % smoothed weight over threshold
            [m,where] = smoothw(W_out(k,j,:),smooth_par);
            if m > thr(4)
                neurons_ass(k,j) = where;
            else
                neurons_ass(k,j) = 0;
            end
        end    
    end
end

% -------------------------------------------------------------
function [m,where] = smoothw(w,s);
[wmax,wheremax] = max(w);
m = 1;
for g=1:length(w)
    if g ~= wheremax
        d = (w(g)/wmax)^s;
        m = m*(1 - d);
    end
end
m = wmax*(m)^(1/(length(w) - 1));
where = wheremax;