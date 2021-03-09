local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

return function(Target)
	local Tree = Roact.mount(Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Light,
	}, table.create(1, Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		RaisedButton = Roact.createElement(RoactMaterial.TransparentButton, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Flat = true,
			Position = UDim2.fromScale(0.5, 0.5),
			Text = "Flat",
		}),
	}))), Target)

	return function()
		Roact.unmount(Tree)
	end
end
