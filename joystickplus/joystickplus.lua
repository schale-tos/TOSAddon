local addonName = "JOYSTICKPLUS"
local addonNameLower = string.lower(addonName)
local author = "schale-tos"

_G["ADDONS"] = _G["ADDONS"] or {}
_G["ADDONS"][author] = _G["ADDONS"][author] or {}
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {}
local g = _G["ADDONS"][author][addonName]

g.configFileLoc = string.format("../addons/%s/config.json", addonNameLower)

g.config = {
	enable = false
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
end

function g.SAVE_CONFIG()
	local acutil = require('acutil')
	
	acutil.saveJSON(g.configFileLoc, g.config)
end

function g.PRINT_MESSAGE(msg)
	CHAT_SYSTEM(string.format("[joystick+] %s", msg))
end

function g.CHANGE_RICHTEXT(obj, txt, font, m1, m2, m3, m4)
	local target = tolua.cast(obj, "ui::CRichText")
	target:SetMargin(m1,m2,m3,m4)	
	target:SetFontName(font)
	target:SetFormat(txt)
	target:SetText(txt)
end

function g.GET_JOYSTICK_LR()
	local input_L1 = joystick.IsKeyPressed("JOY_BTN_5")
	local input_L2 = joystick.IsKeyPressed("JOY_BTN_7")
	local input_R1 = joystick.IsKeyPressed("JOY_BTN_6")
	local input_R2 = joystick.IsKeyPressed("JOY_BTN_8")
	
	return (input_L1 * 1) + (input_L2 * 2) + (input_R1 * 4) + (input_R2 * 8)
end

function g.UPDATE_SLOT_SKIN(frame, enable, target)
	local current_skin = frame:GetChildRecursively(target):GetSkinName()
	
	if enable and current_skin == padslot_offskin then
		frame:GetChildRecursively(target):SetSkinName(padslot_onskin)
	elseif not enable and current_skin == padslot_onskin then
		frame:GetChildRecursively(target):SetSkinName(padslot_offskin)
	end
end

-- View
function g.REMODELING_JOYSTICK_QUICKSLOT(enable)
	local const = {}
	local jsqFrame = ui.GetFrame('joystickquickslot')
	local joystickRestFrame = ui.GetFrame('joystickrestquickslot')
	
	const[true]  = {270,120,-330,230,0,"yellow_14_ol","yellow_14_ol","L1+L2","L1+R2","R1+R2","R1+L2","L2+R2",9,11,9,11,1}
	const[false] = {170, 15,-145,  3,1,"yellow_16_ol","yellow_14_ol","L1","L2","R1","R2","L1+R1",20,10,9,11,0}

	jsqFrame:ShowWindow(0)
	jsqFrame:Resize(1920,const[enable][1])
	jsqFrame:GetChild("Set2"):SetOffset(0,const[enable][2])
	
	local refreshBtn = jsqFrame:GetChild("refreshBtn")
	refreshBtn:SetMargin(const[enable][3],const[enable][4],0,0)
	refreshBtn:SetGravity(ui.CENTER_HORZ, ui.TOP)
	refreshBtn:ShowWindow(1)
	
	jsqFrame:GetChild("L2R2"):ShowWindow(const[enable][5])
	jsqFrame:GetChild("L2R2_Set1"):ShowWindow(const[enable][5])
	jsqFrame:GetChild("L2R2_Set2"):ShowWindow(const[enable][5])

	g.CHANGE_RICHTEXT(jsqFrame:GetChildRecursively("L1_Set2"), const[enable][8], const[enable][6], const[enable][13],const[enable][14],0,0)
	g.CHANGE_RICHTEXT(jsqFrame:GetChildRecursively("L2_Set2"), const[enable][9], const[enable][6], const[enable][13],const[enable][14],0,0)
	g.CHANGE_RICHTEXT(jsqFrame:GetChildRecursively("R1_Set2"), const[enable][10], const[enable][6], const[enable][13],const[enable][14],0,0)
	g.CHANGE_RICHTEXT(jsqFrame:GetChildRecursively("R2_Set2"), const[enable][11], const[enable][6], const[enable][13],const[enable][14],0,0)
	g.CHANGE_RICHTEXT(jsqFrame:GetChildRecursively("L1+R1_Set2"), const[enable][12], const[enable][7], const[enable][15],const[enable][16],0,0)
	
	QUICKSLOT_REQUEST_REFRESH(jsqFrame, refreshBtn)
	jsqFrame:GetChild("Set1"):ShowWindow(1)
	jsqFrame:GetChild("Set2"):ShowWindow(const[enable][17])
	
	if IsJoyStickMode() == 1 and joystickRestFrame:IsVisible() == 0 then
		jsqFrame:ShowWindow(1)
	end
	
	jsqFrame:Invalidate()
end

-- Hook
function g.UI_MODE_CHANGE_HOOK(index)
	g.UI_MODE_CHANGE(index)
	if index == 1 then
		g.REMODELING_JOYSTICKPLUS_QUICKSLOT()
	end
end

function g.JOYSTICK_INPUT_HOOK()
	g.JOYSTICK_INPUT()
	
	if GetChangeUIMode() == 0 then
		local jsqFrame = ui.GetFrame('joystickquickslot')
		jsqFrame:GetChild("Set1"):ShowWindow(1)
		jsqFrame:GetChild("Set2"):ShowWindow(1)
	end
end

function g.UPDATE_JOYSTICK_INPUT_HOOK(frame)
	if IsJoyStickMode() == 0 then
		return;
	end
	
	local input_LR = g.GET_JOYSTICK_LR()
	
	-- 1: L1
	g.UPDATE_SLOT_SKIN(frame, input_LR == 1, "L1_slot_Set1")
	-- 2: L2
	g.UPDATE_SLOT_SKIN(frame, input_LR == 2, "L2_slot_Set1")
	-- 3: L1 + L2
	g.UPDATE_SLOT_SKIN(frame, input_LR == 3, "L1_slot_Set2")
	-- 4: R1
	g.UPDATE_SLOT_SKIN(frame, input_LR == 4, "R1_slot_Set1")
	-- 5: L1 + R1
	g.UPDATE_SLOT_SKIN(frame, input_LR == 5, "L1R1_slot_Set1")
	-- 6: L2 + R1
	g.UPDATE_SLOT_SKIN(frame, input_LR == 6, "R2_slot_Set2")
	-- 7: L1 + L2 + R1
	-- 8: R2
	g.UPDATE_SLOT_SKIN(frame, input_LR == 8, "R2_slot_Set1")
	-- 9: L1 + R2
	g.UPDATE_SLOT_SKIN(frame, input_LR == 9, "L2_slot_Set2")
	-- 10:L2 + R2
	g.UPDATE_SLOT_SKIN(frame, input_LR == 10, "L1R1_slot_Set2")
	-- 11:L1 + L2 + R2
	-- 12:R1 + R2 (rest)
	g.UPDATE_SLOT_SKIN(frame, input_LR == 12, "R1_slot_Set2")
	-- 13:L1 + R1 + R2
	-- 14:L2 + R1 + R2
	-- 15:L1 + L2 + R1 + R2
end

function g.JOYSTICK_QUICKSLOT_EXECUTE_HOOK(slotIndex)
	local input_LR = g.GET_JOYSTICK_LR()
	local joystickRestFrame = ui.GetFrame('joystickrestquickslot')
	
	if joystickRestFrame:IsVisible() == 1 then
		REST_JOYSTICK_SLOT_USE(joystickRestFrame, slotIndex);
		return;
	end
	
	local joystickSlotConvertTable = {[5] = 8, [3] = 20, [9] = 24, [10] = 28, [6] = 36, [12] = 32}
	
	if joystickSlotConvertTable[input_LR] ~= nil then
		slotIndex = joystickSlotConvertTable[input_LR] + (slotIndex % 4)
	end

	local quickslotFrame = ui.GetFrame('joystickquickslot')
	local slot = quickslotFrame:GetChildRecursively("slot"..slotIndex + 1)

	QUICKSLOTNEXPBAR_SLOT_USE(quickSlotFrame, slot, 'None', 0)
end

function g.RESTSIT_HOOK()
	if IsJoyStickMode() == 0 or keyboard.IsKeyDown("INSERT") == 1 then
		g.RestSit()
	end
end

function g.SELECT_QUEST_WARP_HOOK()
	if IsJoyStickMode() == 0 or keyboard.IsKeyDown("BACKSPACE") == 1 then
		g.SELECT_QUEST_WARP()
	else
		local input_LR = g.GET_JOYSTICK_LR()
		
		if input_LR == 2 then
			g.SELECT_QUEST_WARP()
		elseif input_LR == 4 then
			ui.Chat("/comeon")
		elseif input_LR == 8 then
			ON_RIDING_VEHICLE(0)
		elseif input_LR == 0 then
			ON_RIDING_VEHICLE(1)
		elseif input_LR == 12 then
			g.RestSit()
		end
	end
end

function g.JOYSTICK_QUICKSLOT_SWAP_HOOK(test)
	-- Disable QuickSlot swap by L2 + R2
end

-- Apply hook
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

function g.ENABLE_HOOK(enable)
	g.SETUP_HOOK(enable, "UI_MODE_CHANGE")
	g.SETUP_HOOK(enable, "JOYSTICK_INPUT")
	g.SETUP_HOOK(enable, "UPDATE_JOYSTICK_INPUT")
	g.SETUP_HOOK(enable, "JOYSTICK_QUICKSLOT_EXECUTE")
	g.SETUP_HOOK(enable, "SELECT_QUEST_WARP")
	g.SETUP_HOOK(enable, "JOYSTICK_QUICKSLOT_SWAP")
	-- Rest Sit
	if enable then
		if (not g.RestSit) then
			g.RestSit = control.RestSit
		end
		control.RestSit = g.RESTSIT_HOOK
	else
		if g.RestSit then
			control.RestSit = g.RestSit
		end
	end
end

-- Enable/Disable
function g.ENABLE_JOYSTICKPLUS(enable)
	g.ENABLE_HOOK(enable)
	g.REMODELING_JOYSTICK_QUICKSLOT(enable)
	g.config.enable = enable
	g.SAVE_CONFIG()
end

-- System Option Flag
function JOYSTICKPLUS_SYSTEMOPTION(frame, ctrl, argStr, argNum)
	if ctrl:IsChecked() == 1 then
		g.ENABLE_JOYSTICKPLUS(true)
	else
		g.ENABLE_JOYSTICKPLUS(false)
	end
end

-- Slash Command
function g.JOYSTICKPLUS_SLASHCOMMAND(command)
	local param = ""
	if #command > 0 then
		local sysopFrame = ui.GetFrame('systemoption')
		local controltype_jpex = sysopFrame:GetChildRecursively("controltype_jpex")
		controltype_jpex = tolua.cast(controltype_jpex, "ui::CCheckBox")
		
		param = table.remove(command, 1)
		if param == "on" then
			controltype_jpex:SetCheck(1)
			g.ENABLE_JOYSTICKPLUS(true)
			return
		elseif param == "off" then
			controltype_jpex:SetCheck(0)
			g.ENABLE_JOYSTICKPLUS(false)
			return
		end
	end
	
	g.PRINT_MESSAGE("/joystick+ [on/off]")
end

-- Setting
function g.ADD_SETTING(addon)
	local sysopFrame = ui.GetFrame('systemoption')
	local uiModeBox = sysopFrame:GetChildRecursively("uiModeBox")
	local gamePVPSetting = sysopFrame:GetChildRecursively("gamePVPSetting")
	
	gamePVPSetting:SetMargin(0, 30, 0, 0)
	
	local controltype_2 = uiModeBox:GetChild("controltype_2")
	controltype_2:SetMargin(20, 140, 0, 0)
	
	local controltype_3 = uiModeBox:GetChild("controltype_3")
	controltype_3:SetMargin(20, 170, 0, 0)
	
	local mouseImg_1 = uiModeBox:GetChild("mouseImg_1")
	mouseImg_1:SetMargin(20, 210, 0, 0)
	
	uiModeBox = tolua.cast(uiModeBox, "ui::CGroupBox")
	local controltype_jpex = uiModeBox:CreateOrGetControl("checkbox", "controltype_jpex", 0, 0, 0, 0)
	controltype_jpex = tolua.cast(controltype_jpex, "ui::CCheckBox")
	controltype_jpex:SetText("{@st66b}JoyStick+{/}")
	controltype_jpex:SetMargin(40, 110, 0, 0)
	controltype_jpex:SetEventScript(ui.LBUTTONUP, "JOYSTICKPLUS_SYSTEMOPTION")

	if g.config.enable == true then
		controltype_jpex:SetCheck(1)
		addon:RegisterMsg("GAME_START_3SEC", "JOYSTICKPLUS_INIT")
	else
		controltype_jpex:SetCheck(0)
	end
end

-- Init
function JOYSTICKPLUS_INIT()
	g.ENABLE_JOYSTICKPLUS(true)
end

function JOYSTICKPLUS_ON_INIT(addon, frame)
	local acutil = require('acutil')
	
	g.LOAD_CONFIG()
	
	acutil.slashCommand("/joystick+", g.JOYSTICKPLUS_SLASHCOMMAND)	
	
	g.ADD_SETTING(addon)
end

-- load message
g.PRINT_MESSAGE("JoyStick+ Addon is loaded.")
