function list_of_neurons = som_find_neigb(winner,r,bound,nsize)

% som_find_neigb looks for the neurons to be updated
%
% list_of_neurons = som_find_neigb(winner,r,bound,nsize);
%
% input:
%   winner      winner neuron
%   r           ring of neuron to be updated
%   bound       type of bound ('toroidal' or 'normal')
%   nsize       net size
% 
% output:
%   list_of_neurons     list of neurons to be updated
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm


% check position
on_col = mod(winner -1,nsize) + 1;
on_row = ceil(winner/nsize);

list_of_neurons = [];
% up
cent_point_in_row = winner - nsize*r;
add_up = [cent_point_in_row - r:cent_point_in_row + r];

% down
cent_point_in_row = winner + nsize*r;
add_down = [cent_point_in_row - r:cent_point_in_row + r];

% left
cent_point_in_col = winner - r;
add_left = [cent_point_in_col - r*nsize:nsize:cent_point_in_col + r*nsize];

% right
cent_point_in_col = winner + r;
add_right = [cent_point_in_col - r*nsize:nsize:cent_point_in_col + r*nsize];

if bound == 1  % toroidal
    % out on right
    if on_col + r > nsize
        add_up(end - (on_col + r - nsize) + 1:end) = add_up(end - (on_col + r - nsize) + 1:end) - nsize;
        add_down(end - (on_col + r - nsize) + 1:end) = add_down(end - (on_col + r - nsize) + 1:end) - nsize;
        add_right = add_right - nsize;
    end
    % out on left
    if on_col - r < 1
        add_up(1:(abs(on_col - r) + 1)) = add_up(1:(abs(on_col - r) + 1)) + nsize;
        add_down(1:(abs(on_col - r) + 1)) = add_down(1:(abs(on_col - r) + 1)) + nsize;
        add_left = add_left + nsize;
    end
    % out up
    if on_row - r < 1
        add_left(1:(abs(on_row - r) + 1)) = add_left(1:(abs(on_row - r) + 1)) + nsize^2;
        add_right(1:(abs(on_row - r) + 1)) = add_right(1:(abs(on_row - r) + 1)) + nsize^2;
        add_up = add_up + nsize^2;
    end      
    % out down
    if on_row + r > nsize
        add_left(end - (on_row + r - nsize) + 1:end) = add_left(end - (on_row + r - nsize) + 1:end) - nsize^2;
        add_right(end - (on_row + r - nsize) + 1:end) = add_right(end - (on_row + r - nsize) + 1:end) - nsize^2;
        add_down = add_down - nsize^2;
    end
    add_right = add_right(2:end-1);
    add_left  = add_left(2:end-1);    
else
    add_right = add_right(2:end-1);
    add_left  = add_left(2:end-1);
    % out on right
    if on_col + r > nsize
        add_up = add_up(1:end - (on_col + r - nsize));
        add_down = add_down(1:end - (on_col + r - nsize));
        add_right = [];
    end
    % out on left
    if on_col - r < 1
        add_up = add_up(abs(on_col - r) + 2:end);
        add_down = add_down(abs(on_col - r) + 2:end);
        add_left = [];
    end    
    % out up
    if on_row - r < 1
        if r > 1; add_left = add_left(abs(on_row - r) + 1:end); end;
        if r > 1; add_right = add_right(abs(on_row - r) + 1:end); end;
        add_up = [];
    end
    % out down
    if on_row + r > nsize
        if r > 1; add_left = add_left(1:end - (r + on_row - nsize - 1)); end;
        if r > 1; add_right = add_right(1:end - (r + on_row - nsize - 1)); end;
        add_down = [];
    end    
end

list_of_neurons = [add_up add_down add_left add_right];