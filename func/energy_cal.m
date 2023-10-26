function J = energy_cal(net,opts, H)

J=opts.beta*trace(H{net.nlayer}*net.lap*H{net.nlayer}');

if net.tt==1
    J=J+opts.beta*norm(H{net.nlayer}-net.ta*net.tb','fro')^2;
end



