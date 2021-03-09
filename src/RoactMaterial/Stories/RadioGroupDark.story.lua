local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

return function(Target)
	local Tree = Roact.mount(Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Dark,
	}, table.create(1, Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		RadioGroup = Roact.createElement(RoactMaterial.RadioGroup, {
			CurrentId = "test1",
			CurrentIdChanged = print,
			Options = {
				test1 = "Test 1",
				test2 = "Test 2",
				test3 = "Test 3",
			},

			Position = UDim2.fromScale(0.5, 0.5),
			SizeFromContents = true,
		}),
	}))), Target)

	return function()
		Roact.unmount(Tree)
	end
end
