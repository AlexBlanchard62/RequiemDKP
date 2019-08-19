--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;

rdkp.BidItems = {};

rdkp.Bidding = {

    ["StartBid"] = function(itemName, amount)

        if(rdkp.BidItems[itemName] and rdkp.BidItems[itemName].isOpen)
            rdkp:Print("Bidding has already started for " .. itemName .. " x" .. rdkp.BidItems[itemName].amount);
            return;
        end

        if(not amount or amount < 1) then
            amount = 1;
        end

        rdkp.BidItems[itemName] = {
            ["amount"] = amount,
            ["bids"] = {},
            ["isOpen"] = true,
            ["priority"] = 0
        };

        if(not rdkp.PrioTable[itemName]) then
            rdkp:Print("Item not in priority table. Bids will be evaluated without priority.");
        else
            rdkp.BidItems[itemname].priority = rdkp.PrioTable[itemName];
        end

        rdkp:Print("Bidding has started for " .. itemName .. " x" .. amount);
        SendChatMessage("Bidding has started for " .. itemName .. " x" .. amount , "RAID_WARNING" , nil , "1");
    end,

    ["EndBid"] = function(itemName)
        if (not rdkp.BidItems[itemName]) then
            rdkp:Print("Bidding for " .. itemName .. " not found");
            return;
        elseif (not rdkp.BidItems[itemName].isOpen) then
            rdkp:Print("Bidding has already ended for " .. itemName);
            return;
        end

        rdkp.BidItems[itemName].isOpen = false;
        rdkp.BidItems[itemName].sortedBids = {};
        table.foreach (rdkp.BidItems[itemName].bids, function(k, v) table.insert(sortedBids, k) end);
        table.sort(rdkp.BidItems[itemName].sortedBids, sortFunction));

        rdkp:Print("All bids for " .. itemName .. ":");
        for i = 1, #rdkp.BidItems[itemName].sortedBids do
            playerName = rdkp.BidItems[itemName].sortedBids[i];
            rdkp:Print(i .. ". " .. playerName .. " - " .. rdkp.BidItems[itemName].bids[playerName].dkp);
        end

        winners = {};
        rdkp:Print("Winner(s) of " .. itemName .. ":");
        for i = 1, amount do
            winner = rdkp.BidItems[itemName].sortedBids[i];
            rdkp:Print(winner);
            rdkp.AddDKP(winner, -rdkp.BidItems[itemName].bids[winner].dkp);
        end

        SendChatMessage("Bidding has ended for " .. itemName .. " x" .. amount , "RAID" , nil , "1");
        SendChatMessage("Winner(s) of " .. itemName .. ":" , "RAID" , nil , "1");
        for i = 1, amount do
            winner = rdkp.BidItems[itemName].sortedBids[i];
            SendChatMessage(winner , "RAID" , nil , "1");
            rdkp.AddDKP(winner, -rdkp.BidItems[itemName].bids[winner].dkp);
        end
    end,

    ["AddBid"] = function(itemName, playerName, dkp)
        if(rdkp.Database.Names[playerName]) then
            if(rdkp.BidItems[itemName]) then
                table.insert(rdkp.BidItems[itemName].bids, dkp)
            else
                dkp:Print(playerName .. " attempted to bid on " .. itemName .. " which currently not an open bid.");
            end
        else
            dkp:Print(playerName .. " does not exist in the database.")
        end  
    end,

    ["CancelBid"] = function(itemName)
        rdkp.BidItems[itemName] = nil;
        rdkp:Print("Bidding cancelled for " .. itemName);
    end
}; 

local sortFunction = function(kA, kB) 
    playerA = rdkp.BidItems[itemName].sortedBids[kA];
    playerB = rdkp.BidItems[itemName].sortedBids[kB];
    priorityA = rdkp.BidItems[itemName].bids[playerA].priority;
    priorityB = rdkp.BidItems[itemName].bids[playerB].priority;
    dkpA = rdkp.BidItems[itemName].bids[playerA].dkp;
    dkpB = rdkp.BidItems[itemName].bids[playerB].dkp;
    if (priorityA == priorityB) then
        return dkpA > dkpB;
    else
        return priorityA;
    end
end

