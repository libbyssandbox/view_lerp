AddCSLuaFile()

require("libbys_sdk")

local LERP_PERCENTAGE = 0.75

libbys_sdk.util.unique_hook("StartCommand", function(ply, cmd)
	if not isangle(ply.m_angDesiredEye) or (cmd:GetMouseX() ~= 0 or cmd:GetMouseY() ~= 0) then
		ply.m_angDesiredEye = cmd:GetViewAngles()
	end

	if not isangle(ply.m_angLastEye) then
		ply.m_angLastEye = ply.m_angDesiredEye
		return
	end

	local old_pitch = ply.m_angLastEye.pitch
	local old_yaw = ply.m_angLastEye.yaw
	local old_roll = ply.m_angLastEye.roll

	local desired_pitch = ply.m_angDesiredEye.pitch
	local desired_yaw = ply.m_angDesiredEye.yaw
	local desired_roll = ply.m_angDesiredEye.roll

	local pitch_difference = math.AngleDifference(old_pitch, desired_pitch) * LERP_PERCENTAGE
	local yaw_difference = math.AngleDifference(old_yaw, desired_yaw) * LERP_PERCENTAGE
	local roll_difference = math.AngleDifference(old_roll, desired_roll) * LERP_PERCENTAGE

	local new_pitch = math.NormalizeAngle(old_pitch - pitch_difference)
	local new_yaw = math.NormalizeAngle(old_yaw - yaw_difference)
	local new_roll = math.NormalizeAngle(old_roll - roll_difference)

	local new_eye = Angle(new_pitch, new_yaw, new_roll)

	cmd:SetViewAngles(new_eye)

	ply.m_angLastEye = new_eye
end)
