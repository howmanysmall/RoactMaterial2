local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local ELEVATIONS = {1, 2, 3, 4, 6, 8, 9, 12, 16}

return function(Target)
	local Cards = table.create(10)
	for Index, Elevation in ipairs(ELEVATIONS) do
		Cards[Index] = Roact.createElement(RoactMaterial.Card, {
			Elevation = Elevation,
		}, table.create(1, Roact.createElement("TextLabel", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSans,
			Size = UDim2.fromScale(1, 1),
			Text = Elevation,
			TextSize = 24,
			ZIndex = 2,
		})))
	end

	Cards[10] = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.fromOffset(25, 25),
		CellSize = UDim2.fromOffset(150, 150),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	local Tree = Roact.mount(Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Dark,
	}, table.create(1, Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, Cards))), Target)

	return function()
		Roact.unmount(Tree)
	end
end
