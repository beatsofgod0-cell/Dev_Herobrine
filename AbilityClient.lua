-- AbilityClient.lua
-- handles key input and tells server which ability to use
-- Note: These Are Just Basic Examples I Made To Get Lua Role I Can Do A Lot Better

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local remote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UseAbility")

-- keybinds
local binds = {
	[Enum.KeyCode.One] = "Dash",
	[Enum.KeyCode.Two] = "Fireball",
	[Enum.KeyCode.Three] = "Explosion",
	[Enum.KeyCode.Four] = "Shield",
	[Enum.KeyCode.Five] = "Teleport"
}

UIS.InputBegan:Connect(function(input, typing)
	if typing then return end
	local ability = binds[input.KeyCode]
	if ability then
		remote:FireServer(ability)
	end
end)
