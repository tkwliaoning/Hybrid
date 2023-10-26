function [Wm, Bm] = InitNet(n_current, n_previous, mark)

% ----------------
rand('state',6);
switch mark
    case 0 % 0: zeros
        Wm = zeros(n_current, n_previous);
        Bm = zeros(n_current, 1);
    case 1 % 1: eyes
        Wm = eye(n_current, n_previous);
        Bm = zeros(n_current, 1);
    case 2 % 
        r = sqrt(6)/(sqrt(n_current + n_previous));
        Wm = -r + 2*r*rand(n_current, n_previous);
        Bm = zeros(n_current,1);
    case 3 % 3: [-0.5  0.5]
        Wm = 0.5 - rand(n_current, n_previous);
        Bm = zeros(n_current, 1);
end

