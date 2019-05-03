function [reco, nIter, delta] = SENSE(spokesData, coilSens, trajectories, intCor, densCor, tol, maxIter)
% a = rhs of equation
% b = image approximation
% p = search direction
% r = residuum
% delta = relative deviation from equality
% q = lhs matrix times p

densCor = repmat(densCor,[1, 1, 1, size(coilSens,4)]);

%% Precalculations

a = intCor.*applyEH(densCor.*spokesData, coilSens, trajectories);
b_new = zeros(size(a));
p = a;
r_new = a;

aNorm = a(:)'*a(:);

%% CJG iterations

nIter = 0;

rNorm_new = r_new(:)'*r_new(:);
delta = rNorm_new/aNorm;
 
fprintf('\n%d - %.4f\n\n', nIter, delta)
 
while (nIter < maxIter) && (delta > tol)
    
    
        b_old = b_new;
    r_old = r_new;
    rNorm_old = rNorm_new;
        
    q = innerLoop(p, coilSens, trajectories, intCor, densCor);

    alpha = rNorm_old/(p(:)'*q(:));
    b_new = b_old + alpha*p;
    r_new = r_old - alpha*q;

    rNorm_new = r_new(:)'*r_new(:);
    delta = rNorm_new/aNorm;
        
    p = r_new + rNorm_new/rNorm_old*p;
        
    nIter = nIter + 1;
    fprintf('\n%d - %.4f\n\n', nIter, delta)
    
end

%%

reco = intCor.*b_new;
reco = kSpaceFilter(reco, trajectories);



