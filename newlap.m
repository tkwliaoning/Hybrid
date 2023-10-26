function [LAP,new_data]=newlap(X,options)

new_data=procx(X,options);

for i = 1:size(X,2)
    if i ==1
        tmp = sparsecode_func(new_data(:,i), new_data(:, i+1:end), options.gamma, options.tolerance);
        coef(:,i) = [0; tmp];
    else
        tmp = sparsecode_func(new_data(:,i), [new_data(:, 1:i-1) new_data(:, i+1:end)], options.gamma, options.tolerance);
        coef(:,i) = [tmp(1:i-1); 0; tmp(i:end)];
    end
end

LAP = BuildAdjacency(coef,0);
