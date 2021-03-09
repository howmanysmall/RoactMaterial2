local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local CIRCLE_IMAGE = "rbxassetid://1318074921"
local TOGGLE_SHADOW_IMAGE = "rbxassetid://1332905573"

local Switch = Roact.PureComponent:extend("MaterialSwitch")
Switch.defaultProps = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Checked = false,
	OnChecked = print,
	Position = UDim2.fromScale(0.5, 0.5),
	ZIndex = 1,
}

function Switch:init(props)
	self:setState({
		_rippleColor = RoactAnimate.Value.new(Color3.new()),
		_rippleSize = RoactAnimate.Value.new(UDim2.new()),
		_rippleTransparency = RoactAnimate.Value.new(0.6),
		_toggleColor = RoactAnimate.Value.new(ThemeAccessor.Get(self, props.Checked and "SwitchToggleOnColor" or "SwitchToggleOffColor")),
		_togglePosition = RoactAnimate.Value.new(props.Checked and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)),
		_trackColor = RoactAnimate.Value.new(ThemeAccessor.Get(self, props.Checked and "SwitchTrackOnColor" or "SwitchTrackOffColor")),
	})
end

local SIZE_TWEEN_DATA = {
	EasingStyle = "Deceleration",
	StepType = "Heartbeat",
	Time = 0.15,
}

local SWITCH_TWEEN_DATA = {
	EasingStyle = "Deceleration",
	StepType = "Heartbeat",
	Time = 0.225,
}

function Switch:willUpdate(nextProps)
	if self.props.Checked ~= nextProps.Checked then
		local newTogglePosition = nextProps.Checked and UDim2.new(1, -10, 0.5, 0) or UDim2.new(0, 10, 0.5, 0)
		local newToggleColor = ThemeAccessor.Get(self, nextProps.Checked and "SwitchToggleOnColor" or "SwitchToggleOffColor")
		local newTrackColor = ThemeAccessor.Get(self, nextProps.Checked and "SwitchTrackOnColor" or "SwitchTrackOffColor")
		local newRippleColor = ThemeAccessor.Get(self, nextProps.Checked and "SwitchRippleOnColor" or "SwitchRippleOffColor")

		local sequence = table.create(5)
		sequence[1] = RoactAnimate.Prepare(self.state._rippleSize, UDim2.new())
		sequence[2] = RoactAnimate.Prepare(self.state._rippleTransparency, 0.6)
		sequence[3] = RoactAnimate.Prepare(self.state._rippleColor, newRippleColor)
		sequence[4] = RoactAnimate(self.state._rippleSize, SIZE_TWEEN_DATA, UDim2.fromScale(1.75, 1.75))
		sequence[5] = RoactAnimate(self.state._rippleTransparency, SIZE_TWEEN_DATA, 1)

		local animation = table.create(4)
		animation[1] = RoactAnimate(self.state._togglePosition, SWITCH_TWEEN_DATA, newTogglePosition)
		animation[2] = RoactAnimate(self.state._toggleColor, SWITCH_TWEEN_DATA, newToggleColor)
		animation[3] = RoactAnimate(self.state._trackColor, SWITCH_TWEEN_DATA, newTrackColor)
		animation[4] = RoactAnimate.Sequence(sequence)

		RoactAnimate.Parallel(animation):Start()
	end
end

function Switch:render()
	return Roact.createElement("TextButton", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		Position = self.props.Position,
		Size = UDim2.fromOffset(36, 20),
		Text = "",
		ZIndex = self.props.ZIndex,

		[Roact.Event.Activated] = function()
			self.props.OnChecked(not self.props.Checked)
		end,
	}, {
		Track = Roact.createElement(RoactAnimate.ImageLabel, {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = CIRCLE_IMAGE,
			ImageColor3 = self.state._trackColor,
			Position = UDim2.fromScale(0, 0.5),
			ScaleType = Enum.ScaleType.Slice,
			Size = UDim2.new(1, 0, 0, 12),
			SliceCenter = Rect.new(128, 128, 128, 128),
		}),

		SwitchToggle = Roact.createElement(RoactAnimate.ImageLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = TOGGLE_SHADOW_IMAGE,
			ImageTransparency = 0.8,
			Position = self.state._togglePosition,
			Size = UDim2.fromOffset(24, 24),
			ZIndex = 2,
		}, {
			Toggle = Roact.createElement(RoactAnimate.ImageLabel, {
				BackgroundTransparency = 1,
				Image = CIRCLE_IMAGE,
				ImageColor3 = self.state._toggleColor,
				Position = UDim2.fromOffset(2, 1),
				Size = UDim2.fromOffset(20, 20),
				ZIndex = 2,
			}),

			Ripple = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = CIRCLE_IMAGE,
				ImageColor3 = self.state._rippleColor,
				ImageTransparency = self.state._rippleTransparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = self.state._rippleSize,
				ZIndex = 1,
			}),
		}),
	})
end

return Switch
