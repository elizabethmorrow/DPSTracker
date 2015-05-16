-- Damage/Kill Tracker
-- Author: Liz

local startTime = 0
local endTime = 0
local elapsedTime = 0
local totalDamage = 0
local dps = 0

function Tracker_OnLoad(frame)
	-- Start watching for specific game events
	frame:RegisterForClicks("RightButtonUp")
	frame:RegisterForDrag("LeftButton")

	frame:RegisterEvent("UNIT_COMBAT")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")

	local displayFrame = CreateFrame("Frame", "Display", UIParent)
	frame:SetMovable(true)
	frame:EnableMouse(true)

	-- Will eventually remove and bind to button
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	-- until here
	
	displayFrame:SetWidth(175)
	displayFrame:SetHeight(175)
	displayFrame:SetPoint("CENTER", UIParent, "CENTER")

	
	local displayTexture = CreateTexture("ARTWORK")
	displayTexture:SetAllPoints()
	displayTexture:SetTexture(0, 0, 255)
	displayTexture:SetAlpha(0.4)
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
				-- do stuff
				totalDamage = totalDamage + damage
				endTime = GetTime()
				dps = totalDamage / elapsedTime
			end
		end
	end
end

function Tracker_Report(frame)
	Update()
end

-- Will eventually push changes to stats screen (hopefully!)
function Update()
	-- body
	print("Damage Per Second: " .. dps)
end
