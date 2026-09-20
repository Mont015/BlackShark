local function isfile(file)
	local suc, res = pcall(readfile, file)
	return suc and type(res) == 'string' and res ~= ''
end

local delfile = delfile or function(file)
	writefile(file, '')
end

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'BlackSharkLoader'
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.IgnoreGuiInset = true
pcall(function() screenGui.Parent = game:GetService('CoreGui') end)
if not screenGui.Parent then
	screenGui.Parent = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
end

local bg = Instance.new('Frame')
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
bg.BorderSizePixel = 0
bg.Parent = screenGui

local glowOrb = Instance.new('ImageLabel')
glowOrb.Size = UDim2.fromOffset(400, 400)
glowOrb.Position = UDim2.new(0.5, -200, 0.5, -280)
glowOrb.BackgroundTransparency = 1
glowOrb.Image = 'rbxassetid://6015897843'
glowOrb.ImageColor3 = Color3.fromRGB(0, 120, 255)
glowOrb.ImageTransparency = 0.4
glowOrb.Parent = bg

local title = Instance.new('TextLabel')
title.Size = UDim2.fromOffset(600, 100)
title.Position = UDim2.new(0.5, -300, 0.5, -120)
title.BackgroundTransparency = 1
title.Text = 'BlackShark'
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 72
title.Parent = bg

local subtitle = Instance.new('TextLabel')
subtitle.Size = UDim2.fromOffset(600, 40)
subtitle.Position = UDim2.new(0.5, -300, 0.5, -45)
subtitle.BackgroundTransparency = 1
subtitle.Text = 'Loading your experience...'
subtitle.TextColor3 = Color3.fromRGB(100, 150, 255)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 20
subtitle.Parent = bg

local barBg = Instance.new('Frame')
barBg.Size = UDim2.fromOffset(500, 6)
barBg.Position = UDim2.new(0.5, -250, 0.5, 30)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
barBg.BorderSizePixel = 0
barBg.Parent = bg
Instance.new('UICorner', barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new('Frame')
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new('UICorner', barFill).CornerRadius = UDim.new(1, 0)

local statusText = Instance.new('TextLabel')
statusText.Size = UDim2.fromOffset(500, 30)
statusText.Position = UDim2.new(0.5, -250, 0.5, 48)
statusText.BackgroundTransparency = 1
statusText.Text = 'Initializing...'
statusText.TextColor3 = Color3.fromRGB(80, 80, 120)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = bg

local version = Instance.new('TextLabel')
version.Size = UDim2.fromOffset(200, 30)
version.Position = UDim2.new(1, -210, 1, -40)
version.BackgroundTransparency = 1
version.Text = 'v1.0'
version.TextColor3 = Color3.fromRGB(50, 50, 80)
version.Font = Enum.Font.Gotham
version.TextSize = 14
version.Parent = bg

local glowTween1 = game:GetService('TweenService'):Create(glowOrb, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	ImageTransparency = 0.7,
	Size = UDim2.fromOffset(440, 440),
	Position = UDim2.new(0.5, -220, 0.5, -300)
})
glowTween1:Play()

local titleTween = game:GetService('TweenService'):Create(title, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	TextColor3 = Color3.fromRGB(0, 150, 255)
})
titleTween:Play()

local function setProgress(pct, status)
	game:GetService('TweenService'):Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(pct, 0, 1, 0)
	}):Play()
	if status then
		statusText.Text = status
	end
end

local function closeLoader()
	setProgress(1, 'Done!')
	task.wait(0.5)
	game:GetService('TweenService'):Create(bg, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1
	}):Play()
	for _, v in bg:GetDescendants() do
		if v:IsA('TextLabel') or v:IsA('ImageLabel') then
			game:GetService('TweenService'):Create(v, TweenInfo.new(0.8), {ImageTransparency = 1, TextTransparency = 1}):Play()
		elseif v:IsA('Frame') then
			game:GetService('TweenService'):Create(v, TweenInfo.new(0.8), {BackgroundTransparency = 1}):Play()
		end
	end
	task.wait(0.9)
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

setProgress(0.05, 'Checking for updates...')

if not shared.VapeDeveloper then
	local assetVer = '1'
	local success, response = pcall(function()
		return game:HttpGet('https://api.github.com/repos/Mont015/BlackSharkCompiled/commits/main', true)
	end)
	local commit = success and response:match('"sha"%s*:%s*"([0-9a-f]+)"') or nil
	commit = commit and #commit == 40 and commit or 'main'

	setProgress(0.15, 'Checking cache...')

	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		setProgress(0.2, 'Wiping old cache...')
		wipeFolder('newvape')
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
	end

	if (isfile('newvape/profiles/asset.txt') and readfile('newvape/profiles/asset.txt') or '') ~= assetVer then
		wipeFolder('newvape/assets')
	end

	writefile('newvape/profiles/asset.txt', assetVer)
	writefile('newvape/profiles/commit.txt', commit)
end

setProgress(0.4, 'Downloading main.lua...')
local mainFile = downloadFile('newvape/main.lua')
setProgress(0.7, 'Loading core...')
task.wait(0.1)
setProgress(0.9, 'Starting BlackShark...')
task.wait(0.1)

closeLoader()

return loadstring(mainFile, 'main')()
