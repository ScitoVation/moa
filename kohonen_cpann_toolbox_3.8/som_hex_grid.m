function hxgrd=som_hex_grid(nsize)

% hex_grid produces hexagonal grid coordinates
%
% hxgrd=som_hex_grid(nsize)
%
% input:
%   nsize       net size (should be an even number)
% 
% output:
%   hxgrd       grid coordination (2 x nsize^2)
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Mahdi Vasighi
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

shft=0.5;
row_inc=sqrt(1-shft^2);
x_cord=repmat([0:nsize-1],nsize,1)';

for i=1:nsize
    if rem(i,2)==0
        x_cord(:,i)=x_cord(:,i)+shft;
    end
end

y_cord=repmat([0:row_inc:row_inc*(nsize-1)]',1,nsize)';
hxgrd=[x_cord(:),y_cord(:)]';