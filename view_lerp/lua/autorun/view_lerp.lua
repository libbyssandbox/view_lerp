AddCSLuaFile()

require("libbys_sdk")

local remap_angle = libbys_sdk.maths.remap_angle

libbys_sdk.util.unique_hook("StartCommand", function(ply, cmd)
	if not IsFirstTimePredicted() then return end

	if not isangle(ply.m_angDesiredEye) or (cmd:GetMouseX() ~= 0 or cmd:GetMouseY() ~= 0) then
		ply.m_angDesiredEye = cmd:GetViewAngles()
	end

	if not isangle(ply.m_angLastEye) then
		ply.m_angLastEye = ply.m_angDesiredEye
		return
	end

	local old_pitch = remap_angle(ply.m_angLastEye.pitch)
	local old_yaw = remap_angle(ply.m_angLastEye.yaw)
	local old_roll = remap_angle(ply.m_angLastEye.roll)

	local desired_pitch = remap_angle(ply.m_angDesiredEye.pitch)
	local desired_yaw = remap_angle(ply.m_angDesiredEye.yaw)
	local desired_roll = remap_angle(ply.m_angDesiredEye.roll)

	local new_pitch = Lerp(0.75, old_pitch, desired_pitch)
	local new_yaw = Lerp(0.75, old_yaw, desired_yaw)
	local new_roll = Lerp(0.75, old_roll, desired_roll)

	new_pitch = math.NormalizeAngle(new_pitch)
	new_yaw = math.NormalizeAngle(new_yaw)
	new_roll = math.NormalizeAngle(new_roll)

	local new_eye = Angle(new_pitch, new_yaw, new_roll)

	cmd:SetViewAngles(new_eye)

	ply.m_angLastEye = new_eye
end)
