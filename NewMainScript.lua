local function isfile(file)
	local suc, res = pcall(readfile, file)
	return suc and type(res) == 'string' and res ~= ''
end

local delfile = delfile or function(file)
	writefile(file, '')
end

local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local lplr = Players.LocalPlayer

local screenGui = Instance.new('ScreenGui')
screenGui.Name = 'BlackSharkLoader'
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 9999
screenGui.IgnoreGuiInset = true
screenGui.Parent = lplr:WaitForChild('PlayerGui')

local card = Instance.new('Frame')
card.Size = UDim2.fromOffset(420, 180)
card.Position = UDim2.new(0.5, -210, 0.5, -90)
card.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
card.BorderSizePixel = 0
card.ZIndex = 11
card.Parent = screenGui
Instance.new('UICorner', card).CornerRadius = UDim.new(0, 12)

local cardStroke = Instance.new('UIStroke')
cardStroke.Color = Color3.fromRGB(40, 40, 50)
cardStroke.Thickness = 1
cardStroke.Parent = card

local accentLine = Instance.new('Frame')
accentLine.Size = UDim2.fromOffset(420, 2)
accentLine.Position = UDim2.fromOffset(0, 0)
accentLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
accentLine.BorderSizePixel = 0
accentLine.ZIndex = 12
accentLine.Parent = card
Instance.new('UICorner', accentLine).CornerRadius = UDim.new(0, 2)

local titleLabel = Instance.new('TextLabel')
titleLabel.Size = UDim2.fromOffset(380, 40)
titleLabel.Position = UDim2.fromOffset(20, 22)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = 'BlackShark'
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 12
titleLabel.Parent = card

local versionLabel = Instance.new('TextLabel')
versionLabel.Size = UDim2.fromOffset(380, 20)
versionLabel.Position = UDim2.fromOffset(20, 58)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = 'v1.0'
versionLabel.TextColor3 = Color3.fromRGB(60, 60, 70)
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 12
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.ZIndex = 12
versionLabel.Parent = card

local statusLabel = Instance.new('TextLabel')
statusLabel.Size = UDim2.fromOffset(280, 20)
statusLabel.Position = UDim2.fromOffset(20, 108)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = 'Initializing...'
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 12
statusLabel.Parent = card

local pctLabel = Instance.new('TextLabel')
pctLabel.Size = UDim2.fromOffset(80, 20)
pctLabel.Position = UDim2.fromOffset(320, 108)
pctLabel.BackgroundTransparency = 1
pctLabel.Text = '0%'
pctLabel.TextColor3 = Color3.fromRGB(80, 80, 100)
pctLabel.Font = Enum.Font.GothamBold
pctLabel.TextSize = 12
pctLabel.TextXAlignment = Enum.TextXAlignment.Right
pctLabel.ZIndex = 12
pctLabel.Parent = card

local barBg = Instance.new('Frame')
barBg.Size = UDim2.fromOffset(380, 3)
barBg.Position = UDim2.fromOffset(20, 138)
barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
barBg.BorderSizePixel = 0
barBg.ZIndex = 12
barBg.Parent = card
Instance.new('UICorner', barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new('Frame')
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 13
barFill.Parent = barBg
Instance.new('UICorner', barFill).CornerRadius = UDim.new(1, 0)

local function setProgress(pct, status)
	TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(pct, 0, 1, 0)
	}):Play()
	pctLabel.Text = math.floor(pct * 100)..'%'
	if status then statusLabel.Text = status end
end

local function closeLoader()
	setProgress(1, 'Ready')
	task.wait(0.5)
	for _, v in card:GetDescendants() do
		if v:IsA('TextLabel') then
			TweenService:Create(v, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
		elseif v:IsA('Frame') then
			TweenService:Create(v, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
		end
	end
	TweenService:Create(card, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
	task.wait(0.7)
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
task.wait(1)

if not shared.VapeDeveloper then
	local assetVer = '1'
	setProgress(0.15, 'Checking for updates...')
	task.wait(0.8)

	local success, response = pcall(function()
		return game:HttpGet('https://api.github.com/repos/Mont015/BlackSharkCompiled/commits/main', true)
	end)
	local commit = success and response:match('"sha"%s*:%s*"([0-9a-f]+)"') or nil
	commit = commit and #commit == 40 and commit or 'main'

	setProgress(0.28, 'Verifying cache...')
	task.wait(0.8)

	local hasUpdate = commit ~= 'main' and (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit

	if hasUpdate then
		setProgress(0.38, 'Clearing outdated files...')
		task.wait(0.6)
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
		writefile('newvape/profiles/commit.txt', commit)
	end

	if (isfile('newvape/profiles/asset.txt') and readfile('newvape/profiles/asset.txt') or '') ~= assetVer then
		wipeFolder('newvape/assets')
	end

	writefile('newvape/profiles/asset.txt', assetVer)
	writefile('newvape/profiles/commit.txt', commit)
end

setProgress(0.5, 'Downloading core...')
task.wait(1.2)
local mainFile = downloadFile('newvape/main.lua')
setProgress(0.75, 'Loading modules...')
task.wait(1)
setProgress(0.9, 'Starting BlackShark...')
task.wait(0.8)

closeLoader()

return loadstring(mainFile, 'main')()
