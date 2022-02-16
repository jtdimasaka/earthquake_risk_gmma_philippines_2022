%% GMMA Probabilistic Earthquake Risk Analysis - PERA
% This module 

%% Initialize
clear, clc, close
tic

%% Import Data
load("20220111 GMMA Data.mat")
toc, fprintf("Data Imported \n"), tic

%% Geospatial Exposure Data
[exposure] = loadexposuredata(data);
toc, fprintf("Exposure Data Processed \n"), tic

%% Seismic Hazard Data
[hazard] = loadhazarddata(data);
toc, fprintf("Seismic Hazard Processed \n"), tic

%% Fragility - Likelihood of Damage States and Damaged Floor Area Estimation
[fragility] = loadfragilityparameters();
toc, fprintf("Fragility Parameters Loaded \n"), tic

[probDS, meanDS, damagedAREA, casualty] = applyfragility(exposure, hazard, fragility);
toc, fprintf("Damage States Probabilities Computed and Damaged Floor Area Estimated\n"), tic

%% Vulnerability - Loss Estimation
[vulnerability] = loadvulnerabilityparameters();
toc, fprintf("Vulnerability Parameters Loaded \n"), tic

[loss, RepairCostbyST, RepairCostbyBLDG] = applyvulnerability(exposure, hazard, probDS, vulnerability);
toc, fprintf("Loss Computed \n"), tic

%% FEMA P-366 - Average Annualized Earthquake Loss Estimation
[aAreaLoss, aSocialLoss, aEconLoss, EP] = annualize(  	exposure,...
                                                        hazard,...
                                                        meanDS, ...
                                                        damagedAREA, ...
                                                        casualty, ...
                                                        RepairCostbyBLDG, ...
                                                        RepairCostbyST);
toc, fprintf("Average Annualized Earthquake Loss Computed \n"), tic

%% Save the File
filename = strrep(string(datetime(now,'ConvertFrom','datenum')),":","-");
save(filename)
toc, fprintf("Saved \n")

%% Contact Information
% Joshua T. Dimasaka
% Public Policy Program
% Stanford University
% dimasakajoshua@gmail.com