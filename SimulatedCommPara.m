%========D GUO, Wake Forest University School of Medicine========
%this functin is to simulate people from all age levels.
%===input 1: [NumPopulation] Total population number we want to simulate
%===output 1:[CommunityPara] The parameter of the communities
%======================================================================
function ComPara=SimulatedCommPara(Ind)

DaycarePop = [];
SchoolPop = [];
WorkplacePop = [];
ShoppingPop = [];
%percensus = [0.073 0.173 0.629 0.125];

% kidspop = PopuCompose(1);
% youngpop = PopuCompose(2);
% adult = PopuCompose(3);
% oldpop = PopuCompose(4);

%=== calculate the corresponding number of daycares, schools, workplaces
%and shoppingcenters (assume there is only one shopping center in the city)

DaycarePop = [24 24];
SchoolPop = [261 261];
WorkplacePop = [100 100 100 100 100 100 100 100 100 100 100 100 139];
PublicPop = 544; % 50% percentage of population would like to go out in daytime

PopComm = [DaycarePop, SchoolPop, WorkplacePop, PublicPop];
totalnumofcomm = length(PopComm);

% thest parameters should be adjusted according to the experimental results
% and literatures
coefi = 5*[0.12 0.0003 0.017 0.001 0.0025]; %0.56
coefo = 2*[0.1 0.0003 0.017 0.001 0.0015]; %0.3
conratein = [coefi(1)*ones(1, length(DaycarePop)), coefi(2)*ones(1, length(SchoolPop)), coefi(3)*ones(1, length(WorkplacePop)), coefi(4)*ones(1, length(PublicPop))];
conrateout = [coefo(1)*ones(1, length(DaycarePop)), coefo(2)*ones(1, length(SchoolPop)), coefo(3)*ones(1, length(WorkplacePop)), coefo(4)*ones(1, length(PublicPop))];

switch Ind
    case 0 % for whole population
        ComPara = struct('number',  totalnumofcomm, ...
                 'population',  PopComm, ...
                 'conratein', conratein,...
                 'conrateout', conrateout,...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 1 % for daycare
        ComPara = struct('number',  length(DaycarePop), ...
                 'population',  DaycarePop, ...
                 'conratein', coefi(1)*ones(1, length(DaycarePop)),...
                 'conrateout', coefo(1)*ones(1, length(DaycarePop)),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 2 % for school
        ComPara = struct('number',  length(SchoolPop), ...
                 'population',  SchoolPop, ...
                 'conratein', coefi(2)*ones(1, length(SchoolPop)),...
                 'conrateout', coefo(2)*ones(1, length(SchoolPop)),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 3 % for workplace
        ComPara = struct('number',  length(WorkplacePop), ...
                 'population',  WorkplacePop, ...
                 'conratein', coefi(3)*ones(1, length(WorkplacePop)),...
                 'conrateout', coefo(3)*ones(1, length(WorkplacePop)),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission
    case 4 % for public area
        ComPara = struct('number',  length(PublicPop), ...
                 'population',  PublicPop, ...
                 'conratein', coefi(4)*ones(1, length(PublicPop)),...
                 'conrateout', coefo(4)*ones(1, length(PublicPop)),...
                 'alfa', 1,... % parameter indicating the transmission
                 'tao', 0.2,... % parameter indicating the transmission
                 'beta', 0.5,... % parameter indicating the transmission
                 'sigma', 0.6); % parameter indicating the transmission         
    otherwise 
        disp('Invalid input!')
end
end

