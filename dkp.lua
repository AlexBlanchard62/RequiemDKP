--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;
rdkp.DKP = {
    ["AddDKP"] = function(playerName, dkp){
        rdkp.Accounts[rdkp.Names[playerName]] = rdkp.Accounts[rdkp.Names[playerName]] + dkp;
    } 



}; -- adds Config table to addon namespace

