%========D GUO, Wake Forest University School of Medicine========
%this functin is to determine any susceptible individuals who becomes
%intubating due to its neighbours.
%===input 1:[HomeMat] the matrix of home, the lower triangular components are all
%zeros
%===input 2:[InfectionPara]
%===input 3:[InfectedIDHome] IDs who have been contacted with infected id and becoming intubating due to their neighbours 
%===output 1:[IndividualId] indicates the status of all ids 
%======================================================================
function [PeopleId, reproductnumtemp]=IntubationProcessHome(HomeMat, InfectedId, InfectionPara, InfectedIDHome, awarenessHome, precautionHome,immuneresp)

global PeopleId
global MatPeopleId

InfectedDays = InfectionPara(1,InfectedId);  

[cDir,IacDir] = intersect(InfectedIDHome,InfectedId);
InfectedIDHome(IacDir) = [];
numinfectedp = [];
Pgotinfec = 0;
numinfectedp = length(InfectedId);

for iDir=1:length(InfectedIDHome)
    Idx = [];
    Idy = [];
    ContactInd = [];
    cc = [];
    Iac = [];
    s = 0;
    k = 0;
    AandInfe = 0;
    ProductAandInfe = 1;
    PHomeID = [];
    
    PHomeID = find(HomeMat==InfectedIDHome(iDir)); % patient home id
    HomeID = ceil(PHomeID/7);
    PopuHome = CheckHome(HomeMat,HomeID);
    if PopuHome~=1
        [cc,Iac] = intersect(HomeMat(:,HomeID), InfectedId); % find how many infectious patients in this home
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
        ContactInd = HomeMat(:, HomeID);
        ContactInd(find(ContactInd==0))=[];
        k = length(ContactInd);
    
        %HomePara = SimulatedHousePara(PopuHome);
        %    A = exp(-(HomePara.awareness+HomePara.precaution*((s/k)^HomePara.alfa))); % Now we assume awareness and precaution is same for people in the same community.
        A = exp(-(awarenessHome(InfectedIDHome(iDir))+precautionHome(InfectedIDHome(iDir))*((s/k)^1))); % awareness and precaution are dynamically change with days.
        if ~isempty(SignalInfectivity)
            for tSig = 1:length(SignalInfectivity)
                AandInfe = 1-A*SignalInfectivity(tSig);
                ProductAandInfe = AandInfe*ProductAandInfe;
            end      
        end
        lamda = 1-ProductAandInfe; 
    
        if (~isempty(MatPeopleId))&(~isempty(find(MatPeopleId(:,InfectedIDHome(iDir))==3)))
            PeopleId(InfectedIDHome(iDir)) = 0.5*immuneresp(InfectedIDHome(iDir))<lamda;   % if people got the influenza before in this flu season, he might has lower probability to get another one
            if(PeopleId(InfectedIDHome(iDir))==1)
                Pgotinfec = Pgotinfec +1;
            end
        else
            PeopleId(InfectedIDHome(iDir)) = 0.45*immuneresp(InfectedIDHome(iDir))<lamda; %lamda is critical parameter
            if(PeopleId(InfectedIDHome(iDir))==1)
                Pgotinfec = Pgotinfec +1;
            end
        end
    end
end
reproductnumtemp = Pgotinfec/numinfectedp;
end