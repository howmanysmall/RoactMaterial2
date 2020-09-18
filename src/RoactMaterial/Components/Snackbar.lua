local Configuration = require(script.Parent.Parent.Configuration)
local Shadow = require(script.Parent.Shadow)
local TextView = require(script.Parent.TextView)

local _Promise = Configuration.Promise
local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate
local t = Configuration.t

-- Constants
local HEIGHT = 48
local MINIMUM_WIDTH = 312
local PADDING = 16

local Snackbar = Roact.Component:extend("MaterialSnackbar")
Snackbar.defaultProps = {
	Position = "Center",
	Visible = false,
	VisibleTime = 5,
}

Snackbar.validateProps = t.interface({
	Position = t.optional(t.union(t.literal("Center"), t.literal("Left"), t.literal("Right"))),
	Text = t.string,
	Visible = t.optional(t.boolean),
	VisibleTime = t.optional(t.number),
})

local SNACKBAR_POSITIONS = { -- SNACKBAR_POSITIONS
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

function Snackbar:init(props)
	local snackbarPosition = SNACKBAR_POSITIONS[props.Position]

	self:setState({
		_anchorPoint = RoactAnimate.Value.new(snackbarPosition.AnchorPoint),
		_position = RoactAnimate.Value.new(props.Visible and snackbarPosition.EnterPosition or snackbarPosition.ExitPosition),
		_visible = props.Visible,
		_width = math.max(TextView.getTextBounds(props.Text, "Snackbar").X, MINIMUM_WIDTH) + PADDING*2,
	})
end

function Snackbar:willUpdate(nextProps)
	local _animations = {}
	local _length: number = 0

	local position: string = nextProps.Position
	if position ~= self.props.Position then
		local _ = true
	end

	local visible: boolean = nextProps.Visible
	if visible ~= self.state._visible then
		if visible then
			local _ = table.create(3)
		end
	end
end

function Snackbar:render()
	return Roact.createElement(RoactAnimate.Frame, {
		AnchorPoint = self.state._anchorPoint,
		BackgroundTransparency = 1,
		Position = self.state._position,
		Size = UDim2.fromOffset(self.state._width, HEIGHT),
	}, {
		SnackbarImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxassetid://1934624205",
			ImageColor3 = Color3.fromRGB(50, 50, 50),
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.fromScale(1, 1),
			SliceCenter = Rect.new(4, 4, 252, 252),
			ZIndex = 2,
		}, {
			SnackbarText = Roact.createElement(TextView, {
				AnchorPoint = Vector2.new(0, 0.5),
				Class = "Snackbar",
				Position = UDim2.new(0, 16, 0.5, 0),
				Size = UDim2.new(1, 0, 1, -32),
				Text = self.props.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
		}),

		SnackbarShadow = Roact.createElement(Shadow, {
			Elevation = 6,
		}),
	})
end

return Snackbar