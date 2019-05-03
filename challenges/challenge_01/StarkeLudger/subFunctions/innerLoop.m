function image = innerLoop(image, coilSens, trajectories, intCor, densCor)

image = intCor.*image;

kSpace = applyE(image, coilSens, trajectories);

kSpace = densCor.*kSpace;

image = applyEH(kSpace, coilSens, trajectories);

image = intCor.*image;


