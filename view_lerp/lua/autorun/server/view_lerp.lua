AddCSLuaFile()

require("libbys_sdk")
libbys_sdk.util.require_binary("worldclicker")

local HAS_WORLDCLICKER = isfunction(libbys_sdk.metatables.get("CUserCmd").GetWorldClicker)

local LERP_PERCENTAGE = 0.75

local function lerp_angle(old, new)
	local pitch_difference = math.AngleDifference(old.pitch, new.pitch) * LERP_PERCENTAGE
	local yaw_difference = math.AngleDifference(old.yaw, new.yaw) * LERP_PERCENTAGE
	local roll_difference = math.AngleDifference(old.roll, new.roll) * LERP_PERCENTAGE

	local new_pitch = math.NormalizeAngle(old.pitch - pitch_difference)
	local new_yaw = math.NormalizeAngle(old.yaw - yaw_difference)
	local new_roll = math.NormalizeAngle(old.roll - roll_difference)

	return Angle(new_pitch, new_yaw, new_roll)
end

libbys_sdk.util.unique_hook("StartCommand", function(ply, cmd)
	if ply:IsBot() then return end

	ply.m_angDesiredEye = cmd:GetViewAngles()
	ply.m_angLastEye = ply.m_angLastEye or ply.m_angDesiredEye

	if HAS_WORLDCLICKER and cmd:GetWorldClicker() then
		ply.m_vecDesiredWorldClicker = cmd:GetWorldClickerAngle()
		ply.m_vecLastWorldClicker = ply.m_vecLastWorldClicker or ply.m_vecDesiredWorldClicker

		local new_worldclicker = lerp_angle(ply.m_vecDesiredWorldClicker:Angle(), ply.m_vecLastWorldClicker:Angle()):Forward()
			cmd:SetWorldClickerAngle(new_worldclicker)
		ply.m_vecLastWorldClicker = new_worldclicker
	end

	local new_eye = lerp_angle(ply.m_angLastEye, ply.m_angDesiredEye)
		cmd:SetViewAngles(new_eye)
	ply.m_angLastEye = new_eye
end)
