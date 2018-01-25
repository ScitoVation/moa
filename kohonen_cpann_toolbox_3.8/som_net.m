function [net,count_epo] = som_net(X,settings,class);

% som_net calculates the Kohonen map weights for
% unsupervised kohonen and SKNs, and also the output weights for CPANNs and XYFs if class is defined
%
% net = som_model(X,settings,class)
%
% input:
%   X           data [n x p]
%   settings    setting structure
%
% optional input, only for CPANNs:
%   class       class vector [n x 1]
% 
% output:
%   net         structure containing all the map information (used settings 
%               and calculated weights [size x size x p]
%   count_epo   effective number of training epochs, depends on
%               interruption due to the waitbar
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio & Mahdi Vasighi
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm
%

net_type = settings.net_type;
nsize    = settings.nsize;
init     = settings.init;
nobj     = size(X,1);
nvar     = size(X,2);
display_mod = 10;  % display epochs every display_mod
start_epoch = 1;
end_epoch = settings.epochs;

% learning rate proportional to epochs ('to_epo') or epochs*samples ('to_epoobj'), defualt = 'to_epo'
settings.a_chg = 'to_epo';

% initializes kohonen weights
if strcmp(init,'random')
    W = rand(nsize, nsize, size(X,2)).*0.8 + 0.1;   
    W = reshape(permute(W,[2 1 3]),[nsize*nsize nvar]);
else
    W = som_initweights(X,nsize);
end

% prepare waitbar
if isfield(settings,'show_bar_text')
    show_bar_text = settings.show_bar_text;
else
    show_bar_text = 'Fitting model, please wait...';
end
if settings.show_bar == 1
    hwait = waitbar(0,show_bar_text,'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(hwait,'canceling',0)
elseif settings.show_bar == 0
    disp('training net...')
end

if strcmpi(net_type,'cpann') || strcmpi(net_type,'xyf')
    in_out = zeros(size(class,1),max(class));
    for i=1:size(class,1); in_out(i,class(i)) = 1; end;
    W_out = ones(nsize, nsize, size(in_out,2)).*(1/max(class));
    W_out = reshape(permute(W_out,[2 1 3]),[nsize*nsize size(in_out,2)]);
else
    in_out = NaN;
    W_out  = NaN;
end

% prepeare conditions
if strcmpi(settings.topol,'square'); topol = 1; else; topol = 0; end
if strcmpi(settings.bound,'toroidal'); bound = 1; else; bound = 0; end
alfa  = 1;
alfa_inc = alfa/end_epoch;
winner = zeros(size(X,1),1);
% calculates parameetrs for updating the weights
[U,Dm] = som_updateparameters(settings,topol,bound,start_epoch,end_epoch);

for e = start_epoch:end_epoch
    if settings.show_bar == 1
        if getappdata(hwait,'canceling')
            break
        end
        waitbar(e/end_epoch)
    elseif settings.show_bar == 0 & mod(e,display_mod) == 0
        disp(['training epochs: ' num2str(e) ' of ' num2str(end_epoch)])
    end
    winner_prev = winner;
    if strcmp(settings.training,'batch')
        % batch training
        Xin = X;
        where = isnan(Xin);
        Xin(find(where)) = 0;
        [W,W_out,winner] = som_batch(nobj,Xin,net_type,in_out,W,W_out,alfa,e,U);        
    else
        % sequential training
        [W,W_out,winner] = som_sequential(nobj,X,net_type,in_out,W,W_out,alfa,e,U);
    end
    alfa=alfa - alfa_inc;
end
count_epo = e;

% delete waitbar
if settings.show_bar == 1
    delete(hwait)
elseif settings.show_bar == 0
    disp('...training finished')
end
if isfield(settings,'show_bar_text')
    settings = rmfield(settings,'show_bar_text');
end

% readapts W from reshaping
for k=1:nsize
    for j=1:nsize
        ind = som_which_col(k,j,size(W,1));
        W_final(k,j,:) = W(ind,:);
    end
end

% saves results
if strcmpi(net_type,'kohonen')
    net.W = W_final;
end
if strcmpi(net_type,'cpann') || strcmpi(net_type,'xyf')
    net.W = W_final;
    for k=1:nsize
        for j=1:nsize
            ind = som_which_col(k,j,size(W_out,1));
            % normilizes output weights (sum up to 1)
            W_out_final(k,j,:) = W_out(ind,:)/sum(W_out(ind,:));
        end
    end
    net.W_out = W_out_final;
elseif strcmpi(net_type,'skn')
    net.W_out = W_final(:,:,end-max(class)+1:end);
    net.W = W_final(:,:,1:end-max(class));
end
net.settings = settings;

% ------------------------------------------------------------
function [W,W_out,winner] = som_sequential(nobj,X,net_type,in_out,W,W_out,alfa,e,U)

in_order = randperm(nobj);
for i = 1:nobj
    x_in = X(in_order(i),:);
    % calculates winning neuron
    if strcmpi(net_type,'xyf')
        class_in = in_out(in_order(i),:);
        winner(i) = som_winner_xyf(x_in,class_in,W,W_out,alfa);
    else
        winner(i) = som_winner(x_in,W);
    end
    % applies corrections
    W = som_update(x_in,W,winner(i),e,U);
    if strcmpi(net_type,'cpann') || strcmpi(net_type,'xyf')
        class_in = in_out(in_order(i),:);
        W_out = cpann_update(class_in,W_out,winner(i),e,U);
    end
end
winner(in_order) = winner;

% ------------------------------------------------------------
function [W,W_out,winner] = som_batch(nobj,X,net_type,in_out,W,W_out,alfa,e,U)

for i = 1:nobj
    x_in = X(i,:);
    % calculates winning neurons
    if strcmpi(net_type,'xyf')
        class_in  = in_out(i,:);
        winner(i) = som_winner_xyf(x_in,class_in,W,W_out,alfa);
    else
        winner(i) = som_winner(x_in,W);
    end
end

D  = U.update{e};
Di = D(:,winner);
% do the update, for each neuron
% sum all the contributions of each winner neuron weighted by the corresponding input sample
num = Di * X;
% sum all the contributions of each winner neuron
where = logical(ones(size(X,1),size(X,2)));
den = Di*where;
% update neurons with activation higher than nonzero
pos = find(den > 0);
W(pos) = num(pos)./den(pos); 

% update the output layer
if strcmpi(net_type,'cpann') || strcmpi(net_type,'xyf')
    num   = Di*in_out;
    where = logical(ones(size(in_out,1),size(in_out,2)));
    den   = Di*where;
    pos = find(den > 0);
    W_out(pos) = num(pos)./den(pos); 
end

% alternative algorithm for batch training, time expensive
% for n=1:size(W,1)
%     for j=1:size(W,2)
%         num = 0;
%         den = 0;
%         for i=1:size(X,1)
%             win = winner(i);
%             num = num + X(i,j)*D(n,win);
%             den = den + D(n,win);
%         end
%         W(n,j) = num/den;
%     end
% end
