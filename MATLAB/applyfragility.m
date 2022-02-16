function [probDS, meanDS, damagedAREA, casualty] = applyfragility(exposure, hazard, fragility)

probDS = struct;
probDS.probDS = zeros(numel(exposure.Name),size(fragility.mapping,1),6,numel(hazard.returnperiod));

%% Determine the median and beta
probDS.index = repmat(...
       [1; 1; 2; 3; 5; 6; 7; 7; 7; 4; 8; 9; 9; 11; 17; 17; 19; 19; 25; 26;...
        1; 1; 2; 3; 5; 6; 7; 7; 7; 4; 8; 9; 9; 11; 17; 17; 19; 19; 25; 26;...
        1; 1; 2; 3; 5; 6; 7; 7; 7; 4; 8; 10; 10; 11; 18; 18; 22; 22; 25; 26;...
        1; 1; 2; 3; 5; 6; 7; 7; 7; 4; 8; 10; 10; 14; 18; 18; 22; 22; 25; 26]',...
        [85482,1]);
probDS.index(:,[14, 17, 18, 34, 37, 38, 54, 57, 58, 74, 77, 78])...
        = probDS.index(:,[14, 17, 18, 34, 37, 38, 54, 57, 58, 74, 77, 78]) + ...
        ((exposure.era == "Pre-1972").*0) + ...
        ((exposure.era == "1972-1992").*1) + ...
        ((exposure.era == "Post-1992").*2);
probDS.median = reshape(fragility.median(probDS.index,:), [85482,80,4]);
probDS.beta = reshape(fragility.beta(probDS.index,:), [85482,80,4]);
probDS.ratecollapse = repmat(reshape(fragility.collapse(probDS.index,:),[85482,80,1,1]),[1,1,1,8]);

%% Determine the likelihood of each damage state
probDS.probCDF = logncdf(   repmat(reshape(hazard.MMI.mean,[85482,1,1,8]),[1,80,4,1]),...
                            log(repmat(probDS.median,[1,1,1,8])),...
                            repmat(probDS.beta,[1,1,1,8]));  
toc, fprintf("Damage State Likelihood Computed \n"), tic
                        
%% Compute ProbDS - None, Slight, Moderate, Extensive, Complete
probDS.probDS(:,:,1,:) = 1 - probDS.probCDF(:,:,1,:); %None
probDS.probDS(:,:,2,:) = probDS.probCDF(:,:,1,:) - probDS.probCDF(:,:,2,:);     %Slight
probDS.probDS(:,:,3,:) = probDS.probCDF(:,:,2,:) - probDS.probCDF(:,:,3,:);     %Moderate
probDS.probDS(:,:,4,:) = probDS.probCDF(:,:,3,:) - probDS.probCDF(:,:,4,:);     %Extensive
probDS.probDS(:,:,5,:) = probDS.probCDF(:,:,4,:).*(1-probDS.ratecollapse);    	%Complete and non-collapse
probDS.probDS(:,:,6,:) = probDS.probCDF(:,:,4,:).* probDS.ratecollapse;         %Complete and collapse

%% Compute Population per Building Type
area = sum(exposure.Area.stht,2);
area_factor = exposure.Area.stht./area;
area_factor(isnan(area_factor))=0;
n_nonzeroarea = numel(find(area > 0));
area_factor = area_factor(:,1:80);
popmean = area_factor(:,1:80).*exposure.pop.mean;
popstdv = area_factor(:,1:80).*exposure.pop.stdv;

%% Compute ProbDS - None, Slight, Moderate, Extensive, Complete
meanDS =    probDS.probDS(:,:,1,:).*1.*repmat(area_factor,[1,1,1,8]) + ...
            probDS.probDS(:,:,2,:).*2.*repmat(area_factor,[1,1,1,8]) + ...
            probDS.probDS(:,:,3,:).*3.*repmat(area_factor,[1,1,1,8]) + ...
            probDS.probDS(:,:,4,:).*4.*repmat(area_factor,[1,1,1,8]) + ...
            (probDS.probDS(:,:,5,:)+probDS.probDS(:,:,6,:)).*5.*repmat(area_factor,[1,1,1,8]);
meanDS = sum(meanDS, 2);
meanDS = reshape(meanDS, [85482,8,1,1]);
toc, fprintf("Average Damage State Computed \n"), tic

%% Compute Damaged Areas
damagedAREA = probDS.probDS .* repmat(reshape(exposure.Area.stht(:,1:80),[85482,80,1,1]),[1,1,6,8]);
toc, fprintf("Damaged Area Computed \n"), tic

%% Slight Injuries
% Compute Indoor Slight Injuries
casualty.slightinjuries.indoor.rates = repmat(reshape(fragility.casualty.indoor.sev1(probDS.index,:), [85482,80,5]), [1,1,1,8]);
casualty.slightinjuries.indoor.mean =   casualty.slightinjuries.indoor.rates .* ...
                                        probDS.probDS(:,:,2:6,:) .* ...
                                        repmat(reshape(popmean,[85482,80,1,1]),[1,1,5,8]);
casualty.slightinjuries.indoor.mean = reshape(sum(casualty.slightinjuries.indoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.slightinjuries.indoor.stdv =   casualty.slightinjuries.indoor.rates .* ...
                                        probDS.probDS(:,:,2:6,:) .* ...
                                        repmat(reshape(popstdv,[85482,80,1,1]),[1,1,5,8]);
casualty.slightinjuries.indoor.stdv = reshape(sum(casualty.slightinjuries.indoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Indoor Slight Injuries Computed \n"), tic

% Compute Outdoor Slight Injuries
temp = zeros(85482,80,3,8);
temp(:,:,1,:) = probDS.probDS(:,:,3,:);
temp(:,:,2,:) = probDS.probDS(:,:,4,:);
temp(:,:,3,:) = probDS.probDS(:,:,5,:)+probDS.probDS(:,:,6,:);
casualty.slightinjuries.outdoor.rates = repmat(reshape(fragility.casualty.outdoor.sev1(probDS.index,:), [85482,80,3]), [1,1,1,8]);
casualty.slightinjuries.outdoor.mean =   casualty.slightinjuries.outdoor.rates .* ...
                                        temp .* ...
                                        repmat(reshape(popmean,[85482,80,1,1]),[1,1,3,8]);
casualty.slightinjuries.outdoor.mean = reshape(sum(casualty.slightinjuries.outdoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.slightinjuries.outdoor.stdv =   casualty.slightinjuries.outdoor.rates .* ...
                                        temp .* ...
                                        repmat(reshape(popstdv,[85482,80,1,1]),[1,1,3,8]);
casualty.slightinjuries.outdoor.stdv = reshape(sum(casualty.slightinjuries.outdoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Outdoor Slight Injuries Computed \n"), tic

% Compute Total Slight Injuries
casualty.slightinjuries.total.mean = casualty.slightinjuries.indoor.mean + ...
                                     casualty.slightinjuries.outdoor.mean;
casualty.slightinjuries.total.stdv = sqrt(casualty.slightinjuries.indoor.stdv.*casualty.slightinjuries.indoor.stdv + ...
                                     casualty.slightinjuries.outdoor.stdv.*casualty.slightinjuries.outdoor.stdv);
toc, fprintf("Total Slight Injuries Computed \n"), tic

%% Serious Injuries
% Compute Indoor Serious Injuries                                 
casualty.seriousinjuries.indoor.rates = repmat(reshape(fragility.casualty.indoor.sev2(probDS.index,:), [85482,80,5]), [1,1,1,8]);
casualty.seriousinjuries.indoor.mean =   casualty.seriousinjuries.indoor.rates .* ...
                                        probDS.probDS(:,:,2:6,:) .* ...
                                        repmat(reshape(popmean,[85482,80,1,1]),[1,1,5,8]);
casualty.seriousinjuries.indoor.mean = reshape(sum(casualty.seriousinjuries.indoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.seriousinjuries.indoor.stdv =   casualty.seriousinjuries.indoor.rates .* ...
                                        probDS.probDS(:,:,2:6,:) .* ...
                                        repmat(reshape(popstdv,[85482,80,1,1]),[1,1,5,8]);
casualty.seriousinjuries.indoor.stdv = reshape(sum(casualty.seriousinjuries.indoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Indoor Serious Injuries Computed \n"), tic

% Compute Outdoor Serious Injuries  
casualty.seriousinjuries.outdoor.rates = repmat(reshape(fragility.casualty.outdoor.sev2(probDS.index,:), [85482,80,3]), [1,1,1,8]);
casualty.seriousinjuries.outdoor.mean =   casualty.seriousinjuries.outdoor.rates .* ...
                                        temp .* ...
                                        repmat(reshape(popmean,[85482,80,1,1]),[1,1,3,8]);
casualty.seriousinjuries.outdoor.mean = reshape(sum(casualty.seriousinjuries.outdoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.seriousinjuries.outdoor.stdv =   casualty.seriousinjuries.outdoor.rates .* ...
                                        temp .* ...
                                        repmat(reshape(popstdv,[85482,80,1,1]),[1,1,3,8]);
casualty.seriousinjuries.outdoor.stdv = reshape(sum(casualty.seriousinjuries.outdoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Outdoor Serious Injuries Computed \n"), tic

% Compute Total Serious Injuries  
casualty.seriousinjuries.total.mean = casualty.seriousinjuries.indoor.mean + ...
                                     casualty.seriousinjuries.outdoor.mean;
casualty.seriousinjuries.total.stdv = sqrt(casualty.seriousinjuries.indoor.stdv.*casualty.seriousinjuries.indoor.stdv + ...
                                     casualty.seriousinjuries.outdoor.stdv.*casualty.seriousinjuries.outdoor.stdv);
toc, fprintf("Total Serious Injuries Computed \n"), tic

%% Life-threatening Injuries
% Compute Indoor Life-threatening Injuries                                 
casualty.lifethreatinjuries.indoor.rates = repmat(reshape(fragility.casualty.indoor.sev3(probDS.index,:), [85482,80,5]), [1,1,1,8]);
casualty.lifethreatinjuries.indoor.mean =   casualty.lifethreatinjuries.indoor.rates .* ...
                                            probDS.probDS(:,:,2:6,:) .* ...
                                            repmat(reshape(popmean,[85482,80,1,1]),[1,1,5,8]);
casualty.lifethreatinjuries.indoor.mean = reshape(sum(casualty.lifethreatinjuries.indoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.lifethreatinjuries.indoor.stdv =   casualty.lifethreatinjuries.indoor.rates .* ...
                                            probDS.probDS(:,:,2:6,:) .* ...
                                            repmat(reshape(popstdv,[85482,80,1,1]),[1,1,5,8]);
casualty.lifethreatinjuries.indoor.stdv = reshape(sum(casualty.lifethreatinjuries.indoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Indoor Life-threatening Injuries Computed \n"), tic

% Compute Outdoor Life-threatening Injuries  
casualty.lifethreatinjuries.outdoor.rates = repmat(reshape(fragility.casualty.outdoor.sev3(probDS.index,:), [85482,80,3]), [1,1,1,8]);
casualty.lifethreatinjuries.outdoor.mean = 	casualty.lifethreatinjuries.outdoor.rates .* ...
                                            temp .* ...
                                            repmat(reshape(popmean,[85482,80,1,1]),[1,1,3,8]);
casualty.lifethreatinjuries.outdoor.mean =  reshape(sum(casualty.lifethreatinjuries.outdoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.lifethreatinjuries.outdoor.stdv = 	casualty.lifethreatinjuries.outdoor.rates .* ...
                                            temp .* ...
                                            repmat(reshape(popstdv,[85482,80,1,1]),[1,1,3,8]);
casualty.lifethreatinjuries.outdoor.stdv =  reshape(sum(casualty.lifethreatinjuries.outdoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Outdoor Life-threatening Injuries Computed \n"), tic

% Compute Total Life-threatening Injuries  
casualty.lifethreatinjuries.total.mean =    casualty.lifethreatinjuries.indoor.mean + ...
                                            casualty.lifethreatinjuries.outdoor.mean;
casualty.lifethreatinjuries.total.stdv = sqrt(  casualty.lifethreatinjuries.indoor.stdv.*casualty.lifethreatinjuries.indoor.stdv + ...
                                                casualty.lifethreatinjuries.outdoor.stdv.*casualty.lifethreatinjuries.outdoor.stdv);
toc, fprintf("Total Life-threatening Injuries Computed \n"), tic

%% Fatalities
% Compute Indoor Fatalities Injuries                                 
casualty.fatalities.indoor.rates = repmat(reshape(fragility.casualty.indoor.sev4(probDS.index,:), [85482,80,5]), [1,1,1,8]);
casualty.fatalities.indoor.mean =   casualty.fatalities.indoor.rates .* ...
                                            probDS.probDS(:,:,2:6,:) .* ...
                                            repmat(reshape(popmean,[85482,80,1,1]),[1,1,5,8]);
casualty.fatalities.indoor.mean = reshape(sum(casualty.fatalities.indoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.fatalities.indoor.stdv =   casualty.fatalities.indoor.rates .* ...
                                            probDS.probDS(:,:,2:6,:) .* ...
                                            repmat(reshape(popstdv,[85482,80,1,1]),[1,1,5,8]);
casualty.fatalities.indoor.stdv = reshape(sum(casualty.fatalities.indoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Indoor Fatalities Computed \n"), tic

% Compute Outdoor Fatalities Injuries  
casualty.fatalities.outdoor.rates = repmat(reshape(fragility.casualty.outdoor.sev4(probDS.index,:), [85482,80,3]), [1,1,1,8]);
casualty.fatalities.outdoor.mean = 	casualty.fatalities.outdoor.rates .* ...
                                  	temp .* ...
                                  	repmat(reshape(popmean,[85482,80,1,1]),[1,1,3,8]);
casualty.fatalities.outdoor.mean =  reshape(sum(casualty.fatalities.outdoor.mean,[2 3]),[85482, 8, 1, 1]);
casualty.fatalities.outdoor.stdv = 	casualty.fatalities.outdoor.rates .* ...
                                  	temp .* ...
                                   	repmat(reshape(popstdv,[85482,80,1,1]),[1,1,3,8]);
casualty.fatalities.outdoor.stdv =  reshape(sum(casualty.fatalities.outdoor.stdv,[2 3]),[85482, 8, 1, 1]);
toc, fprintf("Outdoor Fatalities Computed \n"), tic

% Compute Total Fatalities Injuries  
casualty.fatalities.total.mean =    casualty.fatalities.indoor.mean + ...
                                	casualty.fatalities.outdoor.mean;
casualty.fatalities.total.stdv = sqrt(  casualty.fatalities.indoor.stdv.*casualty.fatalities.indoor.stdv + ...
                                        casualty.fatalities.outdoor.stdv.*casualty.fatalities.outdoor.stdv);
toc, fprintf("Total Fatalities Computed \n"), tic

end
