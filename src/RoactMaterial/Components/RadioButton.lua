local Configuration = require(script.Parent.Parent.Configuration)
local Icon = require(script.Parent.Icon)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local RIPPLE_IMAGE = "rbxassetid://1318074921"
local UNCHECKED_ICON = "radio_button_unchecked"
local CHECKED_ICON = "radio_button_checked"

local RadioButton = Roact.PureComponent:extend("MaterialRadioButton")

function RadioButton:init(props)
	local outlineColor = ThemeAccessor.Get(self, "CheckOutlineColor")

	self:setState({
		_fillTransparency = RoactAnimate.Value.new(props.Checked and 0 or 1),
		_outlineTransparency = RoactAnimate.Value.new(props.Checked and 1 or outlineColor.Transparency),
		_rippleSize = RoactAnimate.Value.new(UDim2.new()),
		_rippleTransparency = RoactAnimate.Value.new(0.6),
	})
end

local TRANSPARENCY_TWEEN_DATA = {
	Time = 0.225,
	EasingStyle = "Standard",
	StepType = "Heartbeat",
}

local RIPPLE_TWEEN_DATA = {
	Time = 0.15,
	EasingStyle = "Deceleration",
	StepType = "Heartbeat",
}

function RadioButton:willUpdate(nextProps)
	local outlineColor = ThemeAccessor.Get(self, "CheckOutlineColor")
	local newTransparency = 1
	local newOutlineTransparency = outlineColor.Transparency

	if nextProps.Checked then
		newTransparency = 0
		newOutlineTransparency = 1
	end

	local animations = {
		RoactAnimate(self.state._fillTransparency, TRANSPARENCY_TWEEN_DATA, newTransparency),
		RoactAnimate(self.state._outlineTransparency, TRANSPARENCY_TWEEN_DATA, newOutlineTransparency),
	}

	if nextProps.Checked ~= self.props.Checked and nextProps.Checked then
		local sequence = table.create(4)
		sequence[1] = RoactAnimate.Prepare(self.state._rippleSize, UDim2.new())
		sequence[2] = RoactAnimate.Prepare(self.state._rippleTransparency, 0.6)
		sequence[3] = RoactAnimate(self.state._rippleSize, RIPPLE_TWEEN_DATA, UDim2.fromScale(1.75, 1.75))
		sequence[4] = RoactAnimate(self.state._rippleTransparency, RIPPLE_TWEEN_DATA, 1)

		table.insert(animations, RoactAnimate.Sequence(sequence))
	end

	RoactAnimate.Parallel(animations):Start()
end

function RadioButton:render()
	local outlineColor = ThemeAccessor.Get(self, "CheckOutlineColor")

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(24, 24),
		Position = self.props.Position,
		ZIndex = self.props.ZIndex,
	}, {
		InputHandler = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = UDim2.fromScale(1, 1),
			Text = "",
			[Roact.Event.Activated] = self.props.OnClicked,
		}, {
			UncheckedIcon = Roact.createElement(Icon, {
				Size = UDim2.fromScale(1, 1),
				Resolution = 48,
				Icon = UNCHECKED_ICON,
				IconColor3 = outlineColor.Color,
				IconTransparency = self.state._outlineTransparency,
			}),

			CheckedIcon = Roact.createElement(Icon, {
				BackgroundTransparency = 1,
				Icon = CHECKED_ICON,
				IconColor3 = ThemeAccessor.Get(self, "PrimaryColor"),
				IconTransparency = self.state._fillTransparency,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}),
		}),

		Ripple = Roact.createElement(RoactAnimate.ImageLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = RIPPLE_IMAGE,
			ImageColor3 = ThemeAccessor.Get(self, "PrimaryColor"),
			ImageTransparency = self.state._rippleTransparency,
			Size = self.state._rippleSize,
			ZIndex = 1,
		}),
	})
end

return RadioButton
