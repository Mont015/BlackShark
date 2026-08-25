local Attacking
run(function()
	local Killaura
	local Targets
	local Sort
	local SwingRange
	local AttackRange
	local UpdateRate
	local AngleSlider
	local MaxTargets
	local Mouse
	local Swing
	local GUI
	local BoxSwingColor
	local BoxAttackColor
	local ParticleTexture
	local ParticleColor1
	local ParticleColor2
	local ParticleSize
	local Face
	local Animation
	local AnimationMode
	local AnimationSpeed
	local AnimationTween
	local Limit
	local LegitAura
	local Particles, Boxes = {}, {}
	local anims, AnimDelay, AnimTween, armC0 = vape.Libraries.auraanims, tick()
	local AttackRemote
	local LastManualSwing = 0
	local NextAttack = 0
	local AttackIndex = 1
	local PrimaryTarget

	local function getAttackRemote()
		if AttackRemote then
			return AttackRemote
		end

		local success, remote = pcall(function()
			return bedwars.Client:Get(remotes.AttackEntity)
		end)
		AttackRemote = success and remote or nil
		return AttackRemote
	end

	local function sendAttack(attackTable)
		local remote = getAttackRemote()
		if not remote then
			return false
		end

		local success = pcall(function()
			if remote.SendToServer then
				remote:SendToServer(attackTable)
			elseif remote.instance and remote.instance.FireServer then
				remote.instance:FireServer(attackTable)
			else
				error('Attack remote is unavailable')
			end
		end)
		if not success then
			AttackRemote = nil
		end
		return success
	end

	local function getAttackData()
		if not entitylib.isAlive or not entitylib.character.RootPart then
			return false
		end

		if Mouse.Enabled then
			if not inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then return false end
		end

		if GUI.Enabled then
			if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end
		end

		local sword = Limit.Enabled and store.hand or store.tools.sword
		if not sword or not sword.tool then return false end

		local meta = bedwars.ItemMeta[sword.tool.Name]
		if not meta or not meta.sword then return false end
		if Limit.Enabled then
			if store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid then return false end
		end

		if LegitAura.Enabled and (tick() - LastManualSwing) > 0.2 then
			return false
		end

		return sword, meta
	end

	local function clearCombatState()
		Attacking = false
		PrimaryTarget = nil
		AttackIndex = 1
		NextAttack = 0
		store.KillauraTarget = nil
	end

	local function collectTargets(root)
		local success, entities = pcall(entitylib.AllPosition, {
			Range = SwingRange.Value,
			Wallcheck = Targets.Walls.Enabled or nil,
			Part = 'RootPart',
			Players = Targets.Players.Enabled,
			NPCs = Targets.NPCs.Enabled,
			Limit = MaxTargets.Value,
			Sort = sortmethods[Sort.Value]
		})
		if not success or type(entities) ~= 'table' then
			return {}
		end

		local origin = root.Position
		local facing = root.CFrame.LookVector * Vector3.new(1, 0, 1)
		if facing.Magnitude == 0 then
			return {}
		end

		local maxAngle = math.rad(AngleSlider.Value) / 2
		local targets = {}
		for _, entity in entities do
			local targetRoot = entity.RootPart or (entity.Character and entity.Character.PrimaryPart)
			if not targetRoot then continue end

			local offset = targetRoot.Position - origin
			local horizontalOffset = offset * Vector3.new(1, 0, 1)
			if horizontalOffset.Magnitude == 0 then continue end

			local angle = math.acos(math.clamp(facing.Unit:Dot(horizontalOffset.Unit), -1, 1))
			if angle > maxAngle then continue end

			local distance = offset.Magnitude
			table.insert(targets, {
				Entity = entity,
				RootPart = targetRoot,
				Distance = distance,
				CanAttack = distance <= AttackRange.Value,
				Check = distance <= AttackRange.Value and BoxAttackColor or BoxSwingColor
			})
			targetinfo.Targets[entity] = tick() + 1
		end
		return targets
	end

	local function prioritizePrimary(targets)
		local currentIndex
		for index, target in targets do
			if target.Entity == PrimaryTarget then
				currentIndex = index
				break
			end
		end

		if currentIndex then
			local current = table.remove(targets, currentIndex)
			table.insert(targets, 1, current)
		elseif targets[1] then
			PrimaryTarget = targets[1].Entity
		else
			PrimaryTarget = nil
		end
		return targets[1]
	end

	local function playSwingEffect(meta, now)
		if Swing.Enabled or LegitAura.Enabled or now < AnimDelay then return end

		local attackSpeed = tonumber(meta.sword.attackSpeed) or 0.11
		AnimDelay = now + (meta.sword.respectAttackSpeedForEffects and attackSpeed or 0.11)
		pcall(function()
			bedwars.SwordController:playSwordEffect(meta, false)
			if meta.displayName and meta.displayName:find(' Scythe') then
				bedwars.ScytheController:playLocalAnimation()
			end
		end)
	end

	local function attackTarget(sword, root, target)
		if not target.Entity.Character or not target.RootPart then return false end

		local origin = root.Position
		local direction = target.RootPart.Position - origin
		if direction.Magnitude == 0 then return false end

		local unit = direction.Unit
		local position = origin + unit * math.max(target.Distance - 14.399, 0)
		local sent = sendAttack({
			weapon = sword.tool,
			chargedAttack = {chargeRatio = 0},
			entityInstance = target.Entity.Character,
			validate = {
				raycast = {
					cameraPosition = {value = position},
					cursorDirection = {value = unit}
				},
				targetPosition = {value = target.RootPart.Position},
				selfPosition = {value = position}
			}
		})
		if sent then
			bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
			store.attackReach = math.floor(target.Distance * 100) / 100
			store.attackReachUpdate = tick() + 1
		end
		return sent
	end

	local function updateVisuals(targets)
		for index, box in Boxes do
			box.Adornee = targets[index] and targets[index].RootPart or nil
			if box.Adornee then
				local color = targets[index].Check
				box.Color3 = Color3.fromHSV(color.Hue, color.Sat, color.Value)
				box.Transparency = 1 - color.Opacity
			end
		end

		for index, particle in Particles do
			particle.Position = targets[index] and targets[index].RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
			particle.Parent = targets[index] and gameCamera or nil
		end
	end

	Killaura = vape.Categories.Blatant:CreateModule({
		Name = 'Killaura',
		Function = function(callback)
			if callback then
				Killaura:Clean(inputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						LastManualSwing = tick()
					end
				end))

				if inputService.TouchEnabled then
					pcall(function()
						lplr.PlayerGui.MobileUI['2'].Visible = Limit.Enabled
					end)
				end

				if Animation.Enabled then
					task.spawn(function()
						local started = false
						repeat
							if Attacking then
								if not armC0 then
									armC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
								end
								local first = not started
								started = true

								if AnimationMode.Value == 'Random' then
									anims.Random = {{CFrame = CFrame.Angles(math.rad(math.random(1, 360)), math.rad(math.random(1, 360)), math.rad(math.random(1, 360))), Time = 0.12}}
								end

								for _, v in anims[AnimationMode.Value] do
									AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(first and (AnimationTween.Enabled and 0.001 or 0.1) or v.Time / math.max(AnimationSpeed.Value, 0.1), Enum.EasingStyle.Linear), {
										C0 = armC0 * v.CFrame
									})
									AnimTween:Play()
									AnimTween.Completed:Wait()
									first = false
									if (not Killaura.Enabled) or (not Attacking) then break end
								end
							elseif started then
								started = false
								AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
									C0 = armC0
								})
								AnimTween:Play()
							end

							if not started then
								task.wait(1 / UpdateRate.Value)
							end
						until (not Killaura.Enabled) or (not Animation.Enabled)
					end)
				end

				repeat
					local now = tick()
					local sword, meta = getAttackData()
					local root = entitylib.character and entitylib.character.RootPart
					local targets = sword and root and collectTargets(root) or {}
					local primary = prioritizePrimary(targets)
					local attackable = {}

					for _, target in targets do
						if target.CanAttack then
							table.insert(attackable, target)
						end
					end

					Attacking = #attackable > 0
					store.KillauraTarget = primary and primary.Entity or nil

					if Attacking and sword and meta and root then
						playSwingEffect(meta, now)
						if now >= NextAttack then
							local targetIndex = ((AttackIndex - 1) % #attackable) + 1
							local target = attackable[targetIndex]
							pcall(switchItem, sword.tool, 0)

							local sent = attackTarget(sword, root, target)
							AttackIndex = (targetIndex % #attackable) + 1
							local cooldown = math.max(tonumber(meta.sword.attackSpeed) or 0.11, 0.05)
							NextAttack = now + (sent and cooldown or 0.1)
						end
					else
						AttackIndex = 1
						if not primary then
							NextAttack = 0
						end
					end

					updateVisuals(targets)
					if Face.Enabled and primary and primary.RootPart and root then
						local position = primary.RootPart.Position
						root.CFrame = CFrame.lookAt(root.Position, Vector3.new(position.X, root.Position.Y + 0.001, position.Z))
					end

					task.wait(1 / math.max(UpdateRate.Value, 1))
				until not Killaura.Enabled
			else
				clearCombatState()
				for _, v in Boxes do
					v.Adornee = nil
				end
				for _, v in Particles do
					v.Parent = nil
				end
				if inputService.TouchEnabled then
					pcall(function()
						lplr.PlayerGui.MobileUI['2'].Visible = true
					end)
				end
				if armC0 then
					AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
						C0 = armC0
					})
					AnimTween:Play()
				end
			end
		end,
		Tooltip = 'Attack players around you\nwithout aiming at them.'
	})
	Targets = Killaura:CreateTargets({
		Players = true,
		NPCs = true
	})
	local methods = {'Damage', 'Distance'}
	for i in sortmethods do
		if not table.find(methods, i) then
			table.insert(methods, i)
		end
	end
	SwingRange = Killaura:CreateSlider({
		Name = 'Swing range',
		Min = 1,
		Max = 28,
		Default = 28,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AttackRange = Killaura:CreateSlider({
		Name = 'Attack range',
		Min = 1,
		Max = 28,
		Default = 28,
		Suffix = function(val)
			return val == 1 and 'stud' or 'studs'
		end
	})
	AngleSlider = Killaura:CreateSlider({
		Name = 'Max angle',
		Min = 1,
		Max = 360,
		Default = 360
	})
	UpdateRate = Killaura:CreateSlider({
		Name = 'Update rate',
		Min = 1,
		Max = 120,
		Default = 60,
		Suffix = 'hz'
	})
	MaxTargets = Killaura:CreateSlider({
		Name = 'Max targets',
		Min = 1,
		Max = 5,
		Default = 5
	})
	Sort = Killaura:CreateDropdown({
		Name = 'Target Mode',
		List = methods,
		Default = 'Distance'
	})
	Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
	Swing = Killaura:CreateToggle({Name = 'No Swing'})
	GUI = Killaura:CreateToggle({Name = 'GUI check'})
	Killaura:CreateToggle({
		Name = 'Show target',
		Function = function(callback)
			BoxSwingColor.Object.Visible = callback
			BoxAttackColor.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local box = Instance.new('BoxHandleAdornment')
					box.Adornee = nil
					box.AlwaysOnTop = true
					box.Size = Vector3.new(3, 5, 3)
					box.CFrame = CFrame.new(0, -0.5, 0)
					box.ZIndex = 0
					box.Parent = vape.holder
					Boxes[i] = box
				end
			else
				for _, v in Boxes do
					v:Destroy()
				end
				table.clear(Boxes)
			end
		end
	})
	BoxSwingColor = Killaura:CreateColorSlider({
		Name = 'Target Color',
		Darker = true,
		DefaultHue = 0.6,
		DefaultOpacity = 0.5,
		Visible = false
	})
	BoxAttackColor = Killaura:CreateColorSlider({
		Name = 'Attack Color',
		Darker = true,
		DefaultOpacity = 0.5,
		Visible = false
	})
	Killaura:CreateToggle({
		Name = 'Target particles',
		Function = function(callback)
			ParticleTexture.Object.Visible = callback
			ParticleColor1.Object.Visible = callback
			ParticleColor2.Object.Visible = callback
			ParticleSize.Object.Visible = callback
			if callback then
				for i = 1, 10 do
					local part = Instance.new('Part')
					part.Size = Vector3.new(2, 4, 2)
					part.Anchored = true
					part.CanCollide = false
					part.Transparency = 1
					part.CanQuery = false
					part.Parent = Killaura.Enabled and gameCamera or nil
					local particles = Instance.new('ParticleEmitter')
					particles.Brightness = 1.5
					particles.Size = NumberSequence.new(ParticleSize.Value)
					particles.Shape = Enum.ParticleEmitterShape.Sphere
					particles.Texture = ParticleTexture.Value
					particles.Transparency = NumberSequence.new(0)
					particles.Lifetime = NumberRange.new(0.4)
					particles.Speed = NumberRange.new(16)
					particles.Rate = 128
					particles.Drag = 16
					particles.ShapePartial = 1
					particles.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
					})
					particles.Parent = part
					Particles[i] = part
				end
			else
				for _, v in Particles do
					v:Destroy()
				end
				table.clear(Particles)
			end
		end
	})
	ParticleTexture = Killaura:CreateTextBox({
		Name = 'Texture',
		Default = 'rbxassetid://14736249347',
		Function = function()
			for _, v in Particles do
				v.ParticleEmitter.Texture = ParticleTexture.Value
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor1 = Killaura:CreateColorSlider({
		Name = 'Color Begin',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleColor2 = Killaura:CreateColorSlider({
		Name = 'Color End',
		Function = function(hue, sat, val)
			for _, v in Particles do
				v.ParticleEmitter.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
					ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
				})
			end
		end,
		Darker = true,
		Visible = false
	})
	ParticleSize = Killaura:CreateSlider({
		Name = 'Size',
		Min = 0,
		Max = 1,
		Default = 0.2,
		Decimal = 100,
		Function = function(val)
			for _, v in Particles do
				v.ParticleEmitter.Size = NumberSequence.new(val)
			end
		end,
		Darker = true,
		Visible = false
	})
	Face = Killaura:CreateToggle({Name = 'Face target'})
	Animation = Killaura:CreateToggle({
		Name = 'Custom Animation',
		Function = function(callback)
			AnimationMode.Object.Visible = callback
			AnimationTween.Object.Visible = callback
			AnimationSpeed.Object.Visible = callback
			if Killaura.Enabled then
				Killaura:Toggle()
				Killaura:Toggle()
			end
		end
	})
	local animnames = {}
	for i in anims do
		table.insert(animnames, i)
	end
	AnimationMode = Killaura:CreateDropdown({
		Name = 'Animation Mode',
		List = animnames,
		Darker = true,
		Visible = false
	})
	AnimationSpeed = Killaura:CreateSlider({
		Name = 'Animation Speed',
		Min = 0.1,
		Max = 2,
		Default = 1,
		Decimal = 10,
		Darker = true,
		Visible = false
	})
	AnimationTween = Killaura:CreateToggle({
		Name = 'No Tween',
		Darker = true,
		Visible = false
	})
	Limit = Killaura:CreateToggle({
		Name = 'Limit to items',
		Function = function(callback)
			if inputService.TouchEnabled and Killaura.Enabled then
				pcall(function()
					lplr.PlayerGui.MobileUI['2'].Visible = callback
				end)
			end
		end,
		Tooltip = 'Only attacks when the sword is held'
	})
	LegitAura = Killaura:CreateToggle({
		Name = 'Swing only',
		Tooltip = 'Only attacks while swinging manually'
	})
end)
