----------------------
-- Namespace
----------------------
local _, core = ...; 

--------------------------------------
-- Custom Slash Command
--------------------------------------
core.commands = {

	-- this will call a function from bidding.lua
	["startbid"] = core.Bidding.StartBid,

	["endbid"] = core.Bidding.EndBid,

	["guilddkp"] = core.DKP.GuildWide,

	["dkp"] = core.DKP.Member,

	["help"] = function()
		print(" ");
		core:Print("List of slash commands:")
		core:Print("|cff00cc66/rdkp startbid {item name}|r - starts the bidding");
        core:Print("|cff00cc66/rdkp endbid|r - ends the bidding");
        core:Print("|cff00cc66/rdkp guilddkp {dkp amount (+/-)}|r - shows config menu");
		core:Print("|cff00cc66/rdkp dkp {Character Name (+/-)} {dkp amount}|r - shows help info");
		print(" ");
	end,
};

local function HandleSlashCommands(str)	
	if (#str == 0) then	
		-- User just entered "/rdkp" with no additional args
		core.commands.help();
		return;		
	end	
	
	local args = {};
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end
	
	local commands = core.commands; 
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- check for white space
			arg = arg:lower();			
			if (commands[arg]) then
				if (type(commands[arg]) == "function") then				
					-- all remaining args passed to the function
					commands[arg](select(id + 1, unpack(args))); 
					return;					
				elseif (type(commands[arg]) == "table") then				
					commands = commands[arg]; -- go to sub table (may not use this)
				end
			else
				-- incorrect input
				core.commands.help();
				return;
			end
		end
	end
end

-- custom print function
function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Aura Tracker:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

--initializer
function core:init(event, name)
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

	SLASH_ReqiemDKP1 = "/rdkp";
	SlashCmdList.RequiemDKP = HandleSlashCommands;
	
    core:Print("Requiem DKP initiated", UnitName("player").."!");
end

-- Create and subscribe to the ADDON_LOADED event for this addon
local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);