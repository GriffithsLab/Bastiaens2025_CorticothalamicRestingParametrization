# Overview
This repository contains the full code for the preprocessing, analyses, and results related to the paper "Corticothalamic circuit mechanisms underlying brain region and ageing variations in resting-state alpha activity" by SP Bastiaens, D Momi, L Rokos, T Morshedzadeh, K Kadak, MP Oveisi, and JD Griffiths. The data used in this project is from the Cam-CAN dataset, which is available at http://camcan-archive.mrc-cbu.cam.ac.uk, subject to conditions specified on the website. Due to data sharing and size restrictions, we do not include raw or preprocessed EEG/MEG data. Instead, the data folder contains the extracted empirical features and modeling parameters (averaged across 200 ROIs), as well as the bootstrap ratio outputs from the different PLS analyses performed using MATLAB, required to reproduce the analyses provided in the notebooks.

## Folders
- ```code```: Contains the .py and .m files with preprocessing steps, estimation of empirical features, and model fitting. Contains as well .py files to run the simulations to reproduce the figures from the paper. It consists of 4 subfolders:
  - ```Analysis```: Contains the code files for running the different analyses with the 200 empirical and modelling values per subject.
  - ```Empirical_features```: Contains the code for estimating the four empirical features using the source PSDs.
  - ```Modelling```: Contains the code for running the model fitting in MATLAB using the source averaged PSDs over 200 ROIs.
  - ```Processing```: Contains the code for preprocessing the data with the MNE-BIDS pipeline configuration file, and code to obtain the source and average PSDs.
- ```notebooks```: Contains the .ipynb files to run the simulations to reproduce the figures from the paper.
- ```data```: Contains .csv file with the averaged empirical features and modelling parameters for the 200 ROIs in order to run the files contained in the notebooks folder, and the bootstrap ratio values from the behavioural PLS analyses conducted in MATLAB.

## Files
