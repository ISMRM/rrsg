function [reco, deltaError, refError] = SENSE_trackErrors(spokesData, coilSens, trajectories, intCor, densCor, reference, maxIter)
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

deltaError = zeros(maxIter + 1, 1);
refError = zeros(maxIter + 1, 1);

refNorm = reference(:)'*reference(:);

%
nIter = 0;

rNorm_new = r_new(:)'*r_new(:);
deltaError(nIter + 1) = rNorm_new/aNorm;
deviation = intCor.*b_new - reference;
refError(nIter + 1) = sqrt((deviation(:)'*deviation(:))/refNorm);
 
fprintf('\n%d - %.4f\n\n', nIter, deltaError(nIter + 1))
 
while (nIter < maxIter)
    
    
    b_old = b_new;
    r_old = r_new;
    rNorm_old = rNorm_new;
        
    q = innerLoop(p, coilSens, trajectories, intCor, densCor);

    alpha = rNorm_old/(p(:)'*q(:));
    b_new = b_old + alpha*p;
    r_new = r_old - alpha*q;

    nIter = nIter + 1;

    rNorm_new = r_new(:)'*r_new(:);
    deltaError(nIter + 1) = rNorm_new/aNorm;
    deviation = kSpaceFilter(intCor.*b_new, trajectories) - reference;
    refError(nIter + 1) = sqrt((deviation(:)'*deviation(:))/refNorm);
        
    p = r_new + rNorm_new/rNorm_old*p;
        
    fprintf('\n%d - %.4f\n\n', nIter, deltaError(nIter + 1))
    
end

%%

reco = intCor.*b_new;
reco = kSpaceFilter(reco, trajectories);



