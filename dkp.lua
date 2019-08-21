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

    ["DecayDKP"] = function(adjustment)
        local adjNum = tonumber(adjustment);
        local notANum = false;
        if(adjNum ~= nil) then
            notANum = false;
        end
        if(notANum or adjNum > 0 and adjNum < 1) then
            rdkp:Print(adjustment .. " is not a valid input for decay. Please use a decimal in between 0 and 1.");
            return;
        end
        for i=0,#rdkp.Accounts do
            rdkp.Accounts[i] = rdkp.Accounts[i] * (1 - adjNum);
        end
        rdkp:Print("DKP successfully decayed by an adjustment value of " .. adjustment);
    end,

    ["ReversDecayDKP"] = function(adjustment)
        local adjNum = tonumber(decay);
        local notANum = false;
        if(adjNum ~= nil) then
            notANum = false;
        end
        if(notANum or adjNum > 0 and adjNum < 1) then
            rdkp:Print(adjustment .. " is not a valid input for decay. Please use a decimal in between 0 and 1.");
            return
        end
        for i=0,#rdkp.Accounts do
            rdkp.Accounts[i] = rdkp.Accounts[i] / (1 - decayDecimal);
        end
        rdkp:Print("DKP decay successfully reversed by an adjustment value of " .. adjustment);
    end

}; -- adds Config table to addon namespace

