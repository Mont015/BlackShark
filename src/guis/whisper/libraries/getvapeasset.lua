do
	local vapeAssets = {
		['newvape/assets/new/add.png'] = 'rbxassetid://121642387707174',
		['newvape/assets/new/aim.png'] = 'rbxassetid://122207028123421',
		['newvape/assets/new/allowedicon.png'] = 'rbxassetid://112336790299036',
		['newvape/assets/new/allowediconmini.png'] = 'rbxassetid://90142384730147',
		['newvape/assets/new/back.png'] = 'rbxassetid://80523803497740',
		['newvape/assets/new/backmini.png'] = 'rbxassetid://85859225495272',
		['newvape/assets/new/bind.png'] = 'rbxassetid://81399857677684',
		['newvape/assets/new/bindbkg.png'] = 'rbxassetid://101996225428926',
		['newvape/assets/new/blatant.png'] = 'rbxassetid://126929923309265',
		['newvape/assets/new/blur.png'] = 'rbxassetid://79246816170155',
		['newvape/assets/new/blurnoti.png'] = 'rbxassetid://124705876663719',
		['newvape/assets/new/close.png'] = 'rbxassetid://121816018671466',
		['newvape/assets/new/closemini.png'] = 'rbxassetid://108320409341289',
		['newvape/assets/new/closetiny.png'] = 'rbxassetid://71393233149714',
		['newvape/assets/new/colorpreview.png'] = 'rbxassetid://140438628568318',
		['newvape/assets/new/combat.png'] = 'rbxassetid://94762732349053',
		['newvape/assets/new/customtheme.png'] = 'rbxassetid://91756736022800',
		['newvape/assets/new/discord.png'] = 'rbxassetid://99871463341003',
		['newvape/assets/new/downexpand.png'] = 'rbxassetid://94197751291504',
		['newvape/assets/new/downexpandslider.png'] = 'rbxassetid://90289944682645',
		['newvape/assets/new/edit.png'] = 'rbxassetid://105801951237137',
		['newvape/assets/new/editlarge.png'] = 'rbxassetid://119233876755282',
		['newvape/assets/new/expandarrow.png'] = 'rbxassetid://86360332526471',
		['newvape/assets/new/friends.png'] = 'rbxassetid://92957214042038',
		['newvape/assets/new/inventory.png'] = 'rbxassetid://93264756888499',
		['newvape/assets/new/legit_mode_icon.png'] = 'rbxassetid://102858626075156',
		['newvape/assets/new/legit_switch.png'] = 'rbxassetid://127508881124779',
		['newvape/assets/new/min.png'] = 'rbxassetid://82175054487146',
		['newvape/assets/new/noti_alert.png'] = 'rbxassetid://82356478726846',
		['newvape/assets/new/noti_info.png'] = 'rbxassetid://102614825645099',
		['newvape/assets/new/noti_warning.png'] = 'rbxassetid://119631730212167',
		['newvape/assets/new/notification.png'] = 'rbxassetid://90300780458781',
		['newvape/assets/new/npcs.png'] = 'rbxassetid://104434365485227',
		['newvape/assets/new/overlaydots.png'] = 'rbxassetid://78012624671930',
		['newvape/assets/new/overlays.png'] = 'rbxassetid://136535637407545',
		['newvape/assets/new/overlayslarge.png'] = 'rbxassetid://127574141208160',
		['newvape/assets/new/pin.png'] = 'rbxassetid://92459145800579',
		['newvape/assets/new/players.png'] = 'rbxassetid://105137446428129',
		['newvape/assets/new/profiles.png'] = 'rbxassetid://126051451865127',
		['newvape/assets/new/radar.png'] = 'rbxassetid://97983828696086',
		['newvape/assets/new/rainbow_1.png'] = 'rbxassetid://101329996188554',
		['newvape/assets/new/rainbow_2.png'] = 'rbxassetid://72739074644654',
		['newvape/assets/new/rainbow_3.png'] = 'rbxassetid://100716555253397',
		['newvape/assets/new/rainbow_4.png'] = 'rbxassetid://133424174227092',
		['newvape/assets/new/range.png'] = 'rbxassetid://107794917650053',
		['newvape/assets/new/rangeindicator.png'] = 'rbxassetid://107038094175283',
		['newvape/assets/new/render.png'] = 'rbxassetid://125472576898654',
		['newvape/assets/new/search.png'] = 'rbxassetid://115611852955611',
		['newvape/assets/new/settingdots.png'] = 'rbxassetid://130896840048276',
		['newvape/assets/new/settings.png'] = 'rbxassetid://73820177347303',
		['newvape/assets/new/settingsmini.png'] = 'rbxassetid://115732118290997',
		['newvape/assets/new/targetinfo.png'] = 'rbxassetid://121604266095276',
		['newvape/assets/new/textgui.png'] = 'rbxassetid://99438663817412',
		['newvape/assets/new/theme.png'] = 'rbxassetid://111525258317113',
		['newvape/assets/new/utility.png'] = 'rbxassetid://108303206513893',
		['newvape/assets/new/vape.png'] = 'rbxassetid://118368171378409',
		['newvape/assets/new/vapelogo.png'] = 'rbxassetid://75601759342426',
		['newvape/assets/new/vapelogomini.png'] = 'rbxassetid://118368171378409',
		['newvape/assets/new/v4.png'] = 'rbxassetid://102549752760489',
		['newvape/assets/new/v4mini.png'] = 'rbxassetid://115213099001611',
		['newvape/assets/new/world.png'] = 'rbxassetid://118917453153459'
	}

	local function createDownloader(text)
		if vape.Loaded ~= true then
			local downloader = vape.Downloader
			if not downloader then
				downloader = Instance.new('Frame')
				downloader.AnchorPoint = Vector2.new(0.5, 0.5)
				downloader.BackgroundColor3 = Color3.fromRGB(18, 14, 27)
				downloader.BorderSizePixel = 0
				downloader.Position = UDim2.fromScale(0.5, 0.5)
				downloader.Size = UDim2.fromOffset(360, 142)
				downloader.Parent = vape.gui
				local corner = Instance.new('UICorner')
				corner.CornerRadius = UDim.new(0, 10)
				corner.Parent = downloader
				local stroke = Instance.new('UIStroke')
				stroke.Color = Color3.fromRGB(133, 83, 205)
				stroke.Transparency = 0.55
				stroke.Parent = downloader
				local loaderLogo = Instance.new('ImageLabel')
				loaderLogo.BackgroundTransparency = 1
				loaderLogo.Image = 'rbxassetid://118368171378409'
				loaderLogo.Position = UDim2.fromOffset(24, 24)
				loaderLogo.Size = UDim2.fromOffset(23, 23)
				loaderLogo.Parent = downloader
				local title = Instance.new('ImageLabel')
				title.BackgroundTransparency = 1
				title.Image = 'rbxassetid://75601759342426'
				title.Position = UDim2.fromOffset(57, 25)
				title.Size = UDim2.fromOffset(130, 20)
				title.Parent = downloader
				local caption = Instance.new('TextLabel')
				caption.BackgroundTransparency = 1
				caption.FontFace = uipallet.Font
				caption.Position = UDim2.fromOffset(24, 54)
				caption.Size = UDim2.fromOffset(312, 18)
				caption.Text = 'Preparing your experience'
				caption.TextColor3 = Color3.fromRGB(154, 142, 173)
				caption.TextSize = 12
				caption.TextXAlignment = Enum.TextXAlignment.Left
				caption.Parent = downloader
				local bar = Instance.new('Frame')
				bar.BackgroundColor3 = Color3.fromRGB(48, 39, 63)
				bar.BorderSizePixel = 0
				bar.Position = UDim2.fromOffset(24, 84)
				bar.Size = UDim2.fromOffset(312, 5)
				bar.Parent = downloader
				local barCorner = Instance.new('UICorner')
				barCorner.CornerRadius = UDim.new(1, 0)
				barCorner.Parent = bar
				local fill = Instance.new('Frame')
				fill.BackgroundColor3 = Color3.fromRGB(168, 102, 255)
				fill.BorderSizePixel = 0
				fill.Size = UDim2.fromScale(0.62, 1)
				fill.Parent = bar
				local fillCorner = Instance.new('UICorner')
				fillCorner.CornerRadius = UDim.new(1, 0)
				fillCorner.Parent = fill
				local status = Instance.new('TextLabel')
				status.Name = 'Status'
				status.BackgroundTransparency = 1
				status.FontFace = uipallet.Font
				status.Position = UDim2.fromOffset(24, 101)
				status.Size = UDim2.fromOffset(312, 18)
				status.TextColor3 = Color3.fromRGB(190, 181, 204)
				status.TextSize = 11
				status.TextXAlignment = Enum.TextXAlignment.Left
				status.Parent = downloader
				vape.Downloader = downloader
			end

			downloader.Status.Text = 'Loading  •  '..text:gsub('newvape/', '')
		end
	end

	local function downloadFile(path, callback)
		if not isfile(path) then
			createDownloader(path)

			local success, data = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/7GrandDadPGN/VapeCompiled/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
			end)

			if not success or data == '404: Not Found' then
				error(data)
			end

			if path:find('.lua') then
				data = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..data
			end

			writefile(path, data)
		end

		return (callback or readfile)(path)
	end

	getvapeasset = not inputService.TouchEnabled and getcustomasset and function(path)
		return downloadFile(path, getcustomasset)
	end or function(path)
		return vapeAssets[path] or ''
	end
end
