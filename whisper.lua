----------------------
-- Namespace
----------------------
local _, rdkp = ...; 

function rdkp:HandleWhipserfunction(self, event, ...)
	local text, playerName, languageName, channelName, playerName2, 
	specialFlags, zoneChannelID, channelID, channelBaseName, unused,
	lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterBox,
	supressRaidIcons = ...;

	local args = rdkp.split(text);

	if (args[1] == "rdkp") then

		local guildName = GetGuildInfo();

		if(not rdkp.Names[playerName]) then
			SendChatMessage("You are not in " .. guildName .. "'s database. Speak with GM to be added." , playerName , nil , "1");
		end

		if(args[2] == "getdkp") then 
			if(args[3] != nil) then
				if(rdkp.Names[args[3]]) then
					SendChatMessage( args[3] .. "'s dkp: " .. rdkp.Accounts[rdkp.Names[args[3]]], playerName , nil , "1");
				else
					SendChatMessage( args[3] .. " does not exist in " .. guildName .. "'s Database.", playerName , nil , "1");
				end
			else
				SendChatMessage("Your DKP: " .. rdkp.Accounts[rdkp.Names[playerName]], playerName , nil , "1");
			end
		end

		if(args[2] == "bid") then
			if(not rdkp.BidItems[args[3]]) then
				SendChatMessage(args[3] .. " is not up for bid.", playerName , nil , "1");
			else
				if(toNumber(args[4]) != nil) then
					rdkp.Bidding.AddBid(args[3], playerName, abs(args[4]));
				else
					SendChatMessage("Your dkp value input of " .. args[4] .. " is invalid.", playerName , nil , "1");
				end
			end
		end
	end
end

function rdkp.split(str, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			table.insert(t, str)
	end
	return t
end