require("libbys")
libbys_sdk.util.require_binary("worldclicker")

local LERP_PERCENTAGE = 0.75 -- Percentage of view angles to allow per tick
local MAX_PER_TICK = 20 -- Maximum amount of angle units allowed per tick

local Angle = Angle
local math_AngleDifference = math.AngleDifference
local math_Clamp = math.Clamp
local math_NormalizeAngle = math.NormalizeAngle

-- Modified version of libbys.math.lerp_angle
local function lerp_angle(old, new)
	local pitch_difference = math_Clamp(math_AngleDifference(old.pitch, new.pitch) * LERP_PERCENTAGE, -MAX_PER_TICK, MAX_PER_TICK)
	local yaw_difference = math_Clamp(math_AngleDifference(old.yaw, new.yaw) * LERP_PERCENTAGE, -MAX_PER_TICK, MAX_PER_TICK)
	local roll_difference = math_Clamp(math_AngleDifference(old.roll, new.roll) * LERP_PERCENTAGE, -MAX_PER_TICK, MAX_PER_TICK)

	local new_pitch = math_NormalizeAngle(old.pitch - pitch_difference)
	local new_yaw = math_NormalizeAngle(old.yaw - yaw_difference)
	local new_roll = math_NormalizeAngle(old.roll - roll_difference)

	return Angle(new_pitch, new_yaw, new_roll)
end

libbys_sdk.util.unique_hook("StartCommand", function(ply, cmd)
	if ply:IsBot() then return end

	-- Eye angles
	ply.m_angDesiredEye = cmd:GetViewAngles()
	ply.m_angLastEye = ply.m_angLastEye or ply.m_angDesiredEye

	local new_eye = lerp_angle(ply.m_angLastEye, ply.m_angDesiredEye)
		cmd:SetViewAngles(new_eye)
	ply.m_angLastEye = new_eye

	-- Worldclicker angles
	if cmd:GetWorldClicker() then
		ply.m_vecDesiredWorldClicker = cmd:GetWorldClickerAngle()
		ply.m_vecLastWorldClicker = ply.m_vecLastWorldClicker or ply.m_vecDesiredWorldClicker

		local new_worldclicker = lerp_angle(ply.m_vecDesiredWorldClicker:Angle(), ply.m_vecLastWorldClicker:Angle()):Forward()
			cmd:SetWorldClickerAngle(new_worldclicker)
		ply.m_vecLastWorldClicker = new_worldclicker
	else
		cmd:SetWorldClickerAngle(new_eye:Forward())
	end
end)
