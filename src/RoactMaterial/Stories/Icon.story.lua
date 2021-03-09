local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

return function(Target)
	local Icons = {
		UIGridLayout = Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.fromOffset(10, 10),
			CellSize = UDim2.fromOffset(18, 18),
			SortOrder = Enum.SortOrder.Name,
		}),
	}

	for Icon in next, RoactMaterial.IconSpritesheets do
		Icons[Icon] = Roact.createElement(RoactMaterial.Icon, {
			Icon = Icon,
			IconColor3 = Color3.new(),
			Size = UDim2.fromOffset(18, 18),
		})
	end

	local Tree = Roact.mount(Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Light,
	}, {
		Backing = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, {
			IconsFrame = Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				CanvasSize = UDim2.fromScale(0, 100),
				Position = UDim2.fromScale(0.15, 0.05),
				Size = UDim2.fromScale(0.7, 0.9),
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			}, Icons),
		}),
	}), Target)

	return function()
		Roact.unmount(Tree)
	end
end
