function Z=rhgz(Z,F,allXa,opts)

allview=size(Z,3);
DF=EuDist2(F,F,0);
P=repmat(0.5*DF,[1,1,allview]);
nnn=size(DF,1);
for k=1:allview
    Xa=allXa{k};
    tempZ=Z(:,:,k);
    
    if opts{k}.zz==1 
        for i=1:nnn
            X_1 = Xa - (Xa*tempZ - Xa(:, i)*tempZ(i, :));
            v = opts{k}.gamma*X_1'*Xa(:, i)/(opts{k}.gamma*Xa(:, i)'*Xa(:, i)+eps);
            temp = (opts{k}.alpha*P(:,i,k)'+opts{k}.lam)/(2*(opts{k}.gamma*Xa(:, i)'*Xa(:, i)+eps));
            tempZ(i,:)=min(0,v'+temp)+max(0,v'-temp);
        end       
    else 
        for i=1:nnn
            X_1 = Xa - (Xa*tempZ - Xa(:, i)*tempZ(i, :));
            v = opts{k}.gamma*X_1'*Xa(:, i)/(opts{k}.gamma*Xa(:, i)'*Xa(:, i)+opts{k}.lam);
            temp = opts{k}.alpha*P(:,i,k)'/(2*(opts{k}.gamma*Xa(:, i)'*Xa(:, i)+opts{k}.lam));
            tempZ(i,:)=min(0,v'+temp)+max(0,v'-temp);
        end
    end
    
    Z(:,:,k)=tempZ;
    
end

