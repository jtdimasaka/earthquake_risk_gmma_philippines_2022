function [unitcost] = loadunitcost()

% Structural Classification
unitcost.stlabels = [	"W1";...    $ Wood Light-frame 1 (<=5000 sq.ft.)
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

% Unit Cost (Pesos per Square Meter)
unitcost.value = [      6360;
                        6360;
                        6360;
                        1360;
                        7380;
                        8120;
                        8120;
                        8750;
                        9750;
                        6820;
                        10220;
                        15000;
                        20000;
                        22500;
                        20000;
                        22500;
                        34080;
                        40000;
                        25000;
                        27500];

end

