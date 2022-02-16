function [aAreaLoss, aSocialLoss, aEconLoss, EP] = annualize(  	exposure,...
                                                                hazard,...
                                                                meanDS, ...
                                                                damagedAREA, ...
                                                                casualty, ...
                                                                RepairCostbyBLDG, ...
                                                                RepairCostbyST)
prefix = strrep(string(datetime(now,'ConvertFrom','datenum')),":","-");  

%% Annual and Differential Probabilities
annualprob = hazard.returnperiod;
diffprob = [annualprob(1,1); annualprob(2:8,1) - annualprob(1:7,1)];

%% AREALOSS
aAreaLoss = struct;

% Annual Area Losses
Ldamagedarea_n =    reshape(sum(damagedAREA(:,:,1,:), [1 2 3]), [8 1 1 1]); %N
Ldamagedarea_s =    reshape(sum(damagedAREA(:,:,2,:), [1 2 3]), [8 1 1 1]); %S
Ldamagedarea_m =    reshape(sum(damagedAREA(:,:,3,:), [1 2 3]), [8 1 1 1]); %M
Ldamagedarea_e =    reshape(sum(damagedAREA(:,:,4,:), [1 2 3]), [8 1 1 1]); %E
Ldamagedarea_cwoc = reshape(sum(damagedAREA(:,:,5,:), [1 2 3]), [8 1 1 1]); %CWOC
Ldamagedarea_cwc =  reshape(sum(damagedAREA(:,:,6,:), [1 2 3]), [8 1 1 1]); %CWC

% Average Area Losses
ave_Ldamagedarea_n = [Ldamagedarea_n(1,1); 0.5.*Ldamagedarea_n(2:8,1)+0.5.*Ldamagedarea_n(1:7,1)];
ave_Ldamagedarea_s = [Ldamagedarea_s(1,1); 0.5.*Ldamagedarea_s(2:8,1)+0.5.*Ldamagedarea_s(1:7,1)];
ave_Ldamagedarea_m = [Ldamagedarea_m(1,1); 0.5.*Ldamagedarea_m(2:8,1)+0.5.*Ldamagedarea_m(1:7,1)];
ave_Ldamagedarea_e = [Ldamagedarea_e(1,1); 0.5.*Ldamagedarea_e(2:8,1)+0.5.*Ldamagedarea_e(1:7,1)];
ave_Ldamagedarea_cwoc = [Ldamagedarea_cwoc(1,1); 0.5.*Ldamagedarea_cwoc(2:8,1)+0.5.*Ldamagedarea_cwoc(1:7,1)];
ave_Ldamagedarea_cwc = [Ldamagedarea_cwc(1,1); 0.5.*Ldamagedarea_cwc(2:8,1)+0.5.*Ldamagedarea_cwc(1:7,1)];

% Annualized Area Losses
aAreaLoss.n = sum(ave_Ldamagedarea_n.*diffprob);
aAreaLoss.s = sum(ave_Ldamagedarea_s.*diffprob);
aAreaLoss.m = sum(ave_Ldamagedarea_m.*diffprob);
aAreaLoss.e = sum(ave_Ldamagedarea_e.*diffprob);
aAreaLoss.cwoc = sum(ave_Ldamagedarea_cwoc.*diffprob);
aAreaLoss.cwc = sum(ave_Ldamagedarea_cwc.*diffprob);

%% ECONLOSS
% Annual Econ Losses
LEconLoss =    reshape(sum(RepairCostbyBLDG, [1 2]), [8 1 1]);

% Average Econ Losses
ave_LEconLoss = [LEconLoss(1,1); 0.5.*LEconLoss(2:8,1)+0.5.*LEconLoss(1:7,1)];

% Annualized Econ Losses
aEconLoss = sum(ave_LEconLoss.*diffprob);

%% Casualty Loss - Slight Injuries
indoor_slightinjuries_mean = sum(casualty.slightinjuries.indoor.mean)';
indoor_slightinjuries_stdv = sqrt(sum(casualty.slightinjuries.indoor.stdv .* ...
                                      casualty.slightinjuries.indoor.stdv)');
outdoor_slightinjuries_mean = sum(casualty.slightinjuries.outdoor.mean)';
outdoor_slightinjuries_stdv = sqrt(sum(casualty.slightinjuries.outdoor.stdv .* ...
                                      casualty.slightinjuries.outdoor.stdv)');
total_slightinjuries_mean = sum(casualty.slightinjuries.total.mean)';
total_slightinjuries_stdv = sqrt(sum(casualty.slightinjuries.total.stdv .* ...
                                      casualty.slightinjuries.total.stdv)');

%% Casualty Loss - Serious Injuries
indoor_seriousinjuries_mean = sum(casualty.seriousinjuries.indoor.mean)';
indoor_seriousinjuries_stdv = sqrt(sum(casualty.seriousinjuries.indoor.stdv .* ...
                                      casualty.seriousinjuries.indoor.stdv)');
outdoor_seriousinjuries_mean = sum(casualty.seriousinjuries.outdoor.mean)';
outdoor_seriousinjuries_stdv = sqrt(sum(casualty.seriousinjuries.outdoor.stdv .* ...
                                      casualty.seriousinjuries.outdoor.stdv)');
total_seriousinjuries_mean = sum(casualty.seriousinjuries.total.mean)';
total_seriousinjuries_stdv = sqrt(sum(casualty.seriousinjuries.total.stdv .* ...
                                      casualty.seriousinjuries.total.stdv)');
                                  
%% Casualty Loss - Life-threatening Injuries
indoor_lifethreatinjuries_mean = sum(casualty.lifethreatinjuries.indoor.mean)';
indoor_lifethreatinjuries_stdv = sqrt(sum(casualty.lifethreatinjuries.indoor.stdv .* ...
                                      casualty.lifethreatinjuries.indoor.stdv)');
outdoor_lifethreatinjuries_mean = sum(casualty.lifethreatinjuries.outdoor.mean)';
outdoor_lifethreatinjuries_stdv = sqrt(sum(casualty.lifethreatinjuries.outdoor.stdv .* ...
                                      casualty.lifethreatinjuries.outdoor.stdv)');
total_lifethreatinjuries_mean = sum(casualty.lifethreatinjuries.total.mean)';
total_lifethreatinjuries_stdv = sqrt(sum(casualty.lifethreatinjuries.total.stdv .* ...
                                      casualty.lifethreatinjuries.total.stdv)');
                                  
%% Casualty Loss - Fatalities
indoor_fatalities_mean = sum(casualty.fatalities.indoor.mean)';
indoor_fatalities_stdv = sqrt(sum(casualty.fatalities.indoor.stdv .* ...
                                      casualty.fatalities.indoor.stdv)');
outdoor_fatalities_mean = sum(casualty.fatalities.outdoor.mean)';
outdoor_fatalities_stdv = sqrt(sum(casualty.fatalities.outdoor.stdv .* ...
                                      casualty.fatalities.outdoor.stdv)');
total_fatalities_mean = sum(casualty.fatalities.total.mean)';
total_fatalities_stdv = sqrt(sum(casualty.fatalities.total.stdv .* ...
                                      casualty.fatalities.total.stdv)');

%% SOCIAL LOSS
% Annual Social Losses
LSocialLoss_sev1 = total_slightinjuries_mean;
LSocialLoss_sev2 = total_seriousinjuries_mean;
LSocialLoss_sev3 = total_lifethreatinjuries_mean;
LSocialLoss_sev4 = total_fatalities_mean;

% Average Social Losses
ave_LSocialLoss_sev1 = [LSocialLoss_sev1(1,1); 0.5.*LSocialLoss_sev1(2:8,1)+0.5.*LSocialLoss_sev1(1:7,1)];
ave_LSocialLoss_sev2 = [LSocialLoss_sev2(1,1); 0.5.*LSocialLoss_sev2(2:8,1)+0.5.*LSocialLoss_sev2(1:7,1)];
ave_LSocialLoss_sev3 = [LSocialLoss_sev3(1,1); 0.5.*LSocialLoss_sev3(2:8,1)+0.5.*LSocialLoss_sev3(1:7,1)];
ave_LSocialLoss_sev4 = [LSocialLoss_sev4(1,1); 0.5.*LSocialLoss_sev4(2:8,1)+0.5.*LSocialLoss_sev4(1:7,1)];

% Annualized Social Losses
aSocialLoss = zeros(4,1);
aSocialLoss(1,1) = sum(ave_LSocialLoss_sev1.*diffprob);
aSocialLoss(2,1) = sum(ave_LSocialLoss_sev2.*diffprob);
aSocialLoss(3,1) = sum(ave_LSocialLoss_sev3.*diffprob);
aSocialLoss(4,1) = sum(ave_LSocialLoss_sev4.*diffprob);

%% Exceedance Curve Parameters
EP = struct;
EP.annualprob = annualprob;
EP.returnperiod = 1./annualprob;
EP.Ldamagedarea_n = Ldamagedarea_n;
EP.Ldamagedarea_s = Ldamagedarea_s;
EP.Ldamagedarea_m = Ldamagedarea_m;
EP.Ldamagedarea_e = Ldamagedarea_e;
EP.Ldamagedarea_cwoc = Ldamagedarea_cwoc;
EP.Ldamagedarea_cwc = Ldamagedarea_cwc;
EP.LEconLoss = LEconLoss;
EP.indoor_slightinjuries_mean = indoor_slightinjuries_mean;
EP.indoor_slightinjuries_stdv = indoor_slightinjuries_stdv;
EP.outdoor_slightinjuries_mean = outdoor_slightinjuries_mean;
EP.outdoor_slightinjuries_stdv = outdoor_slightinjuries_stdv;
EP.total_slightinjuries_mean = total_slightinjuries_mean;
EP.total_slightinjuries_stdv = total_slightinjuries_stdv;
EP.indoor_seriousinjuries_mean = indoor_seriousinjuries_mean;
EP.indoor_seriousinjuries_stdv = indoor_seriousinjuries_stdv;
EP.outdoor_seriousinjuries_mean = outdoor_seriousinjuries_mean;
EP.outdoor_seriousinjuries_stdv = outdoor_seriousinjuries_stdv;
EP.total_seriousinjuries_mean = total_seriousinjuries_mean;
EP.total_seriousinjuries_stdv = total_seriousinjuries_stdv;
EP.indoor_lifethreatinjuries_mean = indoor_lifethreatinjuries_mean;
EP.indoor_lifethreatinjuries_mean = indoor_lifethreatinjuries_mean;
EP.outdoor_lifethreatinjuries_mean = outdoor_lifethreatinjuries_mean;
EP.outdoor_lifethreatinjuries_stdv = outdoor_lifethreatinjuries_stdv;
EP.total_lifethreatinjuries_mean = total_lifethreatinjuries_mean;
EP.total_lifethreatinjuries_stdv = total_lifethreatinjuries_stdv;
EP.indoor_fatalities_mean = indoor_fatalities_mean;
EP.indoor_fatalities_stdv = indoor_fatalities_stdv;
EP.outdoor_fatalities_mean = outdoor_fatalities_mean;
EP.outdoor_fatalities_mean = outdoor_fatalities_mean;
EP.total_fatalities_mean = total_fatalities_mean;
EP.total_fatalities_stdv = total_fatalities_stdv;


end

