--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...; 

rdkp.Database = {
    ["InitDB"] = function() 
        rdkp:Print("Initializing DB");
        if(not rdkpNames) then
            rdkpNames = {};
        end;
        if(not rdkpAccounts) then
            rdkpAccounts = {};
        end;
        if(not rdkpRoles) then
            rdkpRoles = {};
        end;
        rdkp.Names = rdkpNames;
        rdkp.Accounts = rdkpAccounts;
        rdkp.Roles = rdkpRoles;
    end,

    ["UpdateAccounts"] = function()
        local numGuildMembers = GetNumGuildMembers();
        for i = 1, numGuildMembers do
            local fullName = GetGuildRosterInfo(i);
            if(not rdkp.Names[fullName]) then
                table.insert(rdkp.Accounts, 0);
                rdkp.Names[fullName] = (#rdkp.Accounts);
            end
        end
    end,

    ["MergeNames"] = function(nameOne, nameTwo)
        if(not rdkp.Names[nameOne]) then
            rdkp:Print(nameOne .. " does not exist in the Names table.");
        elseif(not rdkp.Names[nameTwo]) then
            rdkp:Print(nameTwo .. " does not exist in the Names table.");
        else
            local combinedDKP = rdkp.Accounts[rdkp.Names[nameOne]] + rkdp.Accounts[rdkp.Names[nameTwo]];
            if(rdkp.Names[nameOne] < rdkp.Names[nameTwo]) then
                rdkp.Accounts[rdkp.Names[nameOne]] = combinedDKP;
                rdkp.Accounts[rdkp.Names[nameTwo]] = 0;
                rdkp.Names[nameTwo] = rdkp.Names[namesOne];
            else
                rdkp.Accounts[rdkp.Names[nameTwo]] = combinedDKP;
                rdkp.Accounts[rdkp.Names[nameOne]] = 0;
                rdkp.Names[nameOne] = rdkp.Names[namesTwo];
            end
        end
    end,

    ["AddMember"] = function(name) 
        table.insert(rdkp.Accounts, 0);
        rdkp.Names[fullName] = #rdkp.Accounts;
    end,

    ["AddRole"] = function(playerName, roleName)
        if(not rdkp.RoleMap[roleName]) then
            local roleList = "";
            for key, _ in ipairs(rdkp.RoleMap) do
                roleList = roleList .. key .. " ";
            end
            rdkp:Print("The desired role does not exist. Try one of these: " .. roleList);
        elseif(rdkp.Roles[playerName]) then
            local oldRole = rdkp.Roles[playerName];
            rdkp.Roles[playerName] = roleName;
            rdkp:Print(playerName + "\'s role was changed from " .. oldRole .. " to " .. roleName .. ".");
        else
            rdkp.Roles[playerName] = roleName;
            rdkp:Print(playerName + "\'s role was set to " .. roleName .. ".");
        end
    end
}

rdkpRoleMap = {
    ["LootCouncil"] = -1;
    ["Mage"] = 1;
    ["Warlock"] = 2;
    ["HolyPriest"] = 4;
    ["DiscPriest"] = 4;
    ["ShadowPriest"] = 8;
    ["EleShaman"] = 16;
    ["EnhShaman"] = 32;
    ["RestoShamman"] = 64;
    ["BalanceDruid"] = 128;
    ["FeralDruid"] = 256;
    ["RestoDruid"] = 512;
    ["Hunter"] = 1024;
    ["FuryWarrior"] = 2048;
    ["ProtWarrior"] = 4096;
    ["Rogue"] = 8192;
}

-- example of SavedVariable table structures
-- rdkpNames = {
--     ["ZugZug"] = 1,
--     ["PriestGuy"] = 2,
--     ["Squirtle"] = 1
-- };
-- rdkpAccounts = {
--     [1] = 250,
--     [2] = 375
-- };
-- rdkpRoles = {
--     ["ZugZug"] = "Warrior",
--     ["PriestGuy"] = "Priest",
--     ["Squirtle"] = "Warrior"
-- };