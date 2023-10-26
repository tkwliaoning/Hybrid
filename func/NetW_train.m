function [net, opts] = NetW_train(X, net, opts)

N = size(X,2);

dW    = cell(1,net.nlayer); 
db    = cell(1,net.nlayer); 



Z    = cell(1,net.nlayer); 
H    = cell(1,net.nlayer);  
H{1} = X;
clear X;



for i = 2:net.nlayer
    dW{i} = zeros(size(net.W{1,i}));
    db{i} = zeros(size(net.b{1,i}));
    [Z{i}, H{i}, net] = feedforward(H{i-1}, net.W{1,i}, net.b{1,i}, net, net.actfun{i-1});%
end



iter_ind = 1;

pos = 1;
for i =1:opts.iter
    m_order = randperm(N); 
    for j = 1:N
        
        idx = m_order(j);
        
        if j > 1
            for k = 2:net.nlayer
                [Z{k}(:,idx), H{k}(:,idx)] = feedforward(H{k-1}(:,idx), net.W{iter_ind,k}, net.b{iter_ind,k}, net, net.actfun{k-1});
            end
        end
       
        for k = net.nlayer:-1:2
            
            
            if net.tt==1
                if k == net.nlayer
                    [Lambda{k}] = sensitivity_embed_top(Z{k}(:,idx), H{k}, idx, net, net.actfun(k-1));
                else
                    [Lambda{k}] = sensitivity_embed_m(net.W{iter_ind,k+1}, Lambda{k+1}, Z{k}(:,idx), net, net.actfun(k-1));
                end
            end
            
            if k == net.nlayer
                [Theta{k}] = sensitivity_tang_top(Z{k}(:,idx), H{k}, idx, net, opts, net.actfun(k-1));
            else
                [Theta{k}] = sensitivity_tang_m(net.W{iter_ind,k+1}, Theta{k+1}, Z{k}(:,idx), net, net.actfun(k-1));
            end
            
            if net.tt==1
                db{k} = 2*opts.beta*Lambda{k}+2*opts.beta*Theta{k};
            else
                db{k} = 2*opts.beta*Theta{k};
            end
            dW{k} = db{k}*H{k-1}(:,idx)';
           
            
            net.W{iter_ind,k} = net.W{iter_ind,k} - opts.mu * dW{k};
            net.b{iter_ind,k} = net.b{iter_ind,k} - opts.mu * db{k};
        end
        for k = 2:net.nlayer
            [Z{k}, H{k}] = feedforward(H{k-1}, net.W{iter_ind,k}, net.b{iter_ind,k}, net, net.actfun{k-1});%
        end
        
        
        net.obj_engy(pos) = energy_cal(net, opts, H);
        if ~mod(pos,100)
            fprintf(' | the %5d-th update: | Energy is about %4.4f\n', pos, net.obj_engy(pos));
        end
        if i > ceil(0.5*opts.iter) && pos > 1 && ((abs(net.obj_engy(pos) - net.obj_engy(pos-1)) < opts.error))
            fprintf('convergent at the %d-th update (%d epoch)\n', pos, i);
            return;
        end
        if ~mod(pos,opts.updateNo) && opts.iter > 1 && iter_ind<opts.iter*opts.updateNo
            for k = 1:net.nlayer
                net.W{iter_ind+1,k} = net.W{iter_ind,k};
                net.b{iter_ind+1,k} = net.b{iter_ind,k};
            end
            iter_ind = iter_ind + 1;
            fprintf('                  *  the %2d-th (W, b) is stored!\n', iter_ind-1);
        end
        pos = pos + 1;
    end
end
