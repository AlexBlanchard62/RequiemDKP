--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;

local bidItems = {};

rdkp.Bidding = {
    ["IsOpenForBid"] = function(itemName)
        return not not bidItems[itemName];
    end,

    ["StartBid"] = function(itemName, amount)

        if(bidItems[itemName] and bidItems[itemName].isOpen) then
            rdkp:Print("Bidding has already started for " .. itemName .. " x" .. bidItems[itemName].amount);
            return;
        end

        if(not amount or amount < 1) then
            amount = 1;
        end

        bidItems[itemName] = {
            ["amount"] = amount,
            ["bids"] = {},
            ["isOpen"] = true,
            ["priority"] = 0
        };

        if(not rdkp.PrioTable[itemName]) then
            rdkp:Print("Item not in priority table. Bids will be evaluated without priority.");
        else
            bidItems[itemname].priority = rdkp.PrioTable[itemName];
        end

        rdkp:Print("Bidding has started for " .. itemName .. " x" .. amount);
        SendChatMessage("Bidding has started for " .. itemName .. " x" .. amount , "RAID_WARNING" , nil , "1");
    end,

    ["EndBid"] = function(itemName)
        if (not bidItems[itemName]) then
            rdkp:Print("Bidding for " .. itemName .. " not found");
            return;
        elseif (not bidItems[itemName].isOpen) then
            rdkp:Print("Bidding has already ended for " .. itemName);
            return;
        end

        bidItems[itemName].isOpen = false;
        bidItems[itemName].sortedBids = {};
        table.foreach (bidItems[itemName].bids, function(k, v) table.insert(sortedBids, k) end);
        table.sort(bidItems[itemName].sortedBids, sortFunction);

        rdkp:Print("All bids for " .. itemName .. ":");
        for i = 1, #bidItems[itemName].sortedBids do
            playerName = bidItems[itemName].sortedBids[i];
            rdkp:Print(i .. ". " .. playerName .. " - " .. bidItems[itemName].bids[playerName].dkp);
        end

        winners = {};
        rdkp:Print("Winner(s) of " .. itemName .. ":");
        for i = 1, amount do
            winner = bidItems[itemName].sortedBids[i];
            rdkp:Print(winner);
            rdkp.AddDKP(winner, -bidItems[itemName].bids[winner].dkp);
        end

        SendChatMessage("Bidding has ended for " .. itemName .. " x" .. amount , "RAID" , nil , "1");
        SendChatMessage("Winner(s) of " .. itemName .. ":" , "RAID" , nil , "1");
        for i = 1, amount do
            winner = bidItems[itemName].sortedBids[i];
            SendChatMessage(winner , "RAID" , nil , "1");
            rdkp.AddDKP(winner, -bidItems[itemName].bids[winner].dkp);
        end
    end,

    ["AddBid"] = function(itemName, playerName, dkp)
        if(rdkp.Database.Names[playerName]) then
            if(bidItems[itemName]) then
                table.insert(bidItems[itemName].bids, dkp)
            else
                dkp:Print(playerName .. " attempted to bid on " .. itemName .. " which currently not an open bid.");
            end
        else
            dkp:Print(playerName .. " does not exist in the database.")
        end  
    end,

    ["CancelBid"] = function(itemName)
        bidItems[itemName] = nil;
        rdkp:Print("Bidding cancelled for " .. itemName);
    end
}; 

local sortFunction = function(kA, kB) 
    playerA = bidItems[itemName].sortedBids[kA];
    playerB = bidItems[itemName].sortedBids[kB];
    priorityA = bidItems[itemName].bids[playerA].priority;
    priorityB = bidItems[itemName].bids[playerB].priority;
    dkpA = bidItems[itemName].bids[playerA].dkp;
    dkpB = bidItems[itemName].bids[playerB].dkp;
    if (priorityA == priorityB) then
        return dkpA > dkpB;
    else
        return priorityA;
    end
end

