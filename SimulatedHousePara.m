%========D GUO, Wake Forest University School of Medicine========
%this functin is to simulate people from all age levels.
%===input 1: [NumPopulation] Total population number we want to simulate
%===output 1:[CommunityPara] The parameter of the communities
%======================================================================
function HousePara=SimulatedHousePara(Ind)

awareness = 4*[0.017 0.017 0.197 0.297 0.297 0.297 0.297];
precaution = 6*[0.097 0.097 0.057 0.047 0.037 0.027 0.027];
conratein = 2.8*[0.056 0.056 0.056 0.056 0.056 0.056 0.056];
%conrateout = [0.025 0.035 0.045 0.045 0.055 0.055];

switch Ind
    case 1 % for home 1
        HousePara = struct('awareness', awareness(1), ...
                 'precaution', precaution(1),...
                 'conratein', conratein(1),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 2 % for home 2
        HousePara = struct('awareness', awareness(2), ...
                 'precaution', precaution(2),...
                 'conratein', conratein(2),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 3 % for home 3
        HousePara = struct('awareness', awareness(3), ...
                 'precaution', precaution(3),...
                 'conratein', conratein(3),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 4 % for home 4
        HousePara = struct('awareness', awareness(4), ...
                 'precaution', precaution(4),...
                 'conratein', conratein(4),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 5 % for home 5
        HousePara = struct('awareness', awareness(5), ...
                 'precaution', precaution(5),...
                 'conratein', conratein(5),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 6 % for home 6
        HousePara = struct('awareness', awareness(6), ...
                 'precaution', precaution(6),...
                 'conratein', conratein(6),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 7 % for home 6
        HousePara = struct('awareness', awareness(7), ...
                 'precaution', precaution(7),...
                 'conratein', conratein(7),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission            
    otherwise 
        disp('Invalid input!')
end
end