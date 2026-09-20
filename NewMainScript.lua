local function isfile(file)
	local suc, res = pcall(readfile, file)
	return suc and type(res) == 'string' and res ~= ''
end

local delfile = delfile or function(file)
	writefile(file, '')
end

local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'BlackSharkLoader'
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.IgnoreGuiInset = true
pcall(function() screenGui.Parent = game:GetService('CoreGui') end)
if not screenGui.Parent then
	screenGui.Parent = Players.LocalPlayer:WaitForChild('PlayerGui')
end

local container = Instance.new('Frame')
container.Size = UDim2.fromOffset(320, 110)
container.Position = UDim2.new(0.5, -160, 0.5, -55)
container.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
container.BorderSizePixel = 0
container.ZIndex = 10
container.Parent = screenGui
Instance.new('UICorner', container).CornerRadius = UDim.new(0, 6)

local border = Instance.new('UIStroke')
border.Color = Color3.fromRGB(0, 100, 255)
border.Thickness = 1
border.Parent = container

local title = Instance.new('TextLabel')
title.Size = UDim2.new(1, -20, 0, 28)
title.Position = UDim2.fromOffset(12, 10)
title.BackgroundTransparency = 1
title.Text = 'BLACKSHARK'
title.TextColor3 = Color3.fromRGB(0, 140, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = container

local divider = Instance.new('Frame')
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.fromOffset(12, 38)
divider.BackgroundColor3 = Color3.fromRGB(0, 60, 140)
divider.BorderSizePixel = 0
divider.ZIndex = 11
divider.Parent = container

local statusText = Instance.new('TextLabel')
statusText.Size = UDim2.new(1, -20, 0, 20)
statusText.Position = UDim2.fromOffset(12, 46)
statusText.BackgroundTransparency = 1
statusText.Text = '> Initializing...'
statusText.TextColor3 = Color3.fromRGB(80, 120, 200)
statusText.Font = Enum.Font.Code
statusText.TextSize = 13
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.ZIndex = 11
statusText.Parent = container

local barBg = Instance.new('Frame')
barBg.Size = UDim2.new(1, -24, 0, 4)
barBg.Position = UDim2.fromOffset(12, 76)
barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
barBg.BorderSizePixel = 0
barBg.ZIndex = 11
barBg.Parent = container
Instance.new('UICorner', barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new('Frame')
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 12
barFill.Parent = barBg
Instance.new('UICorner', barFill).CornerRadius = UDim.new(1, 0)

local pctLabel = Instance.new('TextLabel')
pctLabel.Size = UDim2.new(1, -24, 0, 18)
pctLabel.Position = UDim2.fromOffset(12, 86)
pctLabel.BackgroundTransparency = 1
pctLabel.Text = '0%'
pctLabel.TextColor3 = Color3.fromRGB(40, 80, 160)
pctLabel.Font = Enum.Font.Code
pctLabel.TextSize = 11
pctLabel.TextXAlignment = Enum.TextXAlignment.Right
pctLabel.ZIndex = 11
pctLabel.Parent = container

local updateBtn = Instance.new('TextButton')
updateBtn.Size = UDim2.new(1, -24, 0, 28)
updateBtn.Position = UDim2.fromOffset(12, 46)
updateBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 200)
updateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
updateBtn.Font = Enum.Font.GothamBold
updateBtn.TextSize = 13
updateBtn.Text = 'New update found — click to update'
updateBtn.BorderSizePixel = 0
updateBtn.ZIndex = 12
updateBtn.Visible = false
updateBtn.Parent = container
Instance.new('UICorner', updateBtn).CornerRadius = UDim.new(0, 4)

local function setProgress(pct, status)
	TweenService:Create(barFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(pct, 0, 1, 0)
	}):Play()
	pctLabel.Text = math.floor(pct * 100)..'%'
	if status then statusText.Text = '> '..status end
end

local function closeLoader()
	setProgress(1, 'Ready')
	task.wait(0.8)
	TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -160, 1, 20)
	}):Play()
	task.wait(0.5)
	screenGui:Destroy()
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/Mont015/BlackSharkCompiled/main/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'newvape', 'newvape/games', 'newvape/profiles', 'newvape/assets', 'newvape/libraries', 'newvape/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

setProgress(0.05, 'Initializing...')
task.wait(1.5)

if not shared.VapeDeveloper then
	local assetVer = '1'
	setProgress(0.15, 'Checking for updates...')
	task.wait(1)
	local success, response = pcall(function()
		return game:HttpGet('https://api.github.com/repos/Mont015/BlackSharkCompiled/commits/main', true)
	end)
	local commit = success and response:match('"sha"%s*:%s*"([0-9a-f]+)"') or nil
	commit = commit and #commit == 40 and commit or 'main'

	setProgress(0.3, 'Verifying cache...')
	task.wait(1)

	local hasUpdate = commit ~= 'main' and (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit

	if hasUpdate then
		statusText.Visible = false
		updateBtn.Visible = true
		local clicked = false
		updateBtn.MouseButton1Click:Connect(function()
			if clicked then return end
			clicked = true
			updateBtn.Visible = false
			statusText.Visible = true
			setProgress(0.4, 'Updating files...')
			task.wait(0.8)
			wipeFolder('newvape/games')
			wipeFolder('newvape/guis')
			wipeFolder('newvape/libraries')
			writefile('newvape/profiles/commit.txt', commit)
		end)
		repeat task.wait() until not updateBtn.Visible
	end

	if (isfile('newvape/profiles/asset.txt') and readfile('newvape/profiles/asset.txt') or '') ~= assetVer then
		wipeFolder('newvape/assets')
	end

	writefile('newvape/profiles/asset.txt', assetVer)
	writefile('newvape/profiles/commit.txt', commit)
end

setProgress(0.55, 'Downloading core...')
task.wait(1.5)
local mainFile = downloadFile('newvape/main.lua')
setProgress(0.75, 'Loading modules...')
task.wait(1.5)
setProgress(0.9, 'Starting BlackShark...')
task.wait(1.2)

closeLoader()

return loadstring(mainFile, 'main')()
