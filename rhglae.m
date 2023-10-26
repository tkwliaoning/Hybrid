function Xa=rhglae(data,net,opts,Zv)

geshu=size(Zv,2);
III=eye(geshu);
ZZZ=(III-Zv)*(III-Zv)';
if net.tt==1
    net.lap=opts.gamma/opts.beta*ZZZ;
else
    net.lap=net.lap+opts.gamma/opts.beta*ZZZ;
end

[net] = NetW_pretrain(data, net, opts);
fprintf(' * pretraining completed, begin to fine tune!\n');
[net, opts] = NetW_train(data, net, opts);
k = size(net.W,1);
Xa = data;
for j = 2:net.nlayer
    [~, Xa] = feedforward(Xa, net.W{k,j}, net.b{k,j}, net, net.actfun{j-1});
end
