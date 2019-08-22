----------------------
-- Namespace
----------------------
local _, rdkp = ...; 

rdkp.Config = {};

local Config = rdkp.Config;

--------------------------------------
-- Custom Slash Command
--------------------------------------
rdkp.commands = {

	["add"] = function(playerName, dkp)
		rdkp.DKP.AddDKP(playerName, dkp);
	end,

	["distribute"] = function(dkp)
		rdkp.DKP.DistributeDKP(dkp);
	end,

	["decay"] = function(adjustment)
		rdkp.DKP.DecayDKP(adjustment);
	end,

	["undecay"] = function(adjustment)
		rdkp.DKP.ReverseDecayDKP(adjustment);
	end,

	["start"] = function(...)
		local itemName, amount = rdkp.Bidding.ParseBidAndStartBidInput(...);
		rdkp.Bidding.StartBid(itemName, amount);
	end,

	["end"] = function(...)
		local itemName = rdkp.Bidding.ParseEndBidInput(...);
		rdkp.Bidding.EndBid(itemName);
	end,

	["bid"] = function(...)
		local itemName, amount = rdkp.Bidding.ParseBidAndStartBidInput(...);
		local name, realm = UnitFullName("player");
		name = name .. "-" .. realm;
		-- local name = UnitName("player"); USE THIS INSTEAD OF LINE 43 AND 44 FOR CLASSIC
		rdkp.Bidding.AddBid(itemName, name, amount);
	end,

	["bids"] = function()
		rdkp.Bidding.GetOpenBids();
	end,

	["help"] = function()
		print(" ");
		rdkp:Print("List of slash commands:")
		rdkp:Print("|cff00cc66/rdkp startbid {item name}|r - starts the bidding");
        rdkp:Print("|cff00cc66/rdkp endbid|r - ends the bidding");
        rdkp:Print("|cff00cc66/rdkp guilddkp {dkp amount (+/-)}|r - shows config menu");
		rdkp:Print("|cff00cc66/rdkp dkp {Character Name (+/-)} {dkp amount}|r - shows help info");
		print(" ");
	end
};

local function HandleSlashCommands(str)
	if (#str == 0) then
		rdkp.commands.help();
		return;		
	end	
	
	local args = {};
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end
	
	local commands = rdkp.commands;
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- check for white space
			arg = arg:lower();
			if (commands[arg]) then
				if (type(commands[arg]) == "function") then				
					-- all remaining args passed to the function
					commands[arg](select(id + 1, unpack(args))); 
					return;					
				end
			else
				-- incorrect input
				rdkp.commands.help();
				return;
			end
		end
	end
end

local defaults = {
	theme = {
		r = 0, 
		g = 0.8, -- 204/255
		b = 1,
		hex = "00ccff"
	}
};

local function GetThemeColor()
	local c = defaults.theme;
	return c.r, c.g, c.b, c.hex;
end

-- custom print function
function rdkp:Print(...)
    local hex = select(4, GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "RequiemDKP:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

--initializer
function rdkp:init(event, name)
	if (name ~= "RequiemDKP") then return end 

	-- allows using left and right buttons to move through chat 'edit' box
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
	end
	
	----------------------------------
	-- Register Slash Commands
	----------------------------------
	SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
	SlashCmdList.RELOADUI = ReloadUI;

	SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_Toggle();
	end

	SLASH_RequiemDKP1 = "/rdkp";
	SlashCmdList.RequiemDKP = HandleSlashCommands;

	rdkp.Database.InitDB();
	
    rdkp:Print("Requiem DKP initiated", UnitName("player").."!");
end

-- Create and subscribe to the ADDON_LOADED event for this addon
local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", rdkp.init);
-- events:RegisterEvent("CHAT_MSG_WHISPER");
-- events:SetScript("OnEvent", rdkp.HandleWhisperFunction);