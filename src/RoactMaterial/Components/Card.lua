local Configuration = require(script.Parent.Parent.Configuration)
local Shadow = require(script.Parent.Shadow)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate
local t = Configuration.t

local Card = Roact.Component:extend("MaterialCard")
Card.validateProps = t.interface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	ZIndex = t.optional(t.integer),
	Elevation = t.optional(t.integer),
})

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
