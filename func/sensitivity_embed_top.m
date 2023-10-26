function [Lambda] = sensitivity_embed_top(z, H, idx, net, varargin)


if  length(varargin)==0 
    sd = 1 - tanh(z).^2;  
else
    switch cell2mat(varargin{1})
        case 'tanh'
            sd = 1 - tanh(z).^2;
        case 'sigmoid'
            tmp = 1 ./ (1 + exp(-z));
            sd = tmp .* (1-tmp);
        case 'nssigmoid'
            [~, sd] = nonsaturate_sigmoid_act(z);
        case 'relu'
            alpha = net.alpha;
            sd = 1./(1+exp(-alpha*z));
        otherwise
            fprintf('The specified activation fun (%s) is not support!\n', varargin);
    end
end


temp=net.ta*net.tb';
Lambda = (H(:,idx)-temp(:,idx)).* sd;


