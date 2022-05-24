%% PUBLPOL 310
% Towards an Equitable Development of the Regional Earthquake Resilience 
% of the Greater Metro Manila Area, Philippines  

%% Initialize
clear, clc, close
tic

%% Import Data
load("20220111 GMMA Data.mat") %Confidential - not provided
toc, fprintf("Data Imported \n"), tic

%% Geospatial Exposure Data
[exposure] = loadexposuredata(data);
toc, fprintf("Exposure Data Processed \n"), tic

%% Seismic Hazard Data
load("20220125 PGA Corrected.mat") %Confidential - not provided
[hazard] = loadhazarddata(new_pga);
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
[aEconLoss] = annualize(hazard, RepairCostbyBLDG);
toc, fprintf("Average Annualized Earthquake Loss Computed \n"), tic

%% Save the File
filename = strrep(string(datetime(now,'ConvertFrom','datenum')),":","-");
save(filename)
toc, fprintf("Saved \n")

%% Data Restriction and Privacy Statement
% Input data are confidential and cannot be publicly released.

%% Contact Information
% Joshua T. Dimasaka
% Public Policy Program
% Stanford University
% dimasaka@alumni.stanford.edu