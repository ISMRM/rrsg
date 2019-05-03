Readme

Reproducible Research Challenge 2019 - Ludger Starke


---

Main files:

Brain.m                script    calls all computations and generates figures for task 2 and 3
Cardio.m               script    calls all computations and generates figures for task 4
SENSE.m                function  implementation of the algorithm described by Pruesmann et al. (2001) 
SENSE_trackErrors.m    function  as SENSE.m, but with added output of two error terms for every iteration

The folder "subFunctions" contains additional functions necessary to execute the main files. 


---

The Berkeley Advanced Reconstruction Toolbox (BART) is used for NUFFT computations.

Uecker M, Ong F, Tamir JI, Bahri D, Virtue P, Cheng JY, Zhang T, Lustig M,
  Berkeley Advanced Reconstruction Toolbox, Annual Meeting ISMRM, Toronto 2015
  In: Proc Intl Soc Mag Reson Med 23:2486

URL: 

---


Necessary Preparation:

To execute Brain.m or Cardio.m, adjust the variables "bartPath" and "dataFolder".

The "subFunctions" folder should be automaically added to the searchpath if MATLAB's current folder is the folder containing Brain.m etc.


---

Additional parameter choices:

Task 2 - Reference reconstruction computed from the complete data in 150 iterations. 
Task 3 - Images for column 3 computed with criterion delta < 0.05
Task 4 - delta < 0.02; maximum number of iterations = 40 
