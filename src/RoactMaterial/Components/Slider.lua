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
	Max = 100,
	IntegerOnly = true,
	ValueLabelMultiply = 1,
	ValueLabel = true,
	Grid = false,
	Disabled = false,
	OnValueChanged = print,
}

function Slider:init(props)
	self:setState({
		backFrameSize = RoactAnimate.Value.new(UDim2.fromScale(0, 1)),
		sliderPosition = RoactAnimate.Value.new(UDim2.fromScale(0, 0.5)),
		sliderSize = RoactAnimate.Value.new(UDim2.fromOffset(12, 12)),
		mouseOnSize = RoactAnimate.Value.new(UDim2.new()),
		mouseDownSize = RoactAnimate.Value.new(UDim2.new()),
		valueLabelSize = RoactAnimate.Value.new(UDim2.new()),

		mouseOver = false,
		mouseDown = false,

		currentValue = props.Value,
		gridVisible = props.Grid,
	})

	self.sliderRef = Roact.createRef()
end

-- function Slider:willUpdate(NextProps, NextState)
-- 	local animations = {}
-- 	local length = 0

-- 	if self.state.mouseOver ~= NextState.mouseOver then
-- 		length = 1
-- 		if NextState.mouseOver then
-- 			local Sequence = table.create(2)
-- 			Sequence[1] = RoactAnimate.Prepare(self.state.mouseOnSize, UDim2.new())
-- 			Sequence[2] = RoactAnimate(self.state.mouseOnSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
-- 			animations[length] = RoactAnimate.Sequence(Sequence)
-- 		else
-- 			local Sequence = table.create(2)
-- 			Sequence[1] = RoactAnimate.Prepare(self.state.mouseOnSize, UDim2.fromScale(3, 3))
-- 			Sequence[2] = RoactAnimate(self.state.mouseOnSize, TweenInfo.new(0.12), UDim2.new())
-- 			animations[length] = RoactAnimate.Sequence(Sequence)
-- 		end
-- 	end

-- 	if self.state.mouseDown ~= NextState.mouseDown then
-- 		length += 1
-- 		if NextState.mouseDown then
-- 			if NextProps.ValueLabel then
-- 				local Sequence = table.create(6)
-- 				Sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
-- 				Sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(12, 12))
-- 				Sequence[3] = RoactAnimate.Prepare(self.state.valueLabelSize, UDim2.new())
-- 				Sequence[4] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
-- 				Sequence[5] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
-- 				Sequence[6] = RoactAnimate(self.state.valueLabelSize, TweenInfo.new(0.12), UDim2.fromOffset(28, 40))
-- 				animations[length] = RoactAnimate.Parallel(Sequence)
-- 			else
-- 				local Sequence = table.create(4)
-- 				Sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
-- 				Sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(12, 12))
-- 				Sequence[3] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
-- 				Sequence[4] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
-- 				animations[Length] = RoactAnimate.Parallel(Sequence)
-- 			end
-- 		else
-- 			if NextProps.ValueLabel then
-- 				local Sequence = table.create(6)
-- 				Sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
-- 				Sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(12, 12))
-- 				Sequence[3] = RoactAnimate.Prepare(self.state.valueLabelSize, UDim2.fromOffset(28, 40))
-- 				Sequence[4] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
-- 				Sequence[5] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
-- 				Sequence[6] = RoactAnimate(self.state.valueLabelSize, TweenInfo.new(0.12), UDim2.new())
-- 				animations[length] = RoactAnimate.Parallel(Sequence)
-- 			else
-- 				local Sequence = table.create(4)
-- 				Sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.fromScale(3, 3))
-- 				Sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(14, 14))
-- 				Sequence[3] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.new())
-- 				Sequence[4] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(12, 12))
-- 				animations[length] = RoactAnimate.Parallel(Sequence)
-- 			end
-- 		end
-- 	end

-- 	if self.state.currentValue ~= NextState.currentValue then
-- 		length += 1
-- 		local currentValue = NextState.currentValue

-- 		local Sequence = table.create(2)
-- 		Sequence[1] = RoactAnimate(self.state.backFrameSize, TweenInfo.new(0.1, Enum.EasingStyle.Quad), UDim2.fromScale(currentValue / NextProps.Max, 1))
-- 		Sequence[2] = RoactAnimate(self.state.sliderPosition, TweenInfo.new(0.1, Enum.EasingStyle.Quad), UDim2.fromScale(currentValue / NextProps.Max, 0.5))
-- 		animations[length] = RoactAnimate.Parallel(Sequence)
-- 	end

-- 	RoactAnimate.Parallel(animations):Start()
-- end

function Slider:willUpdate(nextProps, nextState)
	local animations = {}
	local length = 0

	if self.state.mouseOver ~= nextState.mouseOver then
		length = 1
		if nextState.mouseOver then
			local sequence = table.create(2)
			sequence[1] = RoactAnimate.Prepare(self.state.mouseOnSize, UDim2.new())
			sequence[2] = RoactAnimate(self.state.mouseOnSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
			animations[length] = RoactAnimate.Sequence(sequence)
		else
			local sequence = table.create(2)
			sequence[1] = RoactAnimate.Prepare(self.state.mouseOnSize, UDim2.fromScale(3, 3))
			sequence[2] = RoactAnimate(self.state.mouseOnSize, TweenInfo.new(0.12), UDim2.new())
			animations[length] = RoactAnimate.Sequence(sequence)
		end
	end

	if self.state.mouseDown ~= nextState.mouseDown then
		length += 1
		if nextState.mouseDown then
			if nextProps.valueLabel then
				local sequence = table.create(6)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(12, 12))
				sequence[3] = RoactAnimate.Prepare(self.state.valueLabelSize, UDim2.new())
				sequence[4] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
				sequence[5] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
				sequence[6] = RoactAnimate(self.state.valueLabelSize, TweenInfo.new(0.12), UDim2.fromOffset(28, 40))
				animations[length] = RoactAnimate.Parallel(sequence)
			else
				local sequence = table.create(4)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(12, 12))
				sequence[3] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
				sequence[4] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
				animations[length] = RoactAnimate.Parallel(sequence)
			end
		else
			if nextProps.valueLabel then
				local sequence = table.create(6)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.new())
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(12, 12))
				sequence[3] = RoactAnimate.Prepare(self.state.valueLabelSize, UDim2.fromOffset(28, 40))
				sequence[4] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
				sequence[5] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
				sequence[6] = RoactAnimate(self.state.valueLabelSize, TweenInfo.new(0.12), UDim2.new())
				animations[length] = RoactAnimate.Parallel(sequence)
			else
				local sequence = table.create(4)
				sequence[1] = RoactAnimate.Prepare(self.state.mouseDownSize, UDim2.fromScale(3, 3))
				sequence[2] = RoactAnimate.Prepare(self.state.sliderSize, UDim2.fromOffset(14, 14))
				sequence[3] = RoactAnimate(self.state.mouseDownSize, TweenInfo.new(0.12), UDim2.new())
				sequence[4] = RoactAnimate(self.state.sliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(12, 12))
				animations[length] = RoactAnimate.Parallel(sequence)
			end
		end
	end

	if self.state.currentValue ~= nextState.currentValue then
		length += 1
		local currentValue = nextState.currentValue

		local sequence = table.create(2)
		sequence[1] = RoactAnimate(self.state.backFrameSize, TweenInfo.new(0.1, Enum.EasingStyle.Quad), UDim2.fromScale(currentValue / nextProps.Max, 1))
		sequence[2] = RoactAnimate(self.state.sliderPosition, TweenInfo.new(0.1, Enum.EasingStyle.Quad), UDim2.fromScale(currentValue / nextProps.Max, 0.5))
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
		Size = UDim2.fromOffset(160, 2),
		ZIndex = self.props.ZIndex,
		[Roact.Ref] = self.sliderRef,
	}, {
		MouseButton = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 1, 10),
			[Roact.Event.InputBegan] = function(_, inputObject)
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
			end,

			[Roact.Event.InputChanged] = function(_, inputObject)
				if self.state.mouseDown and (inputObject.UserInputType == Enum.UserInputType.MouseMovement or inputObject.UserInputType == Enum.UserInputType.Touch) then
					local slider = self.sliderRef:getValue()
					if slider then
						local absoluteSizeX = slider.AbsoluteSize.X
						local position = math.clamp(inputObject.Position.X - slider.AbsolutePosition.X, 0, absoluteSizeX)
						local currentValue = self.props.IntegerOnly and math.floor((position / absoluteSizeX) * self.props.Max + 0.5) or (position / absoluteSizeX) * self.props.Max
						self.props.OnValueChanged(currentValue)

						self:setState({
							currentValue = currentValue,
							textValue = currentValue * self.props.ValueLabelMultiply,
						})
					end
				end
			end,

			[Roact.Event.InputEnded] = function(_, inputObject)
				if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
					self:setState({
						mouseOver = false,
					})
				elseif CAN_ACTIVATE[inputObject.UserInputType] then
					self:setState({
						mouseDown = false,
					})
				end
			end,
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
			ZIndex = self.props.ZIndex + 3,
			Image = "rbxassetid://1217158727",
			ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
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
					Size = UDim2.new(0.8, 0, 0, 28),
					Font = Enum.Font.SourceSans,
					TextColor3 = ThemeAccessor.Get(self, "SliderValueColor3"),
					Text = self.state.textValue,
					TextSize = 14,
				}),
			}),
		}),
	})
end

return Slider