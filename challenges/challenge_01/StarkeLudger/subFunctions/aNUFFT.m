function image = aNUFFT(spokes, trajectories)

image = bart('nufft -a -t', trajectories, spokes);