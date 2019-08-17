--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;
rdkp.DKP = {
    ["AddDKP"] = function(playerName, dkp)
        rdkp.Accounts[rdkp.Names[playerName]] = rdkp.Accounts[rdkp.Names[playerName]] + dkp;
    end,
    
    ["DistributeDKP"] = function(dkp)
        rdkp.Database.UpdateAccounts();
        for _, accountDkp in ipairs(rdkp.Accounts) do
            accountDkp = accountDkp + dkp;
        end
    end,

}; -- adds Config table to addon namespace

