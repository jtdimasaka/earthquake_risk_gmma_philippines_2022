function [exposure] = loadexposuredata(data)

exposure = struct;

% Building or Area Name, Land Use Type, and Area
exposure.Name = string(table2array(data(:,1)));
exposure.LandUse5 = string(table2array(data(:,2)));
exposure.LandUse4 = string(table2array(data(:,3)));
exposure.LandArea = table2array(data(:,4));

% Storey Information
exposure.Storey.max = table2array(data(:,8));
exposure.Storey.min = table2array(data(:,9));
exposure.Storey.range = table2array(data(:,10));
exposure.Storey.median = table2array(data(:,11));
exposure.Storey.majority = table2array(data(:,12));
exposure.Storey.minority = table2array(data(:,13));
exposure.Storey.mean = table2array(data(:,14));
exposure.Storey.stddev = table2array(data(:,15));

% Area, by Structural Classification
exposure.Area.stlabels = [      "W1";...    $ Wood Light-frame 1 (<=5000 sq.ft.)
                                "W2";...    % Wood Light-frame 2 (> 5000 sq.ft.)
                                "W3";...    % Bamboo Hut
                                "N";...     % Makeshift/Informal
                                "CHB";...   % Concrete Hollow Block
                                "URA";...   % Unreinforced Adobe Walls
                                "URM";...   % Unreinforced Masonry Walls
                                "RM1";...   % Reinforced Masonry Bearing Walls with Wood or Metal Deck Diaphragms
                                "RM2";...   % Reinforced Masonry Bearing Walls with Precast Concrete Diaphragms
                                "MWS";...   % Concrete Hollow Blocks with Wood or Light Metal
                                "CWS";...   % Concrete with Steel
                                "C1";...    % Reinforced Concrete Moment Frame 1
                                "C2";...    % Reinforced Concrete Moment Frame 2
                                "C4";...    % Concrete Shear Walls and Frames
                                "PC1";...   % Precast Concrete Tilt-Up Walls
                                "PC2";...   % Precast Concrete Frames with Concrete Shear Walls
                                "S1";...    % Steel Moment Frames
                                "S2";...    % Steel Braced Frames
                                "S3";...    % Steel Light Frames
                                "S4"];      % Steel Frames with Cast-in-place Concrete Shear Walls
exposure.Area.st = table2array(data(:,16:35));

% Area, by Height
exposure.Area.htlabels = [	"L1";...    $ 1
                                "L2";...    % 2
                                "M";...     % 3-7
                                "H";...     % 8-15
                                "V";...     % 16-25
                                "E";...     % 26-35
                                "S"];       % 36-higher
exposure.Area.ht = table2array(data(:,36:42));

% Era, Construction
exposure.era = table2array(data(:,45));

% Municipality/City - Barangay
exposure.brgy = table2array(data(:,46));

% Area, by Height, by Structural Classification
exposure.Area.sthtlabels(:,1) = repmat(exposure.Area.stlabels',[1, numel(exposure.Area.htlabels)])';
exposure.Area.sthtlabels(:,2) = repelem(exposure.Area.htlabels', numel(exposure.Area.stlabels))';
exposure.Area.stht = table2array(data(:,47:186));

% Population Density
exposure.Area.polygon = table2array(data(:,7));
exposure.popdensity.mean = table2array(data(:,284));
exposure.popdensity.stdv =table2array(data(:,286));
exposure.pop.mean = table2array(data(:,44)).*(1.0097^7);

end

