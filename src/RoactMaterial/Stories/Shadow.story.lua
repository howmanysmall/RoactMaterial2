local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)
local Promise = require(script.Parent.Parent.Parent.Promise)

local ELEVATIONS = {1, 2, 3, 4, 6, 8, 9, 12, 16}

local ParentComponent = Roact.Component:extend("ParentComponent")

function ParentComponent:init()
	self:setState({
		Elevation = 1,
	})
end

function ParentComponent:render()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
	}, {
		TextLabel = Roact.createElement("TextLabel", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Text = self.state.Elevation,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = math.huge,
		}),

		Shadow = Roact.createElement(RoactMaterial.Shadow, {
			Elevation = self.state.Elevation,
		}),
	})
end

function ParentComponent:didMount()
	self.Promise = Promise.Try(function()
		while true do
			Promise.Delay(1):Await()
			self:setState({
				Elevation = ELEVATIONS[math.random(#ELEVATIONS)],
			})
		end
	end)
end

function ParentComponent:willUnmount()
	self.Promise:Cancel()
	self.Promise = nil
end

return function(Target)
	local ElevationFrames = table.create(#ELEVATIONS + 2)
	for Index, Elevation in ipairs(ELEVATIONS) do
		ElevationFrames[Index] = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(75, 75),
			ZIndex = 1,
		}, {
			Shadow = Roact.createElement(RoactMaterial.Shadow, {
				Elevation = Elevation,
				ZIndex = 1,
			}),

			TextLabel = Roact.createElement("TextLabel", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BorderSizePixel = 0,
				Text = tostring(Elevation),
				Font = Enum.Font.SourceSans,
				TextSize = 24,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}),
		})
	end

	table.insert(ElevationFrames, Roact.createElement("UIGridLayout", {
		CellSize = UDim2.fromOffset(150, 150),
		CellPadding = UDim2.fromOffset(25, 25),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}))

	table.insert(ElevationFrames, Roact.createElement(ParentComponent))

	local Tree = Roact.mount(Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, ElevationFrames), Target)

	return function()
		Roact.unmount(Tree)
	end
end
