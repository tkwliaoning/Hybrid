function D = EuDist2(fea_a,fea_b,bSqrt)
% 计算两个矩阵的欧几里德距离矩阵，两个矩阵的欧几里德距离是这样定义的：
% 对于两个列数相同的矩阵A和B，把A，B都看成向量集，每一行是一个向量。则A和B的欧几
% 里德距离是个矩阵，这个矩阵的第i行第j列是A的第i个行向量与B的第j个行向量的2范数。
% 对于矩阵A和A的欧几里德距离，对角线元素为0。
% 下面的代码中bSqrt控制是否开方。为1是开方，默认是1，不过不是1，不开方。
% Euclidean Distance matrix
%   D = EuDist(fea_a,fea_b)
%   fea_a:    nSample_a * nFeature
%   fea_b:    nSample_b * nFeature
%   D:      nSample_a * nSample_a
%       or  nSample_a * nSample_b


if ~exist('bSqrt','var')
    bSqrt = 1;
end


if (~exist('fea_b','var')) | isempty(fea_b)
    [nSmp, nFea] = size(fea_a);

    aa = sum(fea_a.*fea_a,2);
    ab = fea_a*fea_a';
    
    aa = full(aa);
    ab = full(ab);

    if bSqrt
        D = sqrt(repmat(aa, 1, nSmp) + repmat(aa', nSmp, 1) - 2*ab);
        D = real(D);
    else
        D = repmat(aa, 1, nSmp) + repmat(aa', nSmp, 1) - 2*ab;
    end
    
    D = max(D,D');
    D = D - diag(diag(D));
    D = abs(D);
else
    [nSmp_a, nFea] = size(fea_a);
    [nSmp_b, nFea] = size(fea_b);
    
    aa = sum(fea_a.*fea_a,2);
    bb = sum(fea_b.*fea_b,2);
    ab = fea_a*fea_b';

    aa = full(aa);
    bb = full(bb);
    ab = full(ab);

    if bSqrt
        D = sqrt(repmat(aa, 1, nSmp_b) + repmat(bb', nSmp_a, 1) - 2*ab);
        D = real(D);
    else
        D = repmat(aa, 1, nSmp_b) + repmat(bb', nSmp_a, 1) - 2*ab;
    end
    
    D = abs(D);
end




