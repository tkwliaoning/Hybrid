function alpha=rhg2a(Z,F)


for asd=1:size(Z,3)
    ZV=Z(:,:,asd);
    ZZ=0.5*(abs(ZV)+abs(ZV'));
    ZD=diag(sum(ZZ));
    LZ=ZD-ZZ;
    zhif(asd)=trace(F'*LZ*F);
end
zhiH=2*eye(asd);
Aeq=ones(1,asd);
beq=1;
LB=0*ones(asd,1);
UB=Inf*ones(asd,1);
alpha=quadprog(zhiH,zhif,[],[],Aeq,beq,LB,UB);
