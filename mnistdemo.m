clear
clc
addpath('./func/');



jjj=0;


load('mnist.mat')
data=X;
gnd=double(gt);
clear X gt
numOfClasses=length(unique(gnd));

otheropt.maxIters=10; 
otheropt.nGroups=numOfClasses;
opts.initmod   = 1;       
opts.mu     = [0.0001]; 
opts.iter      = [10];    
opts.updateNo  = [100];  
opts.error     = 1e-3;   
options.gamma=0.001;
options.tolerance=0.001;
options.ratio=1;
options.t=0.1;
options.procdim=9;
lapoptions{1}=options;
options.gamma=0.01;
options.tolerance=0.0001;
options.flag=0;
options.ratio=1;
lapoptions{2}=options;

abc=1;
X=full(data{abc});
[tempS,new_data]=newlap(X,lapoptions{abc});
LAP=diag(sum(tempS))-tempS;
data{abc}=new_data;
net.lap=LAP;
net.tt=0; 
opts.beta   = [0.01];
opts.alpha  = 0;
opts.gamma = 5;
opts.lam  = 0.001;
opts.zz=0; 
net.neuron         = [size(data{abc},1) 500 200]; 
net.nlayer         = length(net.neuron);    
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'}; 
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

abc=2;
X=full(data{abc});
[tempS,new_data]=newlap(X,lapoptions{abc});
LAP=diag(sum(tempS))-tempS;
data{abc}=new_data;
net.lap=LAP;
net.tt=0; 
opts.beta   = 0.01;
opts.gamma = 5;
opts.alpha  = 0;
opts.lam  = 0.001;
opts.zz=0; 
net.neuron         = [size(data{abc},1) 120 80]; 
net.nlayer         = length(net.neuron);   
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'}; 
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

abc=3;
data{abc}=data{1};
net.lap=allnet{1}.lap;
net.tt=0;
opts.beta   = 100;
opts.alpha  = 0;
opts.gamma = 20;
opts.lam  = 0.1;
opts.zz=1; 
net.neuron         = [size(data{abc},1) 500 200];
net.nlayer         = length(net.neuron);    
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'}; 
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

abc=4;
data{abc}=data{2};
net.lap=allnet{2}.lap;
net.tt=0; 
opts.beta   = [0.01];
opts.alpha  = 0;
opts.gamma = 5;
opts.lam  = 0.001;
opts.zz=1; 
net.neuron         = [size(data{abc},1) 120 80];
net.nlayer         = length(net.neuron); 
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'};
net.alpha          = 10;
allnet{abc}=net;
allopts{abc}=opts;

abc=5;
data{abc}=data{1};
net.tt=1; 
net.tb=ones(size(data{abc},2),otheropt.nGroups);
opts.beta   = 0.01;
opts.alpha  = 0;
opts.gamma = 5;
opts.lam  = 0.001;
opts.zz=0;
net.neuron         = [size(data{abc},1) 500 200]; 
net.nlayer         = length(net.neuron);   
tempta=orth(rand(net.neuron(net.nlayer)));
net.ta=tempta(:,1:otheropt.nGroups);
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'};
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

abc=6;
data{abc}=data{2};
net.tt=1; 
net.tb=ones(size(data{abc},2),otheropt.nGroups);
opts.beta   = 0.01;
opts.alpha  = 0;
opts.gamma = 5;
opts.lam  = 0.001;
opts.zz=0; 
net.neuron         = [size(data{abc},1) 120 80]; 
net.nlayer         = length(net.neuron);    
tempta=orth(rand(net.neuron(net.nlayer)));
net.ta=tempta(:,1:otheropt.nGroups);
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'}; 
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

abc=7;
data{abc}=data{1};
net.tt=1;
net.tb=ones(size(data{abc},2),otheropt.nGroups);
opts.beta   = 0.01;
opts.alpha  = 0;
opts.gamma = 5;
opts.lam  = 0.001;
opts.zz=1; 
net.neuron         = [size(data{abc},1) 500 200]; 
net.nlayer         = length(net.neuron);   
tempta=orth(rand(net.neuron(net.nlayer)));
net.ta=tempta(:,1:otheropt.nGroups);
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'}; 
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

abc=8;
data{abc}=data{2};
net.tt=1; 
net.tb=ones(size(data{abc},2),otheropt.nGroups);
opts.beta   = 0.01;
opts.alpha  = 0;
opts.gamma = 5;
opts.lam  = 0.001;
opts.zz=1; 
net.neuron         = [size(data{abc},1) 120 80]; 
net.nlayer         = length(net.neuron);   
tempta=orth(rand(net.neuron(net.nlayer)));
net.ta=tempta(:,1:otheropt.nGroups);
net.obj_engy       = zeros(max(opts.iter),1);
net.actfun         = {'tanh', 'tanh'}; 
net.alpha          = 10; 
allnet{abc}=net;
allopts{abc}=opts;

[idx,F] = rhgsolver2(data,allnet,allopts,otheropt);

jjj=jjj+1;

result=ClusteringMeasure(gnd, idx);
measure(1,jjj)=result(1);
measure(2,jjj)=result(2);
measure(3,jjj)=result(3);
[xxxx,yyyy,meiyonga,meiyongb]=RandIndex(gnd, idx);
measure(4,jjj)=xxxx;
[fscore,p,r] = compute_f(gnd, idx);
measure(5,jjj)=fscore;
measure(6,jjj)=p;
measure(7,jjj)=r;
measure(8,jjj)=yyyy;