function [hazard] = loadhazarddata(data)

hazard = struct;
hazard.returnperiod = [ 0.0004;...
                        0.0005;...
                        0.000667;...
                        0.001;...
                        0.00133;...
                        0.002;...
                        0.004;...
                        0.01];
hazard.PGA.count = table2array(data(:,[191, 202, 213, 224, 235, 246, 257, 268]));
hazard.PGA.min = table2array(data(:,[192, 203, 214, 225, 236, 247, 258, 269]));
hazard.PGA.max = table2array(data(:,[193, 204, 215, 226, 237, 248, 259, 270]));
hazard.PGA.range = table2array(data(:,[194, 205, 216, 227, 238, 249, 260, 271]));
hazard.PGA.mean = table2array(data(:,[196, 207, 218, 229, 240, 251, 262, 273]));
hazard.PGA.mean_old = table2array(data(:,[196, 207, 218, 229, 240, 251, 262, 273]));
hazard.PGA.median = table2array(data(:,[197, 208, 219, 230, 241, 252, 263, 274]));
hazard.PGA.stddev = table2array(data(:,[198, 209, 220, 231, 242, 253, 264, 275]));

load("20220125 PGA Corrected.mat")
hazard.PGA.mean = new_pga;
hazard.MMI.mean = 3.33*log10(hazard.PGA.mean*980.665)-0.47;

end

