function W = som_initweights(X,nsize)

% som_initweights initializes kohonen weights on the basis of the eigenvectors corresponding 
% to the two largest principal components of input data
%
% W = som_initweights(X,nsize);
%
% input:
%   X           range scaled input data [n x p]
%   nsize       net size
% 
% output:
%   W           kohonen weights [nsize^2 x p]
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm


% covariance matrix
netdim = 2;
me = mean(X);
X_scal = som_pretreatment_data(X,'cent');
C = cov(X_scal);

% take netdim eigenvectors with the greatest eigenvalues
[L,S] = eig(C);
eigval  = diag(S);
[y,ind] = sort(-eigval); 
eigval  = eigval(ind);
L = L(:,ind); 
L = L(:,1:netdim);
eigval = eigval(1:netdim);   

% normalize eigenvectors to unit length 
for i=1:netdim, L(:,i) = (L(:,i) / norm(L(:,i))) * sqrt(eigval(i)); end

% init weights
cnt = 1;
W = me(ones(nsize^2,1),:);
cor = [];
for k=1:nsize
    cor(cnt:cnt + nsize - 1,1) = [0:nsize-1]';
    cor(cnt:cnt + nsize - 1,2) = k - 1;
    cnt = cnt + nsize;
end
for j=1:size(cor,2)
    min_var(j) = min(cor(:,j));
    max_var(j) = max(cor(:,j));
    for i=1:size(cor,1)
        cor(i,j) = (cor(i,j) - min_var(j))/(max_var(j) - min_var(j)); 
    end
end
cor = (cor - 0.5)*2;
for i = 1:nsize^2   
    for j = 1:netdim,    
        W(i,:) = W(i,:) + cor(i,j)*L(:, j)';
    end
end

W(find(W < 0)) = 0;
W(find(W > 1)) = 1;
