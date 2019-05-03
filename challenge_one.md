---
layout: page
title: Reproducibility Challenge 1 - Arbitrary SENSE
permalink: /challenge_one/
---

In April 2019 the RRSG challenged the ISMRM community to reproduce the results from a seminal paper in the field. The goal of this initiative is to select seminal papers from our field, and ask the community to reproduce the core findings/algorithms/implementations from these papers. The main motivation behind this initiative is to:

* Over time, create a library of standard reference implementations that can be used for comparison when publishing new methods.
* The ISMRM is currently creating educational content by curating educational lectures from past annual meetings and assembling them into online courses ([https://www.ismrm.org/online-education-program/](https://www.ismrm.org/online-education-program/)). An accompanying repository of reference implementations would be valuable additional content that the ISMRM research community could provide.
* Compare the individual submissions in terms of consistency of results, computation time and hardware/programming language requirements. Note: This is not to be intended to be a “ranking” of the submissions as would be done in a competition, but as an assessment of their variability.
* This initiative can be a great opportunity for students and trainees to gain additional visibility, especially if they come from smaller labs and countries where they do not have the opportunities to go to every ISMRM meeting and workshop to present their work to the research community.

The detailed submission instructions [can be found here for reference](https://blog.ismrm.org/2019/04/02/ismrm-reproducible-research-study-group-2019-reproduce-a-seminal-paper-initiative/).

## The paper

The paper selected for this challenge, which participants were asked to reproduce:

Klaas P. Pruessmann, Markus Weiger, Peter Börnert, Peter Boesiger. [Advances in sensitivity encoding with arbitrary k-space trajectories](https://onlinelibrary.wiley.com/doi/full/10.1002/mrm.1241). Magn Reson Med. (2001); 46(4):638-51.


## The data

We provided two example datasets, brain (12 receive channels, 96 radial projections) and cardiac (34 receive channels, 55 radial projections), from a radial trajectory acquired with multi-channel coils. The data is provided in the h5 format, and we are following the conventions of the BART toolbox regarding array dimensions of the raw data [1, Readout, Spokes, Channels] and the trajectory [3, Readout, Spokes] where the first dimension encodes the k-space coordinate (for 2D acquisitions the third coordinate is always zero) and the unit of measurement is 1 / FOV.

<figure>
<img src="https://raw.githubusercontent.com/ISMRM/rrsg/master/challenges/challenge_01/figure1.png" alt="Figure1" /><figcaption><strong>Figure 1:</strong> Raw k-space data from one coil and a gridding sum of squares example reconstruction of the provided brain (left) and cardiac (right) data</figcaption>
</figure>


Brain data (5.3 MB): [rawdata\_brain\_radial\_6proj\_12ch.h5](https://github.com/ISMRM/blob/master/rrsg/challenges/challenge_01/rawdata_brain_radial_96proj_12ch.h5): rawdata: [1, 512, 96, 12], trajectory: [1, 512, 96]

Cardiac data (5 MB): [rawdata\_heart\_radial\_55proj_34ch.h5](https://github.com/ISMRM/rrsg/blob/master/challenges/challenge_01/rawdata_heart_radial_55proj_34ch.h5): rawdata: [1, 320, 55, 34], trajectory: [1, 320, 55]

We also provided starter-scripts for MATLAB and Python which are able to read in and display the data. These scripts are also [available from the Github repository](https://github.com/ISMRM/rrsg/tree/master/challenges/challenge_01).


## Submissions

Collated list of submissions - May 2019:

<table style="width:100%; font-size:80%" class="TFtable">
	<col style="width:40%" />
	<col style="width:30%" />
	<col style="width:30%" />
<thead>
        <tr>
           <th>Authors (or principal author)</th>
          <th style="max-width:150px; word-wrap:break-word;">Link</th>
          <th>Info</th>
        </tr>
</thead>       
        <tbody>
        <tr>
          <td>Steven
              Baete (NYU) <br />
              </td>
          <td>
            
            <a href="https://bitbucket.org/sbaete/ismrm2019reprodcgsense">https://bitbucket.org/sbaete/ismrm2019reprodcgsense</a></td>
          <td>MATLAB, NUFFT (Fessler), gpuNUFFT (Schwarzl, Knoll)<br />
          </td>
        </tr>
        <tr>
          <td>Alexander
              Fyrdahl (Karolinska Institutet and Karolinska University
              Hospital,
              Sweden) </td>
          <td>
            
            <a href="https://github.com/fyrdahl/rrsg_challenge">https://github.com/fyrdahl/rrsg_challenge</a>
          </td>
          <td>MATLAB, NUFFT (Fessler)<br />
          </td>
        </tr>
        <tr>
          <td>Kerstin
              Hammernik (Graz University of Technology)</td>
          <td><a href="https://github.com/khammernik/ISMRM2019_RRSG">https://github.com/khammernik/ISMRM2019_RRSG</a></td>
          <td>Python, BART, primal-dual-toolbox, medutils<br />
          </td>
        </tr>
        <tr>
          <td>Seb
              Harrevelt (Eindhoven University of Technology)<br />
              </td>
          <td><a href="https://github.com/zwep/ismrm19_challenge">https://github.com/zwep/ismrm19_challenge</a></td>
          <td>Python, PyNUFFT (Lin),&nbsp; <br />
          </td>
        </tr>
        <tr>
          <td>Namgyun
              Lee (University of Southern California) </td>
          <td>
            
            <a href="https://drive.google.com/file/d/10qD6K-sCEkNjpynRZTpLm8VBUPJFhJCt/view">https://drive.google.com/file/d/10qD6K-sCEkNjpynRZTpLm8VBUPJFhJCt/view</a>
          </td>
          <td>MATLAB, custom MEX for gridding<br />
          </td>
        </tr>
        <tr>
          <td>Gilad
              Liberman (MGH) </td>
          <td>
            
            <a href="https://github.com/giladddd/LinopScript">https://github.com/giladddd/LinopScript</a>
          </td>
          <td>MATLAB, <em>Demo of linear-operator scripting for BART on
              challenge datasets</em><br />
          </td>
        </tr>
        <tr>
          <td>Michael Loecher (Stanford)<br />
          </td>
          <td>
            
            <a href="https://github.com/mloecher/rrsg_challenge">https://github.com/mloecher/rrsg_challenge</a>
          </td>
          <td>Python, custom Cython for gridding<br />
          </td>
        </tr>
        <tr>
          <td>Oliver Maier (Graz
              University of Technology) </td>
          <td>
            
            <a href="https://github.com/MaierOli2010/ISMRM_RRSG">https://github.com/MaierOli2010/ISMRM_RRSG</a>
          </td>
          <td>Python, BART, requires GPU for use of GPyFFT<br />
          </td>
        </tr>
        <tr>
          <td>Franz
              Patzig, Lars Kasper, Thomas Ulrich, Maria Engel, Johanna
              Vannesjo,
              Markus Weiger, David Brunner, Bertram Wilm, Klaas
                Prüssmann (ETHZ) </td>
          <td>
            
            <a href="https://github.com/mrtm-zurich/rrsg-arbitrary-sense">https://github.com/mrtm-zurich/rrsg-arbitrary-sense</a>
          </td>
          <td>MATLAB, custom gridding in MATLAB<br />
          </td>
        </tr>
        <tr>
          <td>Ludger Starke (MDC-Berlin)<br />
          </td>
          <td>
            
            <a href="https://github.com/ISMRM/rrsg/blob/master/challenges/challenge_01/hosted_submissions/reproducibleResearch19_LudgerStarke.zip">.../reproducibleResearch19_LudgerStarke.zip</a>
          </td>
          <td>MATLAB, BART<br />
          </td>
        </tr>
        <tr>
          <td>Ye Tian (UCAIR - University of Utah)<br />
          </td>
          <td>
            
            <a href="https://github.com/YeTianMRI/ISMRM-2019-reproducible">https://github.com/YeTianMRI/ISMRM-2019-reproducible</a>
          </td>
          <td>MATLAB, NUFFT (Fessler)<br />
          </td>
        </tr>
        <tr>
          <td>Ke Wang, Miki Lustig, Ekin Karasan, Suma Anand, Volert Roeloffs
            (Berkeley)<br />
          </td>
          <td>
            
            <a href="https://github.com/KeWang0622/rrsg_challenge_sigpy">https://github.com/KeWang0622/rrsg_challenge_sigpy</a>
          </td>
          <td>Python, SigPy (Ong)<br />
          </td>
        </tr>
      </tbody>
    </table>