local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local function ExampleComponent()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Dark,
	}, {
		MainFrame = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, {
			Slider = Roact.createElement(RoactMaterial.Slider, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
			}),
		}),
	})
end

return function(Target)
	local Tree = Roact.mount(Roact.createElement(ExampleComponent), Target)

	return function()
		Roact.unmount(Tree)
	end
end
