--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;

local items = {};

rdkp.Bidding = {

    ["StartBid"] = function(itemName, amount)

        if(items[itemName] and items[itemName].isOpen)
            rdkp:Print("Bidding has already started for " .. itemName .. " x" .. items[itemName].amount);
            return;
        end

        if(not amount or amount < 1) then
            amount = 1;
        end

        items[itemName] = {
            ["amount"] = amount,
            ["bids"] = {},
            ["isOpen"] = true,
            ["priority"] = 0
        };

        if(not rdkp.PrioTable[itemName]) then
            rdkp:Print("Item not in priority table. Bids will be evaluated without priority.");
        else
            items[itemname].priority = rdkp.PrioTable[itemName];
        end

        rdkp:Print("Bidding has started for " .. itemName .. " x" .. amount);
        SendChatMessage("Bidding has started for " .. itemName .. " x" .. amount , "RAID_WARNING" , languageIndex , "1");
    end,

    ["EndBid"] = function(itemName)
        if (not items[itemName]) then
            rdkp:Print("Bidding for " .. itemName .. " not found");
            return;
        elseif (not items[itemName].isOpen) then
            rdkp:Print("Bidding has already ended for " .. itemName);
            return;
        end

        items[itemName].isOpen = false;
        items[itemName].sortedBids = {};
        table.foreach (items[itemName].bids, function(k, v) table.insert(sortedBids, k) end);
        table.sort(items[itemName].sortedBids, sortFunction));

        rdkp:Print("All bids for " .. itemName .. ":");
        for i = 1, #items[itemName].sortedBids do
            playerName = items[itemName].sortedBids[i];
            rdkp:Print(i .. ". " .. playerName .. " - " .. items[itemName].bids[playerName].dkp);
        end

        winners = {};
        rdkp:Print("Winner(s) of " .. itemName .. ":");
        for i = 1, amount do
            winner = items[itemName].sortedBids[i];
            rdkp:Print(winner);
            rdkp.AddDKP(winner, -items[itemName].bids[winner].dkp);
        end

        SendChatMessage("Bidding has ended for " .. itemName .. " x" .. amount , "RAID" , languageIndex , "1");
        SendChatMessage("Winner(s) of " .. itemName .. ":" , "RAID" , languageIndex , "1");
        for i = 1, amount do
            winner = items[itemName].sortedBids[i];
            SendChatMessage(winner , "RAID" , languageIndex , "1");
            rdkp.AddDKP(winner, -items[itemName].bids[winner].dkp);
        end
    end,

    ["AddBid"] = function(itemName, playerName, dkp)
        if(rdkp.Database.Names[playerName]) then
            if(items[itemName]) then
                table.insert(items[itemName].bids, dkp)
            else
                dkp:Print(playerName .. " attempted to bid on " .. itemName .. " which currently not an open bid.");
            end
        else
            dkp:Print(playerName .. " does not exist in the database.")
        end  
    end,

    ["CancelBid"] = function(itemName)
        items[itemName] = nil;
        rdkp:Print("Bidding cancelled for " .. itemName);
    end,

    ["HandleBid"] = function(self, event, ...)
        
    end
}; 

local sortFunction = function(kA, kB) 
    playerA = items[itemName].sortedBids[kA];
    playerB = items[itemName].sortedBids[kB];
    priorityA = items[itemName].bids[playerA].priority;
    priorityB = items[itemName].bids[playerB].priority;
    dkpA = items[itemName].bids[playerA].dkp;
    dkpB = items[itemName].bids[playerB].dkp;
    if (priorityA == priorityB) then
        return dkpA > dkpB;
    else
        return priorityA;
    end
end

