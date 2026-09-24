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
card.Size = UDim2.fromOffset(420, 210)
card.Position = UDim2.new(0.5, -210, 0.5, -105)
card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
card.BorderSizePixel = 0
card.ZIndex = 11
card.Parent = screenGui
Instance.new('UICorner', card).CornerRadius = UDim.new(0, 8)

local border = Instance.new('UIStroke')
border.Color = Color3.fromRGB(0, 200, 160)
border.Thickness = 1.5
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Parent = card

local logo = Instance.new('TextLabel')
logo.Size = UDim2.fromOffset(380, 50)
logo.Position = UDim2.fromOffset(20, 30)
logo.BackgroundTransparency = 1
logo.Text = 'BlackShark'
logo.TextColor3 = Color3.fromRGB(255, 255, 255)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 32
logo.ZIndex = 12
logo.Parent = card

local loadingText = Instance.new('TextLabel')
loadingText.Size = UDim2.fromOffset(380, 24)
loadingText.Position = UDim2.fromOffset(20, 88)
loadingText.BackgroundTransparency = 1
loadingText.Text = 'L O A D I N G . . .'
loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 13
loadingText.LetterSpacing = 2
loadingText.ZIndex = 12
loadingText.Parent = card

local barBg = Instance.new('Frame')
barBg.Size = UDim2.fromOffset(380, 6)
barBg.Position = UDim2.fromOffset(20, 118)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
barBg.BorderSizePixel = 0
barBg.ZIndex = 12
barBg.Parent = card
Instance.new('UICorner', barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new('Frame')
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 200, 160)
barFill.BorderSizePixel = 0
barFill.ZIndex = 13
barFill.Parent = barBg
Instance.new('UICorner', barFill).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new('TextLabel')
statusLabel.Size = UDim2.fromOffset(380, 20)
statusLabel.Position = UDim2.fromOffset(20, 132)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = 'Initializing your experience...'
statusLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.ZIndex = 12
statusLabel.Parent = card

local dotsFrame = Instance.new('Frame')
dotsFrame.Size = UDim2.fromOffset(380, 20)
dotsFrame.Position = UDim2.fromOffset(20, 162)
dotsFrame.BackgroundTransparency = 1
dotsFrame.ZIndex = 12
dotsFrame.Parent = card

local dots = {}
for i = 1, 4 do
	local dot = Instance.new('Frame')
	dot.Size = UDim2.fromOffset(10, 10)
	dot.Position = UDim2.fromOffset((i - 1) * 18, 5)
	dot.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
	dot.BorderSizePixel = 0
	dot.ZIndex = 13
	dot.Parent = dotsFrame
	Instance.new('UICorner', dot).CornerRadius = UDim.new(1, 0)
	dots[i] = dot
end

local activeDot = 1
local dotConn = game:GetService('RunService').Heartbeat:Connect(function()
	local t = tick() % 0.5
	if t < 0.1 then
		local newDot = math.floor(tick() / 0.5) % 4 + 1
		if newDot ~= activeDot then
			dots[activeDot].BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			activeDot = newDot
			dots[activeDot].BackgroundColor3 = Color3.fromRGB(0, 200, 160)
		end
	end
end)

local function setProgress(pct, status)
	TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(pct, 0, 1, 0)
	}):Play()
	if status then statusLabel.Text = status end
end

local function closeLoader()
	setProgress(1, 'Ready!')
	task.wait(0.5)
	dotConn:Disconnect()
	TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -210, 1, 20),
		BackgroundTransparency = 1
	}):Play()
	for _, v in card:GetDescendants() do
		if v:IsA('TextLabel') then
			TweenService:Create(v, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		elseif v:IsA('Frame') then
			TweenService:Create(v, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
		elseif v:IsA('UIStroke') then
			TweenService:Create(v, TweenInfo.new(0.4), {Transparency = 1}):Play()
		end
	end
	task.wait(0.6)
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

setProgress(0.05, 'Initializing your experience...')
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

setProgress(0.5, 'Downloading core files...')
task.wait(1.2)
local mainFile = downloadFile('newvape/main.lua')
setProgress(0.75, 'Loading modules...')
task.wait(1)
setProgress(0.9, 'Starting BlackShark...')
task.wait(0.8)

closeLoader()

return loadstring(mainFile, 'main')()
