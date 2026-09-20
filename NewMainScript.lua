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

local bg = Instance.new('Frame')
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.ZIndex = 10
bg.Parent = screenGui

local title = Instance.new('TextLabel')
title.Size = UDim2.fromOffset(600, 80)
title.Position = UDim2.new(0.5, -300, 0.5, -80)
title.BackgroundTransparency = 1
title.Text = 'BlackShark'
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 60
title.ZIndex = 11
title.Parent = bg

local barBg = Instance.new('Frame')
barBg.Size = UDim2.fromOffset(400, 6)
barBg.Position = UDim2.new(0.5, -200, 0.5, 20)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBg.BorderSizePixel = 0
barBg.ZIndex = 11
barBg.Parent = bg
Instance.new('UICorner', barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new('Frame')
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 12
barFill.Parent = barBg
Instance.new('UICorner', barFill).CornerRadius = UDim.new(1, 0)

local statusText = Instance.new('TextLabel')
statusText.Size = UDim2.fromOffset(400, 30)
statusText.Position = UDim2.new(0.5, -200, 0.5, 36)
statusText.BackgroundTransparency = 1
statusText.Text = 'Initializing...'
statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.ZIndex = 11
statusText.Parent = bg

local function setProgress(pct, status)
	barFill.Size = UDim2.new(pct, 0, 1, 0)
	if status then statusText.Text = status end
end

local function closeLoader()
	setProgress(1, 'Done!')
	task.wait(0.3)
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

	setProgress(0.2, 'Checking cache...')

	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		setProgress(0.3, 'Wiping old cache...')
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

setProgress(0.5, 'Downloading...')
local mainFile = downloadFile('newvape/main.lua')
setProgress(0.8, 'Loading...')
task.wait(0.1)
setProgress(0.95, 'Starting...')
task.wait(0.1)

closeLoader()

return loadstring(mainFile, 'main')()
