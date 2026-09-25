local Blink
local Type
local AutoSend
local AutoSendLength
local oldphys, oldsend

local function setNetworkRates(physicsrate, senderrate)
	if type(setfflag) ~= 'function' then return false end
	return pcall(function()
		setfflag('PhysicsSenderMaxBandwidthBps', physicsrate)
		setfflag('DataSenderRate', senderrate)
	end)
end

Blink = vape.Categories.Utility:CreateModule({
	Name = 'Blink',
	Function = function(callback)
		if callback then
			if type(setfflag) ~= 'function' then
				notif('Blink', 'Fake lag is not supported by this executor.', 5, 'warning')
				task.defer(function()
					if Blink.Enabled then Blink:Toggle() end
				end)
				return
			end
			local teleported
			Blink:Clean(lplr.OnTeleport:Connect(function()
				setNetworkRates('38760', '60')
				teleported = true
			end))

			repeat
				local physicsrate, senderrate = '0', Type.Value == 'All' and '-1' or '60'
				if AutoSend.Enabled and tick() % (AutoSendLength.Value + 0.1) > AutoSendLength.Value then
					physicsrate, senderrate = '38760', '60'
				end

				if physicsrate ~= oldphys or senderrate ~= oldsend then
					if not setNetworkRates(physicsrate, senderrate) then
						notif('Blink', 'Fake lag is not supported by this executor.', 5, 'warning')
						task.defer(function()
							if Blink.Enabled then Blink:Toggle() end
						end)
						break
					end
					oldphys, oldsend = physicsrate, senderrate
				end

				task.wait(0.03)
			until (not Blink.Enabled and not teleported)
		else
			setNetworkRates('38760', '60')
			oldphys, oldsend = nil, nil
		end
	end,
	Tooltip = 'Chokes packets until disabled. Requires executor support.'
})
Type = Blink:CreateDropdown({
	Name = 'Type',
	List = {'Movement Only', 'All'},
	Tooltip = 'Movement Only - Only chokes movement packets\nAll - Chokes remotes & movement'
})
AutoSend = Blink:CreateToggle({
	Name = 'Auto send',
	Function = function(callback)
		AutoSendLength.Object.Visible = callback
	end,
	Tooltip = 'Automatically send packets in intervals'
})
AutoSendLength = Blink:CreateSlider({
	Name = 'Send threshold',
	Min = 0,
	Max = 1,
	Decimal = 100,
	Darker = true,
	Visible = false,
	Suffix = function(val)
		return val == 1 and 'second' or 'seconds'
	end
})
