local component = {
	Buttons = {},
	Type = 'MainWindow'
}

local window = Instance.new('TextButton')
window.AutoButtonColor = false
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.BackgroundColor3 = Color3.fromRGB(17, 14, 24)
window.Name = 'GUICategory'
window.Position = UDim2.new(0.5, 0, 0.5, 0)
window.Size = UDim2.fromOffset(820, 500)
window.Text = ''
	window.ClipsDescendants = true
window.Parent = clickgui
component.Object = window

-- Old floating-window positions must never be reused by this dashboard.
local function lockDashboard()
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.Size = UDim2.fromOffset(820, 500)
end
clickgui:GetPropertyChangedSignal('Visible'):Connect(function()
	if clickgui.Visible then
		task.defer(lockDashboard)
	end
end)

addCorner(window)
local sidebar = Instance.new('Frame')
sidebar.BackgroundColor3 = Color3.fromRGB(23, 18, 33)
sidebar.BorderSizePixel = 0
sidebar.Name = 'Sidebar'
sidebar.Size = UDim2.fromOffset(238, 500)
sidebar.Parent = window
local logo = Instance.new('ImageLabel')
logo.BackgroundTransparency = 1
logo.Image = getvapeasset('newvape/assets/new/vapelogomini.png')
logo.ImageColor3 = Color3.new(1, 1, 1)
logo.Name = 'VapeLogo'
logo.Position = UDim2.fromOffset(12, 11)
logo.Size = UDim2.fromOffset(20, 20)
logo.Visible = true
logo.Parent = window
local v4logo = Instance.new('ImageLabel')
v4logo.BackgroundTransparency = 1
v4logo.Image = getvapeasset('newvape/assets/new/v4mini.png')
v4logo.Name = 'V4Logo'
v4logo.Position = UDim2.new(1, -1, 0, 0)
v4logo.Size = UDim2.fromOffset(23, 16)
v4logo.Visible = false
v4logo.Parent = logo
local wordmark = Instance.new('ImageLabel')
wordmark.BackgroundTransparency = 1
wordmark.Image = 'rbxassetid://75601759342426'
wordmark.Name = 'WhisperBrand'
wordmark.Position = UDim2.fromOffset(42, 12)
wordmark.Size = UDim2.fromOffset(124, 18)
wordmark.Parent = window
local children = Instance.new('Frame')
children.BackgroundTransparency = 1
children.Position = UDim2.fromOffset(9, 112)
children.Size = UDim2.fromOffset(220, 374)
children.Parent = window
local windowlist = Instance.new('UIListLayout')
windowlist.HorizontalAlignment = Enum.HorizontalAlignment.Center
windowlist.Padding = UDim.new(0, 5)
windowlist.SortOrder = Enum.SortOrder.LayoutOrder
windowlist.Parent = children
local settingsbutton = Instance.new('TextButton')
settingsbutton.BackgroundTransparency = 1
settingsbutton.Position = UDim2.fromOffset(192, 10)
settingsbutton.Size = UDim2.fromOffset(40, 40)
settingsbutton.Text = ''
settingsbutton.Parent = window
addTooltip(settingsbutton, 'Open settings')
local settingsicon = Instance.new('ImageLabel')
settingsicon.BackgroundTransparency = 1
settingsicon.Image = getvapeasset('newvape/assets/new/settings.png')
settingsicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
settingsicon.Position = UDim2.fromOffset(15, 12)
settingsicon.Size = UDim2.fromOffset(14, 14)
settingsicon.Parent = settingsbutton
local discord = Instance.new('ImageButton')
discord.BackgroundTransparency = 1
discord.Image = getvapeasset('newvape/assets/new/discord.png')
discord.Position = UDim2.fromOffset(168, 21)
discord.Size = UDim2.fromOffset(16, 16)
discord.Parent = window
addTooltip(discord, 'Join discord')
local stroke = Instance.new('UIStroke')
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(85, 85, 85)
stroke.Transparency = 0.8
stroke.Parent = window
local settingspane = components.SettingsPane({
	Name = 'Settings',
	Main = true
}, window, component)
component.Settings = settingspane

function component:Color(hue, sat, val, isRainbow)
	v4logo.ImageColor3 = Color3.fromHSV(hue, sat, val)

	for _, button in self.Buttons do
		if button.Enabled then
			button.Object.TextColor3 = isRainbow and Color3.fromHSV(vape:Color((hue - (button.Index * 0.025)) % 1)) or Color3.fromHSV(hue, sat, val)

			if button.Icon then
				button.Icon.ImageColor3 = button.Object.TextColor3
			end
		end
	end
end

function component:Load(data)
	for name, paneData in data.Settings do
		local pane = vape.Settings[name]
		if pane then
			pane:Load(paneData)
		end
	end

	-- Positions saved by the previous floating-window UI use a top-left anchor.
	-- Whisper is a fixed dashboard, so do not reuse that incompatible position.
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.Size = UDim2.fromOffset(820, 500)
end

function component:Save(data)
	data.Main = {
		Position = {
			X = window.Position.X.Offset,
			Y = window.Position.Y.Offset
		},
		Settings = {}
	}

	for name, pane in vape.Settings do
		pane:Save(data.Main.Settings)
	end
end

for index, comp in components do
	component['Create'..index] = function(_, props)
		return comp(props, children, component)
	end
end

discord.MouseButton1Click:Connect(function()
	task.spawn(function()
		local body = httpService:JSONEncode({
			nonce = httpService:GenerateGUID(false),
			args = {
				invite = {code = 'VZEQJxMSnG'},
				code = 'VZEQJxMSnG'
			},
			cmd = 'INVITE_BROWSER'
		})

		for i = 1, 14 do
			task.spawn(function()
				pcall(function()
					request({
						Method = 'POST',
						Url = 'http://127.0.0.1:64'..(53 + i)..'/rpc?v=1',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = body
					})
				end)
			end)
		end
	end)

	task.spawn(function()
		tooltip.Text = 'Copied!'
		setclipboard('https://discord.gg/VZEQJxMSnG')
	end)
end)

settingsbutton.MouseEnter:Connect(function()
	settingsicon.ImageColor3 = uipallet.Text
end)

settingsbutton.MouseLeave:Connect(function()
	settingsicon.ImageColor3 = color.Light(uipallet.Main, 0.37)
end)

settingsbutton.MouseButton1Click:Connect(function()
	for _, category in vape.Categories do
		if category.Type == 'Category' then
			category.Object.Visible = false
		end
	end
	settingspane.Object.Visible = true
end)

windowlist:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
	if vape.ThreadFix then
		setthreadidentity(8)
	end

window.Size = UDim2.fromOffset(820, 500)
	for _, button in component.Buttons do
		if button.Icon then
			button.Object.Text = string.rep(' ', 39 * scale.Scale)..button.Name
		end
	end
end)

vape.Categories.Main = component

return component
