local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

return function(Target)
	local Icons = {
		Roact.createElement("UIGridLayout", {
			CellSize = UDim2.fromOffset(18, 18),
			CellPadding = UDim2.fromOffset(10, 10),
			SortOrder = Enum.SortOrder.Name,
		}),
	}

	for Icon in next, RoactMaterial.IconSpritesheets do
		Icons[Icon] = Roact.createElement(RoactMaterial.Icon, {
			Icon = Icon,
			Size = UDim2.fromOffset(18, 18),
			IconColor3 = Color3.new(),
		})
	end

	local Tree = Roact.mount(Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Light,
	}, {
		Backing = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, {
			IconsFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(0.7, 0.9),
				Position = UDim2.fromScale(0.15, 0.05),
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 100),
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			}, Icons),
		}),
	}), Target)

	return function()
		Roact.unmount(Tree)
	end
end