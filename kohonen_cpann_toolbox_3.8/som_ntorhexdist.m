function d = som_ntorhexdist(nsize)

% som_ntorhexdist produces the distance matrix for hexagonal topoloy with not-toroidal bounding
%
% d = som_ntorhexdist(nsize);
%
% input:
%   nsize       net size
% 
% output:
%   d           distance matrix (nsize^2 x nsize^2)
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% Kohonen and CP-ANN toolbox
% version 3.8 - January 2016
% Mahdi Vasighi
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

hxgrd=som_hex_grid(nsize);
hxlnk=zeros(nsize^2,nsize^2);

for wnr=1:nsize^2

   r_ind=find(ismember(hxgrd(:,:)',(hxgrd(:,wnr)+[1;0])','rows')==1);%moving right
   l_ind=find(ismember(hxgrd(:,:)',(hxgrd(:,wnr)-[1;0])','rows')==1);%moving left
   rt_ind=find(ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[0.5;sqrt(1-0.5^2)])')/100,'rows')==1);%moving right top
   lt_ind=find(ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[-0.5;sqrt(1-0.5^2)])')/100,'rows')==1);%moving left top
   rd_ind=find(ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[0.5;-sqrt(1-0.5^2)])')/100,'rows')==1);%moving right down
   ld_ind=find(ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[-0.5;-sqrt(1-0.5^2)])')/100,'rows')==1);%moving left down

   hxlnk(wnr,[r_ind l_ind rt_ind lt_ind rd_ind ld_ind])=1; %indexing
end

% Distance matrix calculation
d = nsize^2*(1-eye(nsize^2,nsize^2));
found = eye(nsize^2,nsize^2);
for i=1:nsize^2
  nextfound = (found*hxlnk) | found;
  newfound = nextfound & ~found;
  ind = find(newfound);
  
  if length(ind) == 0 
    break;
  end
  d(ind) = i;
  found = nextfound;
end
