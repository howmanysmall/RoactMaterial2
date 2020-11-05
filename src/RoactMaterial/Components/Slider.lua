local UserInputService = game:GetService("UserInputService")

local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local CAN_ACTIVATE = {
	[Enum.UserInputType.MouseButton1] = true,
	[Enum.UserInputType.MouseButton2] = true,
	[Enum.UserInputType.MouseButton3] = true,
	[Enum.UserInputType.Touch] = true,
	[Enum.UserInputType.Gamepad1] = true,
}

local Slider = Roact.PureComponent:extend("MaterialSlider")
Slider.defaultProps = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	ZIndex = 1,

	Value = 0,
	Min = 0,
	Max = 100,
	IntegerOnly = true,
	ValueLabelMultiply = 1,
	ValueLabel = true,
	Grid = false,
	Disabled = false,
	OnValueChanged = print,
}

function Slider:init(props)
	self.connections = {}

	local currentValue = props.Value or props.Min
	local x = (currentValue - props.Min) / (props.Max - props.Min)
	self:setState({
		backFrameSize = RoactAnimate.Value.new(UDim2.fromScale(x, 1)),
		sliderPosition = RoactAnimate.Value.new(UDim2.fromScale(x, 0.5)),
		sliderSize = RoactAnimate.Value.new(UDim2.fromScale(2, 2)),
		mouseOnSize = RoactAnimate.Value.new(UDim2.new()),
		mouseDownSize = RoactAnimate.Value.new(UDim2.new()),
		valueLabelSize = RoactAnimate.Value.new(UDim2.new()),

		mouseOver = false,
		mouseDown = false,

		currentValue = currentValue,
		textValue = currentValue * props.ValueLabelMultiply,
		gridVisible = props.Grid,
	})

	self.onSliderInputBegan = function(_, inputObject)
		if not self.props.Disabled then
			if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
				self:setState({
					mouseOver = true,
				})
			elseif CAN_ACTIVATE[inputObject.UserInputType] then
				self:setState({
					mouseDown = true,
				})
			end
		end
	end

	self.onSliderInputEnded = function(_, inputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
			self:setState({
				mouseOver = false,
			})
		end
	end

	self.sliderRef = Roact.createRef()
end

function Slider:didMount()
	table.insert(self.connections,
		UserInputService.InputChanged:Connect(function(inputObject)
			if self.state.mouseDown and (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch) then
				local slider = self.sliderRef:getValue()
				if slider then
					local absoluteSizeX = slider.AbsoluteSize.X
					local position = math.clamp(inputObject.Position.X - slider.AbsolutePosition.X, 0, absoluteSizeX)

					local currentValue = (position / absoluteSizeX) * (self.props.Max - self.props.Min)
					currentValue = self.props.IntegerOnly and math.floor(currentValue + 0.5) or currentValue
					currentValue += self.props.Min

					self.props.OnValueChanged(currentValue)

					self:setState({
						currentValue = currentValue,
						textValue = currentValue * self.props.ValueLabelMultiply,
					})
				end
			end
		end)
	)
	table.insert(self.connections,
		UserInputService.InputEnded:Connect(function(inputObject)
			if CAN_ACTIVATE[inputObject.UserInputType] then
				self:setState({
					mouseDown = false,
				})
			end
		end)
	)
end

function Slider:willUnmount()
	for i, connection in ipairs(self.connections) do
		connection:Disconnect()
		self.connections[i] = nil
	end
end

local MOUSE_OVER_TRUE_TWEEN_DATA = {
	Time = 0.12,
	EasingStyle = "Deceleration",
	StepType = "Heartbeat",
}

local MOUSE_OVER_FALSE_TWEEN_DATA = {
	Time = 0.12,
	EasingStyle = "Acceleration",
	StepType = "Heartbeat",
}

local SLIDER_TWEEN_DATA = {
	Time = 0.2,
	EasingStyle = "Standard",
	StepType = "Heartbeat",
}

local VALUE_TWEEN_DATA = {
	Time = 0.025,
	EasingStyle = "Standard",
	StepType = "Heartbeat",
}

function Slider:willUpdate(nextProps, nextState)
	local animations = {}
	local length = 0

	if self.state.mouseOver ~= nextState.mouseOver then
		length = 1
		if nextState.mouseOver then
			local sequence = table.create(2)
			sequence[1] = RoactAnimate.Prepare(self.state.mouseOnSize, UDim2.new())
			sequence[2] = RoactAnimate(self.state.mouseOnSize, MOUSE_OVER_TRUE_TWEEN_DATA, UDim2.fromScale(3, 3))
			animations[length] = RoactAnimate.Sequence(sequence)
		else
			local sequence = table.create(2)
			sequence[1] = RoactAnimate.Prepare(self.state.mouseOnSize, UDim2.fromScale(3, 3))
			sequence[2] = RoactAnimate(self.state.mouseOnSize, MOUSE_OVER_FALSE_TWEEN_DATA, UDim2.new())
			animations[length] = RoactAnimate.Sequence(sequence)
		end
	end

	if self.state.mouseDown ~= nextState.mouseDown then
		length += 1
		if nextState.mouseDown then
			if nextProps.ValueLabel then
				local sequence = table.create(6)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromScale(2, 2))
				sequence[3] = RoactAnimate.Prepare(self.state.valueLabelSize, UDim2.new())
				sequence[4] = RoactAnimate(self.state.mouseDownSize, MOUSE_OVER_TRUE_TWEEN_DATA, UDim2.fromScale(3, 3))
				sequence[5] = RoactAnimate(self.state.sliderSize, SLIDER_TWEEN_DATA, UDim2.fromScale(2.25, 2.25))
				sequence[6] = RoactAnimate(self.state.valueLabelSize, MOUSE_OVER_TRUE_TWEEN_DATA, UDim2.fromOffset(35, 50))
				animations[length] = RoactAnimate.Parallel(sequence)
			else
				local sequence = table.create(4)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromScale(2, 2))
				sequence[3] = RoactAnimate(self.state.mouseDownSize, MOUSE_OVER_TRUE_TWEEN_DATA, UDim2.fromScale(3, 3))
				sequence[4] = RoactAnimate(self.state.sliderSize, SLIDER_TWEEN_DATA, UDim2.fromScale(2.25, 2.25))
				animations[length] = RoactAnimate.Parallel(sequence)
			end
		else
			if nextProps.ValueLabel then
				local sequence = table.create(6)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromScale(2, 2))
				sequence[3] = RoactAnimate.Prepare(self.state.valueLabelSize, UDim2.fromOffset(35, 50))
				sequence[4] = RoactAnimate(self.state.mouseDownSize, MOUSE_OVER_FALSE_TWEEN_DATA, UDim2.fromScale(3, 3))
				sequence[5] = RoactAnimate(self.state.sliderSize, SLIDER_TWEEN_DATA, UDim2.fromScale(2.25, 2.25))
				sequence[6] = RoactAnimate(self.state.valueLabelSize, MOUSE_OVER_FALSE_TWEEN_DATA, UDim2.new())
				animations[length] = RoactAnimate.Parallel(sequence)
			else
				local sequence = table.create(4)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.fromScale(3, 3))
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromScale(2.25, 2.25))
				sequence[3] = RoactAnimate(self.state.mouseDownSize, MOUSE_OVER_FALSE_TWEEN_DATA, UDim2.new())
				sequence[4] = RoactAnimate(self.state.sliderSize, SLIDER_TWEEN_DATA, UDim2.fromScale(2, 2))
				animations[length] = RoactAnimate.Parallel(sequence)
			end
		end
	end

	if self.state.currentValue ~= nextState.currentValue then
		length += 1
		local currentValue = nextState.currentValue

		local x = (currentValue - nextProps.Min) / (nextProps.Max - nextProps.Min)

		local sequence = table.create(2)
		sequence[1] = RoactAnimate(self.state.backFrameSize, VALUE_TWEEN_DATA, UDim2.fromScale(x, 1))
		sequence[2] = RoactAnimate(self.state.sliderPosition, VALUE_TWEEN_DATA, UDim2.fromScale(x, 0.5))
		animations[length] = RoactAnimate.Parallel(sequence)
	end

	RoactAnimate.Parallel(animations):Start()
end

function Slider:render()
	return Roact.createElement("Frame", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundColor3 = ThemeAccessor.Get(self, "SliderSecondaryColor3"),
		BorderSizePixel = 0,
		Position = self.props.Position,
		Size = self.props.Size,
		ZIndex = self.props.ZIndex,
		LayoutOrder = self.props.LayoutOrder,
		[Roact.Ref] = self.sliderRef,
	}, {
		MouseButton = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 1, 10),

			[Roact.Event.InputBegan] = self.onSliderInputBegan,
			[Roact.Event.InputEnded] = self.onSliderInputEnded,
		}),

		BackFrame = Roact.createElement(RoactAnimate.Frame, {
			BackgroundColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			Size = self.state.backFrameSize,
			BorderSizePixel = 0,
		}),

		DisabledFrame = Roact.createElement("Frame", {
			BackgroundColor3 = ThemeAccessor.Get(self, "SliderSecondaryColor3"),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Visible = self.props.Disabled,
			ZIndex = self.props.ZIndex + 1,
		}),

		SliderPoint = Roact.createElement(RoactAnimate.ImageLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = self.state.sliderPosition,
			Size = self.state.sliderSize,
			SizeConstraint = Enum.SizeConstraint.RelativeYY,
			ZIndex = self.props.ZIndex + 3,
			Image = "rbxassetid://1217158727",
			ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),

			[Roact.Event.InputBegan] = function(...)
				self.onSliderInputBegan(...)
			end,

			[Roact.Event.InputEnded] = function(...)
				self.onSliderInputEnded(...)
			end
		}, {
			MouseOnRipple = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = self.state.mouseOnSize,
				Image = "rbxassetid://1217158727",
				ImageTransparency = 0.85,
				ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			}),

			mouseDownRipple = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = self.state.mouseDownSize,
				Image = "rbxassetid://1217158727",
				ImageTransparency = 0.85,
				ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			}),

			EventHandler = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
			}),

			ValueLabel = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 2),
				Size = self.state.valueLabelSize,
				ZIndex = 100,
				ClipsDescendants = true,
				Image = "rbxassetid://4638062084",
				ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			}, {
				ValueText = Roact.createElement("TextLabel", {
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0),
					Size = UDim2.fromScale(0.8, 0.6),
					Font = Enum.Font.SourceSans,
					TextColor3 = ThemeAccessor.Get(self, "SliderValueColor3"),
					Text = self.state.textValue,
					TextSize = 18,
				}),
			}),
		}),
	})
end

return Slider
