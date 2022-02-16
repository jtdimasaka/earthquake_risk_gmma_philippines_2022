%% GMMA Probabilistic Earthquake Risk Analysis
% Econometrics Analysis
% This module 

%% Initialize
clear, clc, close
tic
prefix = strrep(string(datetime(now,'ConvertFrom','datenum')),":","-");  

%% Import Data
load("C:\Users\dimas\OneDrive\Desktop\MA Thesis\04 Data Analysis\2022-02-14 Econometrics\statainputbrgy.mat")
toc, fprintf("Brgy Data Imported \n"), tic

load("C:\Users\dimas\OneDrive\Desktop\MA Thesis\04 Data Analysis\2022-02-14 Econometrics\statainputmun.mat")
toc, fprintf("Mun Data Imported \n"), tic

%% Economic (Building) Loss Ratio vs ln(PGA)
modelspec = 'econlossratio ~ lpga';
mdlmun = fitlm(statainputmun,modelspec);
fig1 = figure(1);
scatter(statainputmun.pga,statainputmun.econlossratio,6,'filled'); hold on;
a = min(statainputmun.pga):0.01:max(statainputmun.pga);
b = mdlmun.Coefficients.Estimate(1) + mdlmun.Coefficients.Estimate(2).*log(a);
plot(a,b);
xlim([0 1]); ylim([0 0.8]); grid on; box on
legend('Raw Data','Fitted Line', 'location','southeast')
xlabel('Peak Ground Acceleration (in g)')
ylabel('Economic (Building) Loss Ratio')
saveas(fig1,strcat(prefix,' Economic Loss vs lnPGA'))

%% Social (Slight Injuries) Loss Ratio vs PGA
modelspec1 = 's1ratio ~ pga-1';
mdlmun1 = fitlm(statainputmun,modelspec1);

%% Social (Serious Injuries) Loss Ratio vs PGA
modelspec2 = 's2ratio ~ pga-1';
mdlmun2 = fitlm(statainputmun,modelspec2);

%% Social (Life-threatening Injuries) Loss Ratio vs PGA
modelspec3 = 's3ratio ~ pga-1';
mdlmun3 = fitlm(statainputmun,modelspec3);

%% Social (Fatalities) Loss Ratio vs PGA
modelspec4 = 's4ratio ~ pga-1';
mdlmun4 = fitlm(statainputmun,modelspec4);

fig2 = figure(2);
subplot(2,2,1)
    scatter(statainputmun.pga,statainputmun.s1ratio,6,'filled'); hold on;
    plot(statainputmun.pga,mdlmun1.Fitted);
    xlim([0 1]); ylim([0 0.1]); grid on; box on
    legend('Raw Data','Fitted Line', 'location','southeast')
    title('Slight Injuries')
subplot(2,2,2)
    scatter(statainputmun.pga,statainputmun.s2ratio,6,'filled'); hold on;
    plot(statainputmun.pga,mdlmun2.Fitted);
    xlim([0 1]); ylim([0 0.04]); grid on; box on
    legend('Raw Data','Fitted Line', 'location','southeast')
    title('Serious Injuries')
subplot(2,2,3)
    scatter(statainputmun.pga,statainputmun.s3ratio,6,'filled'); hold on;
    plot(statainputmun.pga,mdlmun3.Fitted);
    xlim([0 1]); ylim([0 0.02]); grid on; box on
    legend('Raw Data','Fitted Line', 'location','southeast')
    title('Life-threatening Injuries')
subplot(2,2,4)
    scatter(statainputmun.pga,statainputmun.s4ratio,6,'filled'); hold on;
    plot(statainputmun.pga,mdlmun4.Fitted);
    xlim([0 1]); ylim([0 0.01]); grid on; box on
    legend('Raw Data','Fitted Line', 'location','southeast')
    title('Fatalities')
han=axes(fig2,'visible','off'); 
han.Title.Visible='on';
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Casualty');
xlabel(han,'Peak Ground Acceleration (in g)');
saveas(fig2,strcat(prefix,' Casualty vs PGA'))


%% Save the File
filename = strrep(string(datetime(now,'ConvertFrom','datenum')),":","-");
save(filename)
toc, fprintf("Saved \n")

%% Data Restriction and Privacy Statement
% Raymond Reynolds (2022). Plot confidence intervals (https://www.mathworks.com/matlabcentral/fileexchange/13103-plot-confidence-intervals), MATLAB Central File Exchange. Retrieved February 16, 2022.

%% Contact Information
% Joshua T. Dimasaka
% Public Policy Program
% Stanford University
% dimasakajoshua@gmail.com