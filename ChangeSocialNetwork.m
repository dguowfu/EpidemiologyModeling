%========D GUO, Wake Forest University School of Medicine========
%this functin is to calculate people's infectivity.
%===inout 1: [infected days]
%===output 1:[Infectivity]
%======================================================================
function UsefulAdj=ChangeSocialNetwork(UsefulAdj, changepara)

Matposition0temp = [];
Matposition0 = [];

[dx1, dy1] = find(UsefulAdj==1);
Matposition1 = [dx1 dy1];
totalcontacttimes = length(dx1);
contemp1 = randperm(totalcontacttimes);
changeddata1 = Matposition1(contemp1(1:round(changepara*totalcontacttimes)),:);

for i1 = 1:size(changeddata1,1)
    UsefulAdj(changeddata1(i1,1), changeddata1(i1,2)) = 0;
end

for ik = 1:size(changeddata1,1)
    dx0 = changeddata1(ik, 1);
    temptt = find(UsefulAdj(dx0,:)==0); % find all zeros in this line
    temptt(find(temptt<=changeddata1(ik, 1))) = []; % make sure all zeros are in upper triangular matrix
    temptty = temptt-changeddata1(ik, 2); % in those columns, find the nearest one to changeddata1(ik, 2)
    temptty(find(temptty==0))=[]; % exclude changeddata1(ik,2) itself
    if ~isempty(temptty)
        temptty1 = abs(temptty);
        indty = find(temptty1==min(temptty1));
        randy = randperm(length(indty));
        dy0 = temptty(indty(randy(1)))+changeddata1(ik, 2);
        UsefulAdj(dx0, dy0)=1;
    else  % this case only happens when [dx0, dy0] is in the left lower corner
        dy0 = changeddata1(ik, 2);
        tempty = find(UsefulAdj(:, dy0)==0);
        dx0 = tempty(end-1);  
        UsefulAdj(dx0, dy0)=1;
    end
end

end





































