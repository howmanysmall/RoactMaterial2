local Configuration = require(script.Parent.Parent.Configuration)
local Shadow = require(script.Parent.Shadow)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local Card = Roact.Component:extend("MaterialCard")

function Card:render()
	return Roact.createElement(RoactAnimate.Frame, {
		BackgroundTransparency = 1,
		ZIndex = self.props.ZIndex,
		Size = self.props.Size,
		AnchorPoint = self.props.AnchorPoint,
		Position = self.props.Position,
	}, {
		Container = Roact.createElement(RoactAnimate.Frame, {
			BackgroundColor3 = ThemeAccessor.Get(self, "BackgroundColor"),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
			ClipsDescendants = true,
		}, self.props[Roact.Children]),

		Shadow = Roact.createElement(Shadow, {
			Elevation = self.props.Elevation,
			ZIndex = 1,
		}),
	})
end

return Card
