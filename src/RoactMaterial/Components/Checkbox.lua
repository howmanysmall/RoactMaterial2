local Configuration = require(script.Parent.Parent.Configuration)
local Icon = require(script.Parent.Icon)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local RIPPLE_IMAGE = "rbxassetid://1318074921"
local UNCHECKED_ICON = "check_box_outline_blank"
local CHECKED_ICON = "check_box"

local EMPTY_UDIM2 = UDim2.new()
local RIPPLE_SIZE = UDim2.fromScale(1.75, 1.75)
local FULL_UDIM2 = UDim2.fromScale(1, 1)
local CHECK_SIZE = UDim2.fromOffset(24, 24)
local CENTER_UDIM2 = UDim2.fromScale(0.5, 0.5)
local CENTER_VECTOR2 = Vector2.new(0.5, 0.5)

local TWEEN_DATA_1 = {
	Time = 0.15,
	EasingStyle = "Standard",
	StepType = "Heartbeat",
}

local TWEEN_DATA_2 = {
	Time = 0.225,
	EasingStyle = "Standard",
	StepType = "Heartbeat",
}

local Checkbox = Roact.PureComponent:extend("MaterialCheckbox")
Checkbox.defaultProps = {
	Checked = false,
	OnChecked = print,
	Position = EMPTY_UDIM2,
	ZIndex = 1,
}

function Checkbox:init(props)
	self:setState({
		_fillTransparency = RoactAnimate.Value.new(props.Checked and 0 or 1),
		_rippleSize = RoactAnimate.Value.new(EMPTY_UDIM2),
		_rippleTransparency = RoactAnimate.Value.new(0.6),
	})
end

function Checkbox:willUpdate(nextProps)
	local newTransparency = 1
	local animations = {}

	if nextProps.Checked then
		newTransparency = 0

		if not self.props.Checked then
			local sequence = table.create(4)
			sequence[1] = RoactAnimate.Prepare(self.state._rippleSize, EMPTY_UDIM2)
			sequence[2] = RoactAnimate.Prepare(self.state._rippleTransparency, 0.6)
			sequence[3] = RoactAnimate(self.state._rippleSize, TWEEN_DATA_1, RIPPLE_SIZE)
			sequence[4] = RoactAnimate(self.state._rippleTransparency, TWEEN_DATA_1, 1)

			table.insert(animations, RoactAnimate.Sequence(sequence))
		end
	end

	table.insert(animations, RoactAnimate(self.state._fillTransparency, TWEEN_DATA_2, newTransparency))
	RoactAnimate.Parallel(animations):Start()
end

function Checkbox:render()
	local outlineColor = ThemeAccessor.Get(self, "CheckOutlineColor")

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = CHECK_SIZE,
		Position = self.props.Position,
		ZIndex = self.props.ZIndex,
	}, {
		InputHandler = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Size = FULL_UDIM2,
			Text = "",

			[Roact.Event.Activated] = function()
				self.props.OnChecked(not self.props.Checked)
			end,
		}, {
			UncheckedIcon = Roact.createElement(Icon, {
				Size = FULL_UDIM2,
				Resolution = 48,
				Icon = UNCHECKED_ICON,
				IconColor3 = outlineColor.Color,
				IconTransparency = outlineColor.Transparency,
			}),

			CheckedIcon = Roact.createElement(Icon, {
				Icon = CHECKED_ICON,
				IconColor3 = ThemeAccessor.Get(self, "PrimaryColor"),
				IconTransparency = self.state._fillTransparency,
				Resolution = 48,
				Size = FULL_UDIM2,
				ZIndex = 2,
			}),
		}),

		Ripple = Roact.createElement(RoactAnimate.ImageLabel, {
			AnchorPoint = CENTER_VECTOR2,
			Position = CENTER_UDIM2,
			BackgroundTransparency = 1,
			Image = RIPPLE_IMAGE,
			ImageColor3 = ThemeAccessor.Get(self, "PrimaryColor"),
			ImageTransparency = self.state._rippleTransparency,
			Size = self.state._rippleSize,
			ZIndex = 1,
		}),
	})
end

return Checkbox
