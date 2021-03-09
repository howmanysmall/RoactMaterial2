local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)
local Scheduler = require(script.Parent.Parent.Utility.Scheduler)

local ELEVATIONS = {1, 2, 3, 4, 6, 8, 9, 12, 16}

local ParentComponent = Roact.PureComponent:extend("ParentComponent")

function ParentComponent:init()
	self:setState({
		elevation = 1,
	})

	self.isMounted = false
end

function ParentComponent:render()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
	}, {
		TextLabel = Roact.createElement("TextLabel", {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			LayoutOrder = math.huge,
			Size = UDim2.fromScale(1, 1),
			Text = self.state.elevation,
			ZIndex = 2,
		}),

		Shadow = Roact.createElement(RoactMaterial.Shadow, {
			Elevation = self.state.elevation,
		}),
	})
end

function ParentComponent:didMount()
	self.isMounted = true
	Scheduler.FastSpawn(function()
		while true do
			Scheduler.Wait(1)
			if not self.isMounted then
				break
			end

			self:setState({
				elevation = ELEVATIONS[math.random(#ELEVATIONS)],
			})
		end
	end)
end

function ParentComponent:willUnmount()
	self.isMounted = false
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
				Font = Enum.Font.SourceSans,
				Size = UDim2.fromScale(1, 1),
				Text = tostring(Elevation),
				TextSize = 24,
				ZIndex = 2,
			}),
		})
	end

	table.insert(ElevationFrames, Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.fromOffset(25, 25),
		CellSize = UDim2.fromOffset(150, 150),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}))

	table.insert(ElevationFrames, Roact.createElement(ParentComponent))

	local Tree = Roact.mount(Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, ElevationFrames), Target)

	return function()
		Roact.unmount(Tree)
	end
end
