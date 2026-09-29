uipallet = {
	Main = Color3.fromRGB(28, 23, 38),
	Text = Color3.fromRGB(231, 225, 245),
	Font = Font.new('rbxasset://fonts/families/GothamSSm.json'),
	FontSemiBold = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.SemiBold),
	Tween = TweenInfo.new(0.16, Enum.EasingStyle.Linear)
}

do
	-- Whisper intentionally keeps its own purple palette on every reload.
	local data = nil
	if data then
		uipallet.Main = data.Main and Color3.fromRGB(unpack(data.Main)) or uipallet.Main
		uipallet.Text = data.Text and Color3.fromRGB(unpack(data.Text)) or uipallet.Text
		uipallet.Font = data.Font and Font.new(
			data.Font:find('rbxasset') and data.Font
			or string.format('rbxasset://fonts/families/%s.json', data.Font)
		) or uipallet.Font
		uipallet.FontSemiBold = Font.new(uipallet.Font.Family, Enum.FontWeight.SemiBold)
	end

	fontsize.Font = uipallet.Font
end
