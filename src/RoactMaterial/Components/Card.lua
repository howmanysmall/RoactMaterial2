local Configuration = require(script.Parent.Parent.Configuration)
local Shadow = require(script.Parent.Shadow)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate
local t = Configuration.t

local Card = Roact.PureComponent:extend("MaterialCard")
Card.validateProps = t.interface({
	AnchorPoint = t.optional(t.Vector2),
	Elevation = t.optional(t.integer),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	ZIndex = t.optional(t.integer),
})

function Card:render()
	return Roact.createElement(RoactAnimate.Frame, {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		Position = self.props.Position,
		Size = self.props.Size,
		ZIndex = self.props.ZIndex,
	}, {
		Container = Roact.createElement(RoactAnimate.Frame, {
			BackgroundColor3 = ThemeAccessor.Get(self, "BackgroundColor"),
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
		}, self.props[Roact.Children]),

		Shadow = Roact.createElement(Shadow, {
			Elevation = self.props.Elevation,
			ZIndex = 1,
		}),
	})
end

return Card
