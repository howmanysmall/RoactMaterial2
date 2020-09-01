local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local function ExampleComponent()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Dark,
	}, table.create(1, Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, {
		RaisedButton = Roact.createElement(RoactMaterial.Button, {
			Text = "Raised",
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			OnClicked = function()
			end,
		}),

		FlatButton = Roact.createElement(RoactMaterial.Button, {
			Text = "Flat",
			Position = UDim2.new(0.5, 0, 0.5, 60),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Flat = true,
			OnClicked = function()
			end,
		}),
	})))
end

return function(Target)
	local Tree = Roact.mount(Roact.createElement(ExampleComponent), Target)

	return function()
		Roact.unmount(Tree)
	end
end