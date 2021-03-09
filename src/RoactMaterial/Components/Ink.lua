local Configuration = require(script.Parent.Parent.Configuration)
local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local RIPPLE_IMAGE = "rbxassetid://1318074921"
local RIPPLE_TWEEN_DATA = {
	EasingStyle = "Deceleration",
	StepType = "Heartbeat",
	Time = 0.2,
}

local RIPPLE_MAX_SIZE = UDim2.fromScale(2, 2)

local Ink = Roact.PureComponent:extend("MaterialInk")
Ink.defaultProps = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	InkColor3 = Color3.new(0.4, 0.4, 0.4),
	InkTransparency = 0.5,
	Origin = UDim2.fromScale(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	ZIndex = 1,
}

function Ink:init()
	self:setState({
		_size = RoactAnimate.Value.new(UDim2.new()),
		_transparency = RoactAnimate.Value.new(1),
	})
end

function Ink:render()
	return Roact.createElement("Frame", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = self.props.Position,
		Size = self.props.Size,
		ZIndex = self.props.ZIndex,

		[Roact.Ref] = function(rbx)
			self._container = rbx
		end,
	}, {
		Rippler = Roact.createElement(RoactAnimate.ImageLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = RIPPLE_IMAGE,
			ImageColor3 = self.props.InkColor3,
			ImageTransparency = self.state._transparency,
			Position = self.props.Origin,
			Size = self.state._size,

			[Roact.Ref] = function(rbx)
				self._rbx = rbx
			end,
		}),
	})
end

function Ink:willUpdate(nextProps)
	local goalSize = RIPPLE_MAX_SIZE
	local goalTransparency = self.props.InkTransparency

	local containerSize = self._container.AbsoluteSize
	if containerSize.X > containerSize.Y then
		self._rbx.SizeConstraint = Enum.SizeConstraint.RelativeXX
	else
		self._rbx.SizeConstraint = Enum.SizeConstraint.RelativeYY
	end

	if nextProps.Rippling then
		self._rbx.Size = UDim2.new()
		self._rbx.Position = nextProps.Origin or UDim2.fromScale(0.5, 0.5)
		self._rbx.ImageTransparency = self.props.InkTransparency
	else
		goalTransparency = 1
	end

	local animation = table.create(2)
	animation[1] = RoactAnimate(self.state._transparency, RIPPLE_TWEEN_DATA, goalTransparency)
	animation[2] = RoactAnimate(self.state._size, RIPPLE_TWEEN_DATA, goalSize)

	RoactAnimate.Parallel(animation):Start()
end

return Ink
