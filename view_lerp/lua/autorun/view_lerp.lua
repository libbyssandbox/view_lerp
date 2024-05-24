AddCSLuaFile()

require("libbys_sdk")
libbys_sdk.util.require_binary("worldclicker")

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
	if not isangle(ply.m_angDesiredEye) or (cmd:GetMouseX() ~= 0 or cmd:GetMouseY() ~= 0) then
		ply.m_angDesiredEye = cmd:GetViewAngles()
	end

	if not isangle(ply.m_angLastEye) then
		ply.m_angLastEye = ply.m_angDesiredEye
		return
	end

	local new_eye = lerp_angle(ply.m_angLastEye, ply.m_angDesiredEye)

	if cmd.GetWorldClicker and cmd:GetWorldClicker() then
		cmd:SetWorldClickerAngle(new_eye:Forward())
	end

	cmd:SetViewAngles(new_eye)

	ply.m_angLastEye = new_eye
end)
