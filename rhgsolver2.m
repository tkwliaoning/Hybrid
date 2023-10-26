function [idx,F] = rhgsolver2(data,net,opts,otheropt)

allview=size(data,2);
nnn=size(data{1},2);
Z=zeros(nnn,nnn,allview);


F=zeros(nnn,otheropt.nGroups);
F(:,1)=1;
idx=ones(nnn,1);
obj=0;
for it=1:otheropt.maxIters
    
    oldobj=obj;
    
    for ijk=1:allview
        Xa{ijk}=rhglae(data{ijk},net{ijk},opts{ijk},Z(:,:,ijk));
    end
    
    for ijk=1:allview
        if net{ijk}.tt==1
            net{ijk}.ta=Xa{ijk}*net{ijk}.tb*inv(net{ijk}.tb'*net{ijk}.tb+eye(size(net{ijk}.tb,2)));
            net{ijk}.tb=Xa{ijk}'*net{ijk}.ta*inv(net{ijk}.ta'*net{ijk}.ta+eye(size(net{ijk}.ta,2)));
        end
    end
    
    Z=rhgz(Z,F,Xa,opts);
    
    [idx,F]=rhgf(Z,opts,otheropt);
    
    alpha=rhg2a(Z,F);
    for ijk=1:allview
        opts{ijk}.alpha=alpha(ijk);
    end
    
  
    obj=0;
    DF=EuDist2(F,F,0);
    PP=0.5*DF;
    for ijk=1:allview
        HH=Xa{ijk};
        ZZ=Z(:,:,ijk);
        if mod(ceil(ijk/2),2)==1
            OBB=norm(ZZ,'fro')^2;
        else
            OBB=sum(sum(abs(ZZ)));
        end
        if net{ijk}.tt==1
            OBA=norm(HH-net{ijk}.ta*net{ijk}.tb');
        else
            OBA=trace(HH*net{ijk}.lap*HH');
        end
        obj=obj+opts{ijk}.beta*OBA+opts{ijk}.gamma*norm(HH-HH*ZZ,'fro')^2+opts{ijk}.lam*OBB+opts{ijk}.alpha*sum(sum(abs(ZZ).*PP))+opts{ijk}.alpha^2;
    end

    convergence=abs(oldobj-obj)/abs(obj);
    if convergence<0.5
        break
    end
end