-- Damage/Kill Tracker
-- Author: Liz

local startTime = 0
local endTime = 0
local elapsedTime = 0
local totalDamage = 0
local dps = 0
local tracking = false

function Tracker_OnLoad(frame)
	-- Start watching for specific game events
	frame:RegisterForDrag("LeftButton")

	frame:RegisterEvent("UNIT_COMBAT")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function Button_OnLoad(frame)
	frame:RegisterForClicks("RightButtonUp")
	frame:RegisterForDrag("LeftButton")
end


function Tracker_OnEvent(frame, event, ...)
	
	-- Triggers event when player enters combat 
	if event == "PLAYER_REGEN_DISABLED" then
		startTime = GetTime()
		totalDamage = 0
	
	-- Leaves combat 
	elseif event == "PLAYER_REGEN_ENABLED" then
		endTime = GetTime()
		elapsedTime = endTime - startTime
		dps = totalDamage / elapsedTime
		Update()

	-- While in combat
	elseif event == "UNIT_COMBAT" then
		if InCombatLockdown() then
			local unit, action, modifier, damage, dType = ...
			
			-- If an action is performed that is NOT heal (aka damage done)
			if unit == "player" and action ~= "HEAL" then
				totalDamage = totalDamage + damage
				endTime = GetTime()
				dps = totalDamage / elapsedTime
			end
		end
	end
end

function Tracker_Report(frame)
	if tracking == false then
		-- ButtonText:SetText = "Start Tracking"
		tracking = true
	else
		-- ButtonText:SetText = "Start Tracking"
		tracking = false
	end

	Update()
end

-- Will eventually push changes to stats screen (hopefully!)
function Update()
	-- body
	print("Damage Per Second: " .. dps)
end
