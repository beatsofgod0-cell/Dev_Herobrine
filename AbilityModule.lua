-- AbilityModule.lua
-- Simple 5 ability system 
-- By: atlests591
-- Note: These Are Just Basic Examples I Made To Get Lua Role I Can Do A Lot Better

local AbilityModule = {}
local cooldowns = {}

-- quick check for cooldown
local function onCooldown(player, ability, cd)
	if not cooldowns[player] then
		cooldowns[player] = {}
	end

	local last = cooldowns[player][ability]
	if last and tick() - last < cd then
		return true
	end

	cooldowns[player][ability] = tick()
	return false
end

-- abilities table
AbilityModule.Abilities = {

	-- dash forward
	["Dash"] = {
		Cooldown = 3,
		Execute = function(player)
			local char = player.Character
			if not char then return end

			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChild("Humanoid")
			if not hrp or not hum then return end

			if hrp:FindFirstChild("DashForce") then return end

			local speed = 100
			local time = 0.2

			local bv = Instance.new("BodyVelocity")
			bv.Name = "DashForce"
			bv.MaxForce = Vector3.new(1e5, 0, 1e5)
			bv.Velocity = hrp.CFrame.LookVector * speed
			bv.Parent = hrp

			hum.PlatformStand = true
			game:GetService("Debris"):AddItem(bv, time)

			task.delay(time, function()
				if hum and hum.Parent then
					hum.PlatformStand = false
				end
			end)
		end
	},

	-- fireball projectile
	["Fireball"] = {
		Cooldown = 5,
		Execute = function(player)
			local char = player.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			-- create fireball
			local ball = Instance.new("Part")
			ball.Shape = Enum.PartType.Ball
			ball.Material = Enum.Material.Neon
			ball.Color = Color3.fromRGB(255, 120, 0)
			ball.Size = Vector3.new(2, 2, 2)
			ball.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 3
			ball.CanCollide = false
			ball.Parent = workspace

			-- sound when fired
			local castSound = Instance.new("Sound")
			castSound.SoundId = "rbxassetid://6026984224" -- magic woosh
			castSound.Volume = 2
			castSound.Parent = ball
			castSound:Play()

			-- movement
			local bv = Instance.new("BodyVelocity")
			bv.Velocity = hrp.CFrame.LookVector * 100
			bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bv.Parent = ball

			-- damage on hit
			ball.Touched:Connect(function(hit)
				local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
				if hum and hit.Parent ~= char then
					hum:TakeDamage(25)

					local hitSound = Instance.new("Sound")
					hitSound.SoundId = "rbxassetid://12222242" -- small explosion
					hitSound.Volume = 2
					hitSound.Parent = ball
					hitSound:Play()

					ball:Destroy()
				end
			end)

			game:GetService("Debris"):AddItem(ball, 5)
		end
	},

	-- explosion around player
	["Explosion"] = {
		Cooldown = 6,
		Execute = function(player)
			local char = player.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			-- explosion effect
			local boom = Instance.new("Explosion")
			boom.Position = hrp.Position
			boom.BlastRadius = 10
			boom.BlastPressure = 5000
			
			local sound = Instance.new("Sound")
			sound.SoundId = "rbxassetid://138186576" -- explosion boom
			sound.Volume = 3
			sound.Parent = hrp
			sound:Play()
			boom.Parent = workspace

			-- damage nearby humanoids
			boom.Hit:Connect(function(part)
				local hum = part.Parent:FindFirstChildOfClass("Humanoid")
				if hum and part.Parent ~= char then
					hum:TakeDamage(40)
				end
			end)

			-- explosion sound
		
		end
	},

	
	-- simple shield
	["Shield"] = {
		Cooldown = 8,
		Execute = function(player)
			local char = player.Character
			if not char then return end

			local ff = Instance.new("ForceField")
			ff.Parent = char
			game:GetService("Debris"):AddItem(ff, 5)
		end
	},

	-- teleport forward
	["Teleport"] = {
		Cooldown = 7,
		Execute = function(player)
			local char = player.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end

			local dist = 30
			local target = hrp.Position + hrp.CFrame.LookVector * dist
			hrp.CFrame = CFrame.new(target + Vector3.new(0,3,0))
		end
	}
}

-- public function
function AbilityModule:Use(player, ability)
	local ab = self.Abilities[ability]
	if not ab then return end

	if onCooldown(player, ability, ab.Cooldown) then
		warn(player.Name .. " tried " .. ability .. " but on cooldown")
		return
	end

	ab.Execute(player)
end

return AbilityModule
