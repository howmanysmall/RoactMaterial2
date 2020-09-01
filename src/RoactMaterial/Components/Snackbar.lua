local Configuration = require(script.Parent.Parent.Configuration)
local _ = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate
local t = Configuration.t

local Snackbar = Roact.Component:extend("MaterialSnackbar")
Snackbar.defaultProps = {
	Position = "Center",
	Visible = false,
}

Snackbar.validateProps = t.interface({
	Position = t.optional(t.union(t.literal("Center"), t.literal("Left"), t.literal("Right"))),
	Visible = t.optional(t.boolean),
	Text = t.string,
})

local _ = { -- SNACKBAR_POSITIONS
	Center = {
		AnchorPoint = Vector2.new(0.5, 0),
		ExitPosition = UDim2.fromScale(0.5, 1),
		EnterPosition = UDim2.new(0.5, 0, 1, -56),
	},

	Left = {
		AnchorPoint = Vector2.new(),
		ExitPosition = UDim2.new(0, 7, 1, 0),
		EnterPosition = UDim2.new(0, 7, 1, -56),
	},

	Right = {
		AnchorPoint = Vector2.new(1, 0),
		ExitPosition = UDim2.new(1, -7, 1, 0),
		EnterPosition = UDim2.new(1, -7, 1, -56),
	},
}

function Snackbar:init(_)
	self:setState({})
end

function Snackbar.render(_)
	return Roact.createElement(RoactAnimate.Frame, {
		BackgroundTransparency = 1,
	})
end

return Snackbar