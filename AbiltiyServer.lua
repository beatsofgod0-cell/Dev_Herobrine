-- AbilityServer.lua
-- listens for ability requests and runs them server side
-- Note: These Are Just Basic Examples I Made To Get Lua Role I Can Do A Lot Better

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local AbilityModule = require(ServerScriptService.Modules.AbilityModule)

local remote = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UseAbility")

remote.OnServerEvent:Connect(function(player, ability)
	if not player.Character then return end
	AbilityModule:Use(player, ability)
end)
