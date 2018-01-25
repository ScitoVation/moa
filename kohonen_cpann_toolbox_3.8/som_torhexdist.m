function d = som_torhexdist(nsize)

% som_torhexdist produces the distance matrix for hexagonal topoloy with toroidal bounding
%
% d = som_torhexdist(nsize)
%
% input:
%   nsize       net size (should be an even number)
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

if rem(nsize,2)==0
    hxgrd=som_hex_grid(nsize);
    hxlnk=zeros(nsize^2,nsize^2);

    for wnr=1:nsize^2
        %move right
        rmove=ismember(hxgrd(:,:)',(hxgrd(:,wnr)+[1;0])','rows');

        if isempty(find(rmove)==1)==1
            r_ind=wnr-nsize+1;
        else
            r_ind=wnr+1;
        end

        %move left
        lmove=ismember(hxgrd(:,:)',(hxgrd(:,wnr)-[1;0])','rows');
        if isempty(find(lmove)==1)==1
            l_ind=wnr+nsize-1;
        else
            l_ind=wnr-1;
        end

        %%%move right-top & left-top
        rtmove=ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[0.5;sqrt(1-0.5^2)])')/100,'rows');
        ltmove=ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[-0.5;sqrt(1-0.5^2)])')/100,'rows');

        if isempty(find(rtmove)==1)==1 && isempty(find(ltmove)==1)==1
            if wnr==nsize^2 %last neuron
                rt_ind=1;
            else
                rt_ind=wnr-nsize^2+nsize+1;
            end
            lt_ind=wnr-nsize^2+nsize;
        elseif isempty(find(rtmove)==1)==1 && isempty(find(ltmove)==1)==0
            % at right edge of the net
            rt_ind=wnr+1;
            lt_ind=wnr+nsize;
        elseif isempty(find(rtmove)==1)==0 && isempty(find(ltmove)==1)==1
            % at left edge of the net
            rt_ind=wnr+nsize;
            lt_ind=wnr+2*nsize-1;
        else
            % at middle of the net
            rt_ind=find(rtmove==1);
            lt_ind=find(ltmove==1);
        end

        rdmove=ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[0.5;-sqrt(1-0.5^2)])')/100,'rows');
        ldmove=ismember(ceil(100*hxgrd(:,:)')/100,ceil(100*(hxgrd(:,wnr)+[-0.5;-sqrt(1-0.5^2)])')/100,'rows');

        % at down edge of the net
        if isempty(find(rdmove)==1)==1 && isempty(find(ldmove)==1)==1
    
            rd_ind=wnr+nsize^2-nsize;
            if wnr==1
                ld_ind=nsize^2; %first neuron
            else
                ld_ind=wnr+nsize^2-nsize-1;
            end
    
        % at right edge of the net
        elseif isempty(find(rdmove)==1)==1 && isempty(find(ldmove)==1)==0
 
            rd_ind=wnr-2*nsize+1;
            ld_ind=wnr-nsize;
    
        % at left edge of the net
        elseif isempty(find(rdmove)==1)==0 && isempty(find(ldmove)==1)==1
   
            rd_ind=wnr-nsize;
            ld_ind=wnr-1;
   
        else
            % at middle of the net
            rd_ind=find(rdmove==1);
            ld_ind=find(ldmove==1);
        end

        hxlnk(wnr,[r_ind l_ind rt_ind lt_ind rd_ind ld_ind])=1;
    end

    d = nsize^2*(1-eye(nsize^2,nsize^2));
    found = eye(nsize^2,nsize^2);
    
    for i=1:nsize^2
        nextfound = (found*hxlnk) + found;
        nextfound(find(nextfound > 0)) = 1;
        newfound = nextfound.*(1-found);
        ind = find(newfound);
        if isempty(ind)
            break;
        end
        d(ind) = i;
        found = nextfound;
    end
else
    error('Input Error! input should be an even integer.')
end


% -------------------------------------------------------------
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
% version 3.2 - May 2010
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
