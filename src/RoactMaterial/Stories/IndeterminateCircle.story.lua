local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local function ExampleComponent()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Light,
	}, {
		MainFrame = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, {
			IndeterminateCircle = Roact.createElement(RoactMaterial.IndeterminateCircle, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
			}),

			IndeterminateCircle2 = Roact.createElement(RoactMaterial.IndeterminateCircle, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.7),
				AnimationSpeed = 3,
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