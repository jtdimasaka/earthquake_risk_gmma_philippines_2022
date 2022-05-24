function [aEconLoss] = annualize(hazard, RepairCostbyBLDG)

% Annual and Differential Probabilities
annualprob = hazard.returnperiod;
diffprob = [annualprob(1,1); annualprob(2:8,1) - annualprob(1:7,1)];

% Annual Econ Losses
LEconLoss =    reshape(sum(RepairCostbyBLDG, [1 2]), [8 1 1]);

% Average Econ Losses
ave_LEconLoss = [LEconLoss(1,1); 0.5.*LEconLoss(2:8,1)+0.5.*LEconLoss(1:7,1)];

% Annualized Econ Losses
aEconLoss = sum(ave_LEconLoss.*diffprob);

end

