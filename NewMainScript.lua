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

local ScreenGui = Instance.new('ScreenGui', lplr:WaitForChild('PlayerGui'))
ScreenGui.DisplayOrder = 9999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new('Frame', ScreenGui)
local ImageLabel = Instance.new('ImageLabel', Frame)
local UIGradient = Instance.new('UIGradient', ImageLabel)
local UICorner1 = Instance.new('UICorner', Frame)
local TopBorder = Instance.new('Frame', Frame)
local TopBorderInner = Instance.new('Frame', Frame)
local BottomBorder = Instance.new('Frame', Frame)
local BottomBorderInner = Instance.new('Frame', Frame)
local LoadingTextFrame = Instance.new('Frame', Frame)
local LoadingLabel = Instance.new('TextLabel', LoadingTextFrame)
local BarBg = Instance.new('Frame', Frame)
local UICorner2 = Instance.new('UICorner', BarBg)
local BarFill = Instance.new('Frame', BarBg)
local UICorner3 = Instance.new('UICorner', BarFill)
local StatusLabel = Instance.new('TextLabel', Frame)
local Dot1 = Instance.new('Frame', Frame)
local UICorner4 = Instance.new('UICorner', Dot1)
local Dot2 = Instance.new('Frame', Frame)
local UICorner5 = Instance.new('UICorner', Dot2)
local Dot3 = Instance.new('Frame', Frame)
local UICorner6 = Instance.new('UICorner', Dot3)
local Dot4 = Instance.new('Frame', Frame)
local UICorner7 = Instance.new('UICorner', Dot4)

local teal = Color3.new(0.0314, 0.7961, 0.6392)
local white = Color3.new(1, 1, 1)
local black = Color3.new(0, 0, 0)
local gray = Color3.new(0.3098, 0.3098, 0.3098)

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 417, 0, 199)
Frame.BackgroundColor3 = black
Frame.BorderSizePixel = 0

ImageLabel.Position = UDim2.new(0.2896, 0, 0.1454, 0)
ImageLabel.Size = UDim2.new(0, 180, 0, 32)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 0
ImageLabel.Image = 'rbxassetid://111167176116900'

UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, white),
	ColorSequenceKeypoint.new(0.9948097467422485, Color3.new(0.0313725508749485, 0.7960784435272217, 0.6392157077789307)),
	ColorSequenceKeypoint.new(1, white)
})

TopBorder.Position = UDim2.new(0, 0, 0, 0)
TopBorder.Size = UDim2.new(1, 0, 0, 4)
TopBorder.BackgroundColor3 = teal
TopBorder.BorderSizePixel = 0

TopBorderInner.BackgroundTransparency = 1
TopBorderInner.Size = UDim2.new(0, 0, 0, 0)

BottomBorder.Position = UDim2.new(0, 0, 1, -4)
BottomBorder.Size = UDim2.new(1, 0, 0, 4)
BottomBorder.BackgroundColor3 = teal
BottomBorder.BorderSizePixel = 0

BottomBorderInner.BackgroundTransparency = 1
BottomBorderInner.Size = UDim2.new(0, 0, 0, 0)

LoadingTextFrame.Position = UDim2.new(0.3692, 0, 0.4038, 0)
LoadingTextFrame.Size = UDim2.new(0, 112, 0, 26)
LoadingTextFrame.BackgroundTransparency = 1
LoadingTextFrame.BorderSizePixel = 0

LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.BorderSizePixel = 0
LoadingLabel.Text = ' L O A D I N G . . .'
LoadingLabel.TextColor3 = gray
LoadingLabel.Font = Enum.Font.Nunito
LoadingLabel.TextSize = 17

BarBg.Position = UDim2.new(0.0979, 0, 0.5687, 0)
BarBg.Size = UDim2.new(0, 334, 0, 10)
BarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BarBg.BorderSizePixel = 0
BarBg.ZIndex = 2
UICorner2.CornerRadius = UDim.new(1, 0)

BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.new(0.1882, 1, 0.9451)
BarFill.BorderSizePixel = 0
BarFill.ZIndex = 3
UICorner3.CornerRadius = UDim.new(1, 0)

StatusLabel.Position = UDim2.new(0.2874, 0, 0.6573, 0)
StatusLabel.Size = UDim2.new(0, 180, 0, 27)
StatusLabel.BackgroundTransparency = 1
StatusLabel.BorderSizePixel = 0
StatusLabel.Text = 'Initializing your experience...'
StatusLabel.TextColor3 = gray
StatusLabel.Font = Enum.Font.Nunito
StatusLabel.TextSize = 18

local dotColor = teal
local dotInactive = white

Dot1.Position = UDim2.new(0.4158, 0, 0.8216, 0)
Dot1.Size = UDim2.new(0, 12, 0, 12)
Dot1.BackgroundColor3 = dotColor
Dot1.BorderSizePixel = 0
UICorner4.CornerRadius = UDim.new(1, 0)

Dot2.Position = UDim2.new(0.4625, 0, 0.8216, 0)
Dot2.Size = UDim2.new(0, 12, 0, 12)
Dot2.BackgroundColor3 = dotInactive
Dot2.BorderSizePixel = 0
UICorner5.CornerRadius = UDim.new(1, 0)

Dot3.Position = UDim2.new(0.5092, 0, 0.8216, 0)
Dot3.Size = UDim2.new(0, 12, 0, 12)
Dot3.BackgroundColor3 = dotInactive
Dot3.BorderSizePixel = 0
UICorner6.CornerRadius = UDim.new(1, 0)

Dot4.Position = UDim2.new(0.5559, 0, 0.8216, 0)
Dot4.Size = UDim2.new(0, 12, 0, 12)
Dot4.BackgroundColor3 = dotInactive
Dot4.BorderSizePixel = 0
UICorner7.CornerRadius = UDim.new(1, 0)

local dots = {Dot1, Dot2, Dot3, Dot4}

local function setProgress(pct, status)
	TweenService:Create(BarFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(pct, 0, 1, 0)
	}):Play()
	if status then StatusLabel.Text = status end
	local activeDots = math.floor(pct * 4)
	for i, dot in dots do
		dot.BackgroundColor3 = i <= activeDots and teal or dotInactive
	end
end

local function closeLoader()
	setProgress(1, 'Ready!')
	for _, dot in dots do dot.BackgroundColor3 = teal end
	task.wait(0.5)
	TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 1.2, 0)
	}):Play()
	task.wait(0.6)
	ScreenGui:Destroy()
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
