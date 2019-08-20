--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;
rdkp.DKP = {
    ["AddDKP"] = function(playerName, dkp)
        rdkp.Accounts[rdkp.Names[playerName]] = rdkp.Accounts[rdkp.Names[playerName]] + dkp;
        if(rdkp.Accounts[rdkp.Names[playerName]] < 0) then
            rdkp.Accounts[rdkp.Names[playerName]] = 0;
        end
    end,
    
    ["DistributeDKP"] = function(dkp)
        local dkpNum = tonumber(dkp);
        if(dkpNum == nil) then
            return;
        end
        rdkp.Database.UpdateAccounts();
        local numGuildMembers = GetNumGuildMembers();
        local onlineMembers = {};
        for i = 1, numGuildMembers do
            local name, rank, rankIndex, level, class, zone, note, officernote, online = GetGuildRosterInfo(i);
            if(online) then
                table.insert(onlineMembers, name);
            end
        end
        for i = 1, #onlineMembers do
            rdkp.Accounts[rdkp.Names[onlineMembers[i]]] = rdkp.Accounts[rdkp.Names[onlineMembers[i]]] + dkpNum;
            if(rdkp.Accounts[rdkp.Names[onlineMembers[i]]] < 0) then
                rdkp.Accounts[rdkp.Names[onlineMembers[i]]] = 0;
            end 
        end
    end,

}; -- adds Config table to addon namespace

