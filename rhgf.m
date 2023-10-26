function [idx,F]=rhgf(Z,opts,options)

numOfClasses=options.nGroups;

for asd=1:size(Z,3)
    Z(:,:,asd)=Z(:,:,asd)*opts{asd}.alpha;
end

ABSZ=sum(abs(Z),3);
W = (ABSZ+ABSZ')/2;


DN = diag( 1./sqrt(sum(W)+eps) );
L = eye(size(Z,2)) - DN * W * DN;
[U,S,V] = svd(L);
FF = V(:,end-numOfClasses+1:end); 
for i = 1:size(Z,2)
    F(i,:) = FF(i,:) ./ norm(FF(i,:)+eps);
end


if isfield(options,'uni')
    uniform=options.uni;
else
    uniform=0;
end

if uniform~=0
    numofsample=size(Z,2);
    samperc=floor(numofsample/numOfClasses);
    uniidx=randperm(10);
    INI=uniidx(5):samperc:numofsample;
    idx = kmeans(F,numOfClasses,'emptyaction','singleton','Start',F(INI,:),'display','off');
else
    idx=kmeans(F,numOfClasses,'emptyaction','singleton','replicates',200,'display','off');
end



