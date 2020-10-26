local UserInputService = game:GetService("UserInputService")

local Configuration = require(script.Parent.Parent.Configuration)
local Ink = require(script.Parent.Ink)
local Shadow = require(script.Parent.Shadow)
local TextView = require(script.Parent.TextView)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate
local t = Configuration.t

local RIPPLE_TRIGGER_INPUT_TYPES = {
	Enum.UserInputType.MouseButton1,
	Enum.UserInputType.MouseButton2,
	Enum.UserInputType.MouseButton3,
	Enum.UserInputType.Touch,
}

local COLOR_TWEEN_DATA = {
	Time = 0.15,
	EasingStyle = "Standard",
	StepType = "Heartbeat",
}

local Button = Roact.PureComponent:extend("MaterialButton")
Button.defaultProps = {
	Position = UDim2.new(),
	AnchorPoint = Vector2.new(),
	Size = UDim2.fromOffset(100, 40),
	ZIndex = 1,
	Text = "",
}

Button.validateProps = t.interface({
	AnchorPoint = t.optional(t.Vector2),
	Position = t.optional(t.UDim2),
	Size = t.optional(t.UDim2),
	ZIndex = t.optional(t.integer),
	LayoutOrder = t.optional(t.integer),
	Text = t.optional(t.string),

	BackgroundColor3 = t.optional(t.Color3),
	PressColor3 = t.optional(t.Color3),
	HoverColor3 = t.optional(t.Color3),
	InkColor3 = t.optional(t.Color3),
	Flat = t.optional(t.boolean),
	OnClicked = t.optional(t.callback),
})

local WHITE_COLOR3 = Color3.new(1, 1, 1)
local FULL_UDIM2 = UDim2.fromScale(1, 1)

function Button:init(props)
	self:setState({
		_pressed = false,
		_pressPoint = UDim2.new(),
		Elevation = 2,
		_mouseOver = false,
		_bgColor = RoactAnimate.Value.new(props.BackgroundColor3 or (props.Flat and ThemeAccessor.Get(self, "FlatButtonColor", WHITE_COLOR3) or ThemeAccessor.Get(self, "ButtonColor", WHITE_COLOR3))),
	})
end

function Button:willUpdate(_, nextState)
	local goalColor

	if nextState._pressed then
		goalColor = self.props.PressColor3 or ThemeAccessor.Get(self, self.props.Flat and "FlatButtonPressColor" or "ButtonPressColor", Color3.new(0.9, 0.9, 0.9))
	elseif nextState._mouseOver then
		goalColor = self.props.HoverColor3 or ThemeAccessor.Get(self, self.props.Flat and "FlatButtonHoverColor" or "ButtonHoverColor", WHITE_COLOR3)
	else
		goalColor = self.props.BackgroundColor3 or ThemeAccessor.Get(self, self.props.Flat and "FlatButtonColor" or "ButtonColor", WHITE_COLOR3)
	end

	RoactAnimate(self.state._bgColor, COLOR_TWEEN_DATA, goalColor):Start()
end

local function _scheduleHitTest(self, rbx)
	local timestamp = os.clock()
	self._lastHitTest = timestamp

	coroutine.wrap(function()
		if self._lastHitTest == timestamp then
			local absolutePosition = rbx.AbsolutePosition
			local absoluteSize = rbx.AbsoluteSize
			local mousePosition = UserInputService:GetMouseLocation()
			local bottomRight = absolutePosition + absoluteSize

			if mousePosition.X < absolutePosition.X or mousePosition.Y < absolutePosition.Y or mousePosition.X > bottomRight.X or mousePosition.Y > bottomRight.Y then
				self:setState({
					_pressed = false,
					_mouseOver = false,
				})
			end
		end
	end)()
end

function Button:render()
	local flat = self.props.Flat
	local elevation = flat and 0 or self.state.Elevation

	local function hitTester(rbx)
		_scheduleHitTest(self, rbx)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,
		Size = self.props.Size,
		ZIndex = self.props.ZIndex,
		LayoutOrder = self.props.LayoutOrder,

		[Roact.Change.AbsolutePosition] = hitTester,
		[Roact.Change.AbsoluteSize] = hitTester,
	}, {
		TextButton = Roact.createElement(RoactAnimate.TextButton, {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			BackgroundColor3 = self.state._bgColor,
			Size = FULL_UDIM2,
			Text = "",
			ZIndex = 2,

			[Roact.Event.Activated] = self.props.OnClicked,
			[Roact.Ref] = function(rbx)
				self._rbx = rbx
			end,

			[Roact.Event.InputBegan] = function(rbx, input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					self:setState({
						Elevation = 4,
						_mouseOver = true,
					})
				else
					for _, allowed in ipairs(RIPPLE_TRIGGER_INPUT_TYPES) do
						if input.UserInputType == allowed then
							local relativeX = (input.Position.X - rbx.AbsolutePosition.X) / rbx.AbsoluteSize.X
							local relativeY = (input.Position.Y - rbx.AbsolutePosition.Y) / rbx.AbsoluteSize.Y

							self:setState({
								_pressPoint = UDim2.fromScale(relativeX, relativeY),
								_pressed = true,
							})

							break
						end
					end
				end
			end,

			[Roact.Event.InputEnded] = function(_, input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					self:setState({
						Elevation = 2,
						_mouseOver = false,
					})
				else
					for _, allowed in ipairs(RIPPLE_TRIGGER_INPUT_TYPES) do
						if input.UserInputType == allowed then
							self:setState({
								_pressed = false,
							})

							break
						end
					end
				end
			end,
		}, self.props[Roact.Children]),

		Children = Roact.createElement("Frame", {
			Size = FULL_UDIM2,
			BackgroundTransparency = 1,
			ZIndex = 4,
		}, self.props[Roact.Children]),

		Ink = Roact.createElement(Ink, {
			ZIndex = 3,
			Rippling = self.state._pressed,
			Origin = self.state._pressPoint,
			InkColor3 = self.props.InkColor3 or (self.props.Flat and ThemeAccessor.Get(self, "PrimaryColor") or WHITE_COLOR3),
			InkTransparency = 0.5,
		}),

		Shadow = Roact.createElement(Shadow, {
			Elevation = elevation,
			ZIndex = 1,
		}),

		TextLabel = Roact.createElement(TextView, {
			Class = "Button",
			Size = FULL_UDIM2,
			Text = string.upper(self.props.Text),
			ZIndex = 4,
		}),
	})
end

return Button
