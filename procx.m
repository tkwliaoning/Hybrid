function newdata=procx(X,options)

if ~isfield(options,'flag')
   options.flag=1; 
end

if options.flag==1
    t=options.t;
    procdim=options.procdim;
    
    [U,S,V] = svd(X',0);
    PX = U(:,1:procdim)';
    NX=PX;
    
    for r=1:size(NX,2)
        NX(:,r)=NX(:,r)/(norm(NX(:,r))+eps);
    end

    
    
    MX = (NX'*NX).^2;
    thta = mean(mean(1-MX));
    KK = exp(-(1-MX)/(thta*t));
    
else  
    KK=X';  
end

pcaoptions.bPCA=1;
pcaoptions.PCARatio= options.ratio;
[eigvector, eigvalue, meanData, new_data] = PCA(KK, pcaoptions);
newdata=new_data';
newdata=newdata/max(max(abs(newdata)));

