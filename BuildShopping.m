%========D GUO, Wake Forest University School of Medicine========
%this functin is to create a network, including several communities.
%===input 1:[NumofCommunities] the number of communities
%zeros
%===input 2:[InfectiousID] infectious id in the matrix of communities
%===output 1:[InfectionMat] the infected id and the corresponding
%id of infectious source
%===output 2:[InfectedID] the infected id
%======================================================================
function adjShopping=BuildShopping(PopShopping)

Indiciator = 5;
ShoppingComPara=SimulatedCommPara(Indiciator); % Indiciator is used to indiciate if the community is Shopping center, School, Workplace, Daycare, etc.,

NumofComm = 1;
NumofPopulation = PopShopping;
ConRateinC = ShoppingComPara.conratein;
ConRateoutC = ShoppingComPara.conrateout; 

adjShopping = [];

SimShoppingMat = zeros(sum(NumofPopulation), sum(NumofPopulation)); % for the whole matrix
SimShoppingMatS = mat2cell(SimShoppingMat, NumofPopulation, NumofPopulation); % split into several submatrix

if NumofComm==1
    BetweenComuID = [];
else
    BetweenComuID = combntns(1:NumofComm,2);
end

for num=1:NumofComm
    tempMat = [];
    tempMat = cell2mat(SimShoppingMatS(num, num)); 
    for i=1:NumofPopulation(num)
        for j=i:NumofPopulation(num)-1
            tempMat(i,j+1)=rand(1)<ConRateinC(num);
            tempMat(j+1,i)=tempMat(i, j+1);
        end
    end
    SimShoppingMatS(num, num) = mat2cell(tempMat);
end

if ~isempty(BetweenComuID)
    for numbe=1:size(BetweenComuID,1)
        tempMat = [];
        tempid = BetweenComuID(numbe,:);
        a = tempid(1);
        b = tempid(2);
        tempMat = cell2mat(SimShoppingMatS(a,b)); 
        tempMat = rand(NumofPopulation(BetweenComuID(numbe, 1)), NumofPopulation(BetweenComuID(numbe, 2)))<ConRateoutC(num);
        SimShoppingMatS(a,b) = mat2cell(double(tempMat));
        SimShoppingMatS(b,a) = mat2cell(double(tempMat'));
    end
end
adjShopping = cell2mat(SimShoppingMatS);

end