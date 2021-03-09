local addonName = "PETPLUS"
local addonNameLower = string.lower(addonName)
local author = "schale-tos"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

g.configFileLoc = string.format("../addons/%s/config.json", addonNameLower)

g.config = {
	hide_others_pet_name = true,
	hide_hawk_gauge = true,
	change_pet_name_color = true,
	call_pet_riding = true,
	waiting_for_ride = 3
}

-- Common
function g.LOAD_CONFIG()
	local acutil = require('acutil')

	if not g.loaded then
		local t, err = acutil.loadJSON(g.configFileLoc, g.config)
		if not err then
			g.config = t;
		end
		g.loaded = true;
	end

	local frame = ui.GetFrame("petplus")

	for key, value in pairs(g.config) do
		local checkbox = GET_CHILD_RECURSIVELY(frame, key, "ui::CCheckBox")
		if checkbox ~= nil then
			if value == true then
				checkbox:SetCheck(1)
			else
				checkbox:SetCheck(0)
			end
		end
	end

end

function g.SAVE_CONFIG()
	local acutil = require('acutil')

	acutil.saveJSON(g.configFileLoc, g.config)
end

function g.PRINT_MESSAGE(msg)
	CHAT_SYSTEM(string.format("[Pet+] %s", msg))
end

function g.SETUP_HOOK(enable, target)
	if enable then
		if not g[target] then
			g[target] = _G[target]
		end
		_G[target] = g[target .. "_HOOK"]
	else
		if g[target] then
			_G[target] = g[target]
		end
	end
end

function g.GET_HAWK_GUID()
	local hawk = GET_SUMMONED_PET_HAWK()
	local hawk_guid = nil

	if hawk ~= nil then
		hawk_guid = hawk:GetStrGuid()
	end

	return hawk_guid
end

-- Hook
function g.ENABLE_HOOK(enable)
	g.SETUP_HOOK(enable, "ON_RIDING_VEHICLE")
	g.SETUP_HOOK(enable, "UPDATE_COMPANION_TITLE")
end

function g.UPDATE_COMPANION_TITLE_HOOK(frame, handle)
	frame = tolua.cast(frame, "ui::CObject")
	local petguid  = session.pet.GetPetGuidByHandle(handle)
	local mycompinfoBox = GET_CHILD_RECURSIVELY(frame, "mycompinfo")

	if petguid ~= 'None' and mycompinfoBox ~= nil then -- own pet
		local hawkguid = g.GET_HAWK_GUID()
		local petInfoFrame = ui.GetFrame("pet_info")
		local atkEnable = petInfoFrame:GetUserValue('AUTO_ATK')
		local mynameRtext = GET_CHILD_RECURSIVELY(mycompinfoBox, "myname")

		-- if auto attack is eanbled, change the color of the pet name
		if g.config.change_pet_name_color == true and atkEnable == "YES" and petguid ~= hawkguid then
			mynameRtext:SetFontName("red_18_ol")
		else
			mynameRtext:SetFontName("white_18_ol")
		end

		if petguid == hawkguid then
			local hpGauge = GET_CHILD_RECURSIVELY(mycompinfoBox, "HpGauge")
			local stGauge = GET_CHILD_RECURSIVELY(mycompinfoBox, "StGauge")
			local pcinfo_bg_L = GET_CHILD_RECURSIVELY(mycompinfoBox, "pcinfo_bg_L")
			local pcinfo_bg_R = GET_CHILD_RECURSIVELY(mycompinfoBox, "pcinfo_bg_R")

			-- Hide the hawk hp/st gauge
			if g.config.hide_hawk_gauge == true then
				hpGauge:ShowWindow(0)
				stGauge:ShowWindow(0)
				pcinfo_bg_L:ShowWindow(0)
				pcinfo_bg_R:ShowWindow(0)
				mynameRtext:SetMargin(0, 5, 0, 0)
			else
				hpGauge:ShowWindow(1)
				stGauge:ShowWindow(1)
				pcinfo_bg_L:ShowWindow(1)
				pcinfo_bg_R:ShowWindow(1)
				mynameRtext:SetMargin(0, 40, 0, 0)
			end
		end
	else -- other's pet
		local sysopFrame = ui.GetFrame('systemoption')
		local showOtherPcNameCtrl = GET_CHILD_RECURSIVELY(sysopFrame, "ShowOtherPcName", "ui::CCheckBox")
		local othernameRtext = GET_CHILD_RECURSIVELY(frame, "othername")

		--  Hide the name of other's pet, if ShowOtherPCName Option is disabled.
		if g.config.hide_others_pet_name == true then
			othernameRtext:ShowWindow(showOtherPcNameCtrl:IsChecked())
		else
			othernameRtext:ShowWindow(1)
		end
	end

	g["UPDATE_COMPANION_TITLE"](frame, handle)
end

function g.ON_RIDING_VEHICLE_HOOK(mountType)
	g["ON_RIDING_VEHICLE"](mountType)

  -- Call pet when riding.
	if g.config.call_pet_riding == true and mountType == 1 and GET_SUMMONED_PET() ~= nil then
		if GetMyActor():GetVehicleState() == true then
			 return
		end

		if control.HaveNearCompanionToRide() == true then
			control.RideCompanon(1)
		end

		if GetMyActor():GetVehicleState() ~= true then
			local frame = ui.GetFrame("petplus")
			if frame:GetValue() ~= 1 then
				ui.Chat("/comeon")
				if control.HaveNearCompanionToRide() == true then
					control.RideCompanon(1)
				end

				if GetMyActor():GetVehicleState() ~= true then
					local timer = tolua.cast(frame:CreateOrGetControl("timer", "addontimer", 0, 0, 10, 10), "ui::CAddOnTimer")
					frame:SetValue(1)
					frame:EnableHideProcess(1)
					timer:EnableHideUpdate(1)
					timer:SetUpdateScript("PETPLUS_RIDE_TIMER_UPDATE")
					timer:Start(0.1)
				end
			end
		end
	end
end

-- Global Action
function PETPLUS_RIDE_TIMER_UPDATE(frame, timer, str, num, totalTime)
	if GetMyActor():GetVehicleState() == true or totalTime > g.config.waiting_for_ride then
		frame:SetValue(0)
		timer:Stop()
		return
	end

	if control.HaveNearCompanionToRide() == true then
		control.RideCompanion(1)
	end

	if GetMyActor():GetVehicleState() == true then
		frame:SetValue(0)
		timer:Stop()
	end
end

function PETPLUS_UPDATE_CONFIG(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.config[argStr] = true
	else
		g.config[argStr] = false
	end
	g.SAVE_CONFIG()
end

-- Auto Attack
function g.AUTO_ATTACK()
	if GET_SUMMONED_PET() ~= nil then
		local petInfoFrame = ui.GetFrame("pet_info")
		TOGGLE_PET_ATTACK(petInfoFrame, nil)
	end
end

-- Pet Summon
function g.PET_SUMMON()
	control.CustomCommand("PET_ACTIVATE", 0)
end

-- Slash Command
function g.PETPLUS_SLASHCOMMAND(command)
	local param = ""
	if #command > 0 then
		param = table.remove(command, 1)
		if param == "summon" then
			g.PET_SUMMON()
		elseif param == "auto_attack" then
			g.AUTO_ATTACK()
		else
			local settingFrame = ui.GetFrame("petplus")
			settingFrame:ShowWindow(1)
		end
	else
		local settingFrame = ui.GetFrame("petplus")
		settingFrame:ShowWindow(1)
	end
end

-- Init
function PETPLUS_ON_INIT(addon, frame)
	local acutil = require('acutil')

	g.LOAD_CONFIG()

	acutil.slashCommand("/pet+", g.PETPLUS_SLASHCOMMAND)

	g.ENABLE_HOOK(true)
end

-- load message
g.PRINT_MESSAGE("Pet+ Addon is loaded.")
