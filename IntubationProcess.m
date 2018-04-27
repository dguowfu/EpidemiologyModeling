%========D GUO, Wake Forest University School of Medicine========
%this functin is to determine any susceptible individuals who becomes
%intubating due to its neighbours.
%===input 1:[CommunitiesMat] the matrix of communities, the lower triangular components are all
%zeros
%===input 2:[MatIdEDirect] individual ids who are contacted with infectious
%individuals 
%===input 3-5:[H1,J1,H2,J2,alfa,tao]parameters to calculate the probability that any susceptible individual becomes
%intubating due to its neighbours 
%===output 1:[IndividualId] indicates the status of all ids 
%======================================================================
function [PeopleId, reproductnumtemp]=IntubationProcess(CommunitiesMat, InfectedId, InfectionPara, MatIdEDirect, awarenessComm, precautionComm, immuneresp)

global PeopleId
global MatPeopleId

InfectedDays = InfectionPara(1,InfectedId);  

[cDir,IacDir] = intersect(MatIdEDirect,InfectedId);
MatIdEDirect(IacDir) = [];
numinfectedp = [];
Pgotinfec = 0;
numinfectedp = length(InfectedId);

for iDir=1:length(MatIdEDirect)
    Idx = [];
    Idy = [];
    ContactInd = [];
    cc = [];
    Iac = [];
    s = 0;
    k = 0;
    AandInfe = 0;
    ProductAandInfe = 1;

    Idx = find(CommunitiesMat(MatIdEDirect(iDir),:)==1);
    Idy = find(CommunitiesMat(:, MatIdEDirect(iDir))==1);
    ContactInd = [Idx'; Idy];
    ContactInd = sort(ContactInd, 'descend');
    [cc,Iac] = intersect(ContactInd,InfectedId); % above six lines: calculate s
    MatInfectivity = InfectivityCurve(InfectedId, InfectionPara);
    % find out the infectivity of the infected individual 
    SignalInfectivity = [];
    SInfectivity = 0;
    if ~isempty(cc)
        for lcc=1:length(cc)
            SInfectivity = MatInfectivity(find(InfectedId==cc(lcc))); % find out
            SignalInfectivity = [SignalInfectivity SInfectivity];
        end
    end
    
    s = length(Iac);
    ContactInd(Iac) = [];
    k = length(ContactInd);
%     CommID = CheckCommunity(MatIdEDirect(iDir));
%     ComPara = SimulatedCommPara(CommID);
    A = exp(-(awarenessComm(MatIdEDirect(iDir))+precautionComm(MatIdEDirect(iDir))*((s/k)^1))); % awareness and precaution are dynamically change with days.
    if ~isempty(SignalInfectivity)
        for tSig = 1:length(SignalInfectivity)
            AandInfe = 1-A*SignalInfectivity(tSig);
            ProductAandInfe = AandInfe*ProductAandInfe;
        end      
    end
    lamda = 1-ProductAandInfe;
    if (~isempty(MatPeopleId))&(~isempty(find(MatPeopleId(:,MatIdEDirect(iDir))==3)))
        PeopleId(MatIdEDirect(iDir)) = 0.5*immuneresp(MatIdEDirect(iDir))<lamda;   % if people got the influenza before in this flu season, he might has lower probability to get another one
        if(PeopleId(MatIdEDirect(iDir))==1)
            Pgotinfec = Pgotinfec +1;
        end
    else
        PeopleId(MatIdEDirect(iDir)) = 0.45*immuneresp(MatIdEDirect(iDir))<lamda; %lamda is critical parameter
        if(PeopleId(MatIdEDirect(iDir))==1)
            Pgotinfec = Pgotinfec +1;
        end
    end
    
end
reproductnumtemp = Pgotinfec/numinfectedp;
end