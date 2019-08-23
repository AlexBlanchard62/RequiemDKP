--------------------------------------
-- Namespace
--------------------------------------
local _, rdkp = ...;

bidItems = {};

rdkp.Bidding = {
    ["IsOpenForBid"] = function(itemName)
        return not not bidItems[itemName];
    end,

    ["ParseBidAndStartBidInput"] = function(...)
        local input = "";
		for i = 1, select('#', ...) do
			local msg = select(i, ...)
			input = input .. msg;
			if(i ~= select('#', ...)) then
				input = input .. " ";
			end
		end
		local trueInput = string.match(input, '%[.+]%s*%d*');
		if(input ~= trueInput) then
			return nil, nil;
		end
        local itemName = string.match(input,'%[.+%]');
        local amount = string.match(input,'%d+$');
        if(not amount) then
            return itemName, nil;
        else
            return itemName, tonumber(amount);
        end
    end,
    

    ["StartBid"] = function(itemName, amount)
        if(not itemName) then
            rdkp:Print("Invalid input to start bid. (/rdkp start [item name] amount) ('amount' is optional)");
        end
        if(not amount) then
            amount = 1;
        end

        if(bidItems[itemName] and bidItems[itemName].isOpen) then
            rdkp:Print("Bidding has already started for " .. itemName .. " x " .. bidItems[itemName].amount);
            return;
        end

        if(not rdkp.PrioTable[itemName]) then
            rdkp:Print("Item not in priority table. Bids will be evaluated without priority.");
            bidItems[itemName] = {
                ["amount"] = amount,
                ["bids"] = {},
                ["isOpen"] = true,
                ["priority"] = 0;
            };
        else
            bidItems[itemName] = {
                ["amount"] = amount,
                ["bids"] = {},
                ["isOpen"] = true,
                ["priority"] = rdkp.PrioTable[itemName]
            };
        end

        --rdkp:Print("Bidding has started for " .. itemName .. " x" .. amount);
        SendChatMessage("Bidding has started for " .. itemName .. " x" .. amount , "RAID" , nil , "1");
        SendChatMessage("Bidding has started for " .. itemName .. " x" .. amount , "RAID_WARNING" , nil , "1");
    end,

    ["ParseEndBidInput"] = function(...)
        local input = "";
		for i = 1, select('#', ...) do
			local msg = select(i, ...)
			input = input .. msg;
			if(i ~= select('#', ...)) then
				input = input .. " ";
			end
		end
		local trueInput = string.match(input, '%[.+]');
		if(input == trueInput) then
            return input;
		else
            return nil;
        end
    end,

    ["AddBid"] = function(itemName, playerName, dkp)
        if((not itemName or not dkp)) then 
            rdkp:MessagePlayer("Invalid input for bid. (/rdkp bid [itemName] dkp)", playerName);
            return;
        end

        if(rdkp.Names[playerName]) then
            if(bidItems[itemName]) then
                if(rdkp.Accounts[rdkp.Names[playerName]] < tonumber(dkp)) then
                    rdkp:MessagePlayer("You do not have " .. tonumber(dkp) .. " to spend. Your dkp: " .. tostring(rdkp.Accounts[rdkp.Names[playerName]]), playerName);
                    return;
                end

                bidItems[itemName].bids[tostring(playerName)] = tonumber(dkp);
                rdkp:MessagePlayer("You have bid " .. dkp .. " dkp on " .. itemName .. ".", playerName);
            else
                rdkp:MessagePlayer("You attempted to bid on " .. itemName .. " which currently not an open bid.", playerNAme);
            end
        else
            local guildName = GetGuildInfo();
            rdkp:MessagePlayer("You does not exist in " .. guildName .. "'s the database. Contact GM to be added.", playerName)
        end
        
    end,

    ["EndBid"] = function(itemName)
        if(not itemName) then
            rdkp:Print("Invalid input.");
            return;
        elseif(not bidItems[itemName]) then
            rdkp:Print("Bidding for " .. itemName .. " not found");
            return;
        else
            rdkp:Print("Bidding for " .. itemName .. " is now over.");
        end

        bidItems[itemName].isOpen = false;
        bidItems[itemName].sortedBids = {};
        local count = 0;
        for _ in pairs(bidItems[itemName].bids) do count = count + 1 end
        if(count == 0)then
            SendChatMessage("There were no bids submitted for " .. itemName .. ". Bidding for " .. itemName .. " is now over.", "RAID" , nil , "1");
            --rdkp:Print("There were no bids submitted for " .. itemName .. ". Bidding for " .. itemName .. " is now over.");
            return;
        end

        table.foreach(bidItems[itemName].bids, function(k, v) table.insert(bidItems[itemName].sortedBids, k) end);
        table.sort(bidItems[itemName].sortedBids, sortFunction);

        SendChatMessage("All bids for " .. itemName .. ":", "RAID" , nil , "1");
        --rdkp:Print("All bids for " .. itemName .. ":");
        for i = 1, #bidItems[itemName].sortedBids do
            playerName = bidItems[itemName].sortedBids[i];
            SendChatMessage("All bids for " .. itemName .. ":", "RAID" , nil , "1");
            --rdkp:Print(tostring(i) .. ". " .. playerName .. " - " .. tostring(bidItems[itemName].bids[playerName]));
        end

        local numWinners = bidItems[itemName].amount;
        local isSurplus = #bidItems[itemName].sortedBids < bidItems[itemName].amount;

        if (isSurplus) then numWinners = #bidItems[itemName].sortedBids end

        SendChatMessage("Winner(s) of " .. itemName .. ":", "RAID" , nil , "1");
        --rdkp:Print("Winner(s) of " .. itemName .. ":");
        for i = 1, numWinners do
            if (i > #bidItems[itemName].sortedBids[i]) then break end
            winner = bidItems[itemName].sortedBids[i];
            SendChatMessage(winner, "RAID" , nil , "1");
            --rdkp:Print(winner);
            rdkp.DKP.AddDKP(winner, -bidItems[itemName].bids[tostring(winner)]);
        end
        
        if (isSurplus) then
            SendChatMessage((bidItems[itemName].amount - numWinners) .. " left over after bidding.", "RAID" , nil , "1");
            --rdkp:Print((bidItems[itemName].amount - numWinners) .. " left over after bidding.")
        end
    end,

    ["CancelBid"] = function(itemName)
        bidItems[itemName] = nil;
        SendChatMessage("Bidding cancelled for " .. itemName, "RAID" , nil , "1");
        rdkp:Print("Bidding cancelled for " .. itemName);
    end,

    ["GetOpenBids"] = function()
        rdkp:Print(bidItems["[Circlet of Prophecy]"].priority);
        for key, val in ipairs(bidItems) do
            rdkp:Print(type(key));
            rdkp:Print(type(val));
        end
    end
    
}; 

function rdkp:MessagePlayer(message, playerName)
    if(rdkp:PlayerIsMe(playerName)) then
        rdkp:Print(message);
    else
        SendChatMessage(message , playerName , nil , "1");
    end
end

function rdkp:PlayerIsMe(playerName)
    local name = string.match(playerName, UnitName("player"));
    rdkp:Print(name);
    return name ~= nil; -- REMOVE THIS FOR CLASSIC
        --return playerName == UnitName("player")        -- UNCOMMENT THIS FOR CLASSIC
end

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

