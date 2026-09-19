local AntiHit
local Mode
local TriggerRange
local ResponseSpeed
local HopHeight
local Duration
local Cooldown
local VoidCheck
local dodgeDirection
local dodgeUntil = 0
local nextDodge = 0
local strafeSide = 1

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getRoot(character)
	return character and (character:FindFirstChild('HumanoidRootPart') or character.PrimaryPart)
end

local function getPosition(value)
	if typeof(value) == 'Vector3' then
		return value
	end
	if type(value) == 'table' and tonumber(value.X) and tonumber(value.Y) and tonumber(value.Z) then
		return Vector3.new(value.X, value.Y, value.Z)
	end
end

local function hasGround(root, direction)
	rayParams.FilterDescendantsInstances = {lplr.Character, gameCamera}
	local checkPosition = root.Position + (direction * 6)
	return workspace:Raycast(checkPosition, Vector3.new(0, -18, 0), rayParams) ~= nil
end

local function chooseDirection(root, sourcePosition)
	local flat = (root.Position - sourcePosition) * Vector3.new(1, 0, 1)
	if flat.Magnitude == 0 then
		flat = root.CFrame.LookVector * Vector3.new(1, 0, 1)
	end
	if flat.Magnitude == 0 then
		return nil
	end

	local away = flat.Unit
	if Mode.Value == 'Retreat' or Mode.Value == 'Hop' then
		return (not VoidCheck.Enabled or hasGround(root, away)) and away or nil
	end

	local left = Vector3.new(-away.Z, 0, away.X)
	local right = -left
	strafeSide = -strafeSide
	local preferred = strafeSide == 1 and left or right
	local alternate = strafeSide == 1 and right or left
	if not VoidCheck.Enabled or hasGround(root, preferred) then
		return preferred
	end
	if hasGround(root, alternate) then
		return alternate
	end
	return hasGround(root, away) and away or nil
end

local function handleDamage(damageTable)
	if not AntiHit.Enabled or tick() < nextDodge then return end
	if not entitylib.isAlive or not entitylib.character or damageTable.entityInstance ~= lplr.Character then return end
	if not damageTable.fromEntity or damageTable.fromEntity == lplr.Character then return end

	local root = entitylib.character.RootPart
	if not root or not root.Parent or not isnetworkowner(root) then return end

	local sourcePosition = getPosition(damageTable.fromPosition)
	if not sourcePosition then
		local attackerRoot = getRoot(damageTable.fromEntity)
		sourcePosition = attackerRoot and attackerRoot.Position
	end
	if not sourcePosition or (root.Position - sourcePosition).Magnitude > TriggerRange.Value then return end

	local direction = chooseDirection(root, sourcePosition)
	if not direction then return end

	dodgeDirection = direction
	dodgeUntil = tick() + Duration.Value
	nextDodge = tick() + Cooldown.Value
end

AntiHit = vape.Categories.Blatant:CreateModule({
	Name = 'AntiHit',
	Function = function(callback)
		if callback then
			AntiHit:Clean(vapeEvents.EntityDamageEvent.Event:Connect(handleDamage))
			AntiHit:Clean(runService.PreSimulation:Connect(function()
				if tick() >= dodgeUntil then return end
				if not entitylib.isAlive or not entitylib.character then return end

				local root = entitylib.character.RootPart
				if not root or not root.Parent or not isnetworkowner(root) or not dodgeDirection then return end

				local vertical = root.AssemblyLinearVelocity.Y
				if Mode.Value == 'Hop' then
					vertical = math.max(vertical, HopHeight.Value)
				end
				local speed = math.max(ResponseSpeed.Value, getSpeed())
				root.AssemblyLinearVelocity = Vector3.new(dodgeDirection.X * speed, vertical, dodgeDirection.Z * speed)
			end))
		else
			dodgeDirection = nil
			dodgeUntil = 0
			nextDodge = 0
		end
	end,
	Tooltip = 'Dodges away from follow-up hits after an enemy damages you.'
})

Mode = AntiHit:CreateDropdown({
	Name = 'Mode',
	List = {'Strafe', 'Retreat', 'Hop'},
	Default = 'Strafe'
})
TriggerRange = AntiHit:CreateSlider({
	Name = 'Trigger range',
	Min = 1,
	Max = 30,
	Default = 18,
	Suffix = function(value)
		return value == 1 and 'stud' or 'studs'
	end
})
ResponseSpeed = AntiHit:CreateSlider({
	Name = 'Response speed',
	Min = 10,
	Max = 100,
	Default = 34,
	Suffix = 'studs'
})
HopHeight = AntiHit:CreateSlider({
	Name = 'Hop height',
	Min = 0,
	Max = 50,
	Default = 12,
	Suffix = 'studs'
})
Duration = AntiHit:CreateSlider({
	Name = 'Dodge duration',
	Min = 0.05,
	Max = 1,
	Default = 0.18,
	Decimal = 100,
	Suffix = 'seconds'
})
Cooldown = AntiHit:CreateSlider({
	Name = 'Cooldown',
	Min = 0.05,
	Max = 1,
	Default = 0.15,
	Decimal = 100,
	Suffix = 'seconds'
})
VoidCheck = AntiHit:CreateToggle({
	Name = 'Void check',
	Default = true,
	Tooltip = 'Does not dodge toward an area without ground below it.'
})
