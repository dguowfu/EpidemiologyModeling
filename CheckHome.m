%========D GUO, Wake Forest University School of Medicine========
%this functin is to find out which community an individual comes from.
%===input 1:[ComPara]
%===input 2:[IndividualID]
%===output 1:[ComunityID]
%======================================================================
function homepopnum=CheckHome(HomeMat,HomeID)

zeronum = length(find(HomeMat(:,HomeID)==0));
homepopnum = size(HomeMat,1)-zeronum;

end