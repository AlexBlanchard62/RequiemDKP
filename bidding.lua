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

        rdkp:Print("Bidding has started for " .. itemName .. " x" .. amount);
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

    ["EndBid"] = function(itemName)
        if(not itemName) then
            rdkp:Print("Invalid input.");
            return;
        elseif(not bidItems[itemName]) then
            rdkp:Print("Bidding for " .. itemName .. " not found");
            return;
        elseif(not bidItems[itemName].isOpen) then
            rdkp:Print("Bidding has already ended for " .. itemName);
            return;
        end

        bidItems[itemName].isOpen = false;
        bidItems[itemName].sortedBids = {};
        if(#bidItems[itemName].bids == 0)then
            rdkp:Print("There were no bids submitted for " .. itemName .. ". Bidding for this item is now over.");
            return;
        end

        table.foreach(bidItems[itemName].bids, function(k, v) table.insert(bidItems[itemName].sortedBids, k) end);
        table.sort(bidItems[itemName].sortedBids, sortFunction);

        rdkp:Print("All bids for " .. itemName .. ":");
        for i = 1, #bidItems[itemName].sortedBids do
            playerName = bidItems[itemName].sortedBids[i];
            rdkp:Print(tostring(i) .. ". " .. playerName .. " - " .. tostring(bidItems[itemName].bids[playerName]));
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
        if((not itemName or not dkp) and string.match(playerName, UnitName("player"))) then -- REMOVE THIS FOR CLASSIC
        --if((not itemName or not dkp) and playerName == UnitName("player")) then           -- UNCOMMENT THIS FOR CLASSIC
            SendChatMessage("Invalid input for bid. (/rdkp bid [itemName] dkp)" , playerName , nil , "1");
        end

        if(rdkp.Names[playerName]) then
            if(bidItems[itemName]) then
                local bid = {[playerName] = dkp}
                table.insert(bidItems[itemName].bids, bid);
                if(string.match(playerName, UnitName("player"))) then -- REMOVE THIS FOR CLASSIC
                --if(playerName == UnitName("player")) then           -- UNCOMMENT THIS FOR CLASSIC
                    rdkp:Print("You have bid " .. dkp .. " dkp on " .. itemName .. ".");
                else
                    SendChatMessage("You have bid " .. dkp .. " dkp on " .. itemName .. ".", playerName , nil , "1");
                end
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
    end,

    ["GetOpenBids"] = function()
        rdkp:Print(bidItems["[Circlet of Prophecy]"].priority);
        for key, val in ipairs(bidItems) do
            rdkp:Print(type(key));
            rdkp:Print(type(val));
        end
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

