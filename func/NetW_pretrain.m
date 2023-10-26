function net = NetW_pretrain(X, net, opts)



data = X;
for i = 1:(net.nlayer-1)
    fprintf('\n  | pretraining the %d-th NN\n', i);


    mnet.neuron    = [net.neuron(i) net.neuron(i+1)];
    mnet.nlayer    = length(mnet.neuron);
    mnet.obj_engy  = zeros(max(opts.iter),1);
    mnet.actfun{1}  = net.actfun{i};
    
    if net.tt==1
        tempta=orth(rand(mnet.neuron(mnet.nlayer)));
        mnet.ta=tempta(:,1:size(net.tb,2));
        mnet.tb=net.tb;
    end
    mnet.tt=net.tt;
    mnet.lap=net.lap;

    for j = 2:mnet.nlayer
        [mnet.W{1,j}, mnet.b{1,j}]= InitNet(mnet.neuron(j), mnet.neuron(j-1), opts.initmod);
    end
    clear j;
    [mnet, opts] = NetW_train(data, mnet, opts);
    [~, data] = feedforward(data, mnet.W{end,2}, mnet.b{end,2}, mnet, mnet.actfun{1});% encode
    net.W{i+1} = mnet.W{end,2};
    net.b{i+1} = mnet.b{end,2};
   
    net.AEobj_engy{i} = mnet.obj_engy;
    clear mnet;
end
