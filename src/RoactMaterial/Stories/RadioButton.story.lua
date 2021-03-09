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
		UIGridLayout = Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(10, 10),
			CellSize = UDim2.fromOffset(24, 24),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		CheckedButton = Roact.createElement(RoactMaterial.RadioButton, {Checked = true}),
		UncheckedButton = Roact.createElement(RoactMaterial.RadioButton),
	}))), Target)

	return function()
		Roact.unmount(Tree)
	end
end
