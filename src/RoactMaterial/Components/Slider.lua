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
		BackFrameSize = RoactAnimate.Value.new(UDim2.fromScale(0, 1)),
		SliderPosition = RoactAnimate.Value.new(UDim2.fromScale(0, 0.5)),
		SliderSize = RoactAnimate.Value.new(UDim2.fromOffset(12, 12)),
		MouseOnSize = RoactAnimate.Value.new(UDim2.new()),
		MouseDownSize = RoactAnimate.Value.new(UDim2.new()),
		ValueLabelSize = RoactAnimate.Value.new(UDim2.new()),

		MouseOver = false,
		MouseDown = false,

		CurrentValue = props.Value,
		GridVisible = props.Grid,
	})

	self.SliderRef = Roact.createRef()
end

function Slider:willUpdate(NextProps, NextState)
	local Animations = {}
	local Length = 0

	if self.state.MouseOver ~= NextState.MouseOver then
		Length = 1
		if NextState.MouseOver then
			local Sequence = table.create(2)
			Sequence[1] = RoactAnimate.Prepare(self.state.MouseOnSize, UDim2.new())
			Sequence[2] = RoactAnimate(self.state.MouseOnSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
			Animations[Length] = RoactAnimate.Sequence(Sequence)
		else
			local Sequence = table.create(2)
			Sequence[1] = RoactAnimate.Prepare(self.state.MouseOnSize, UDim2.fromScale(3, 3))
			Sequence[2] = RoactAnimate(self.state.MouseOnSize, TweenInfo.new(0.12), UDim2.new())
			Animations[Length] = RoactAnimate.Sequence(Sequence)
		end
	end

	if self.state.MouseDown ~= NextState.MouseDown then
		Length += 1
		if NextState.MouseDown then
			if NextProps.ValueLabel then
				local Sequence = table.create(6)
				Sequence[1] = RoactAnimate.Prepare(self.state.MouseDownSize, UDim2.new())
				Sequence[2] = RoactAnimate.Prepare(self.state.SliderSize, UDim2.fromOffset(12, 12))
				Sequence[3] = RoactAnimate.Prepare(self.state.ValueLabelSize, UDim2.new())
				Sequence[4] = RoactAnimate(self.state.MouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
				Sequence[5] = RoactAnimate(self.state.SliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
				Sequence[6] = RoactAnimate(self.state.ValueLabelSize, TweenInfo.new(0.12), UDim2.fromOffset(28, 40))
				Animations[Length] = RoactAnimate.Parallel(Sequence)
			else
				local Sequence = table.create(4)
				Sequence[1] = RoactAnimate.Prepare(self.state.MouseDownSize, UDim2.new())
				Sequence[2] = RoactAnimate.Prepare(self.state.SliderSize, UDim2.fromOffset(12, 12))
				Sequence[3] = RoactAnimate(self.state.MouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
				Sequence[4] = RoactAnimate(self.state.SliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
				Animations[Length] = RoactAnimate.Parallel(Sequence)
			end
		else
			if NextProps.ValueLabel then
				Animations[Length] = RoactAnimate.Parallel({
					RoactAnimate.Sequence
				})
				local Sequence = table.create(6)
				Sequence[1] = RoactAnimate.Prepare(self.state.MouseDownSize, UDim2.new())
				Sequence[2] = RoactAnimate.Prepare(self.state.SliderSize, UDim2.fromOffset(12, 12))
				Sequence[3] = RoactAnimate.Prepare(self.state.ValueLabelSize, UDim2.fromOffset(28, 40))
				Sequence[4] = RoactAnimate(self.state.MouseDownSize, TweenInfo.new(0.12), UDim2.fromScale(3, 3))
				Sequence[5] = RoactAnimate(self.state.SliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(14, 14))
				Sequence[6] = RoactAnimate(self.state.ValueLabelSize, TweenInfo.new(0.12), UDim2.new())
				Animations[Length] = RoactAnimate.Parallel(Sequence)
			else
				local Sequence = table.create(4)
				Sequence[1] = RoactAnimate.Prepare(self.state.MouseDownSize, UDim2.fromScale(3, 3))
				Sequence[2] = RoactAnimate.Prepare(self.state.SliderSize, UDim2.fromOffset(14, 14))
				Sequence[3] = RoactAnimate(self.state.MouseDownSize, TweenInfo.new(0.12), UDim2.new())
				Sequence[4] = RoactAnimate(self.state.SliderSize, TweenInfo.new(0.2, Enum.EasingStyle.Quad), UDim2.fromOffset(12, 12))
				Animations[Length] = RoactAnimate.Parallel(Sequence)
			end
		end
	end

	if self.state.CurrentValue ~= NextState.CurrentValue then
		Length += 1
		local CurrentValue = NextState.CurrentValue

		local Sequence = table.create(2)
		Sequence[1] = RoactAnimate(self.state.BackFrameSize, TweenInfo.new(0.1, Enum.EasingStyle.Quad), UDim2.fromScale(CurrentValue / NextProps.Max, 1))
		Sequence[2] = RoactAnimate(self.state.SliderPosition, TweenInfo.new(0.1, Enum.EasingStyle.Quad), UDim2.fromScale(CurrentValue / NextProps.Max, 0.5))
		Animations[Length] = RoactAnimate.Parallel(Sequence)
	end

--	if self.props.Grid ~= NextProps.Grid or self.props.GridColor3 ~= NextProps.GridColor3 or self.props.Max ~= NextProps.Max then
--		if NextProps.Grid then
--			
--		else
--			self:setState({
--				GridVisible = false,
--			})
--		end
--	end

	RoactAnimate.Parallel(Animations):Start()
end

function Slider:render()
	return Roact.createElement("Frame", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundColor3 = ThemeAccessor.Get(self, "SliderSecondaryColor3"),
		BorderSizePixel = 0,
		Position = self.props.Position,
		Size = UDim2.fromOffset(160, 2),
		ZIndex = self.props.ZIndex,
		[Roact.Ref] = self.SliderRef,
	}, {
		MouseButton = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 1, 10),
			[Roact.Event.InputBegan] = function(_, InputObject: InputObject)
				if not self.props.Disabled then
					if InputObject.UserInputType == Enum.UserInputType.MouseMovement then
						self:setState({
							MouseOver = true,
						})
					elseif CAN_ACTIVATE[InputObject.UserInputType] then
						self:setState({
							MouseDown = true,
						})
					end
				end
			end,

			[Roact.Event.InputChanged] = function(_, InputObject: InputObject)
				if self.state.MouseDown and (InputObject.UserInputType == Enum.UserInputType.MouseMovement or InputObject.UserInputType == Enum.UserInputType.Touch) then
					local Slider = self.SliderRef:getValue()
					if Slider then
						local AbsoluteSizeX = Slider.AbsoluteSize.X
						local Position = math.clamp(InputObject.Position.X - Slider.AbsolutePosition.X, 0, AbsoluteSizeX)
						local CurrentValue = self.props.IntegerOnly and math.floor((Position / AbsoluteSizeX) * self.props.Max + 0.5) or (Position / AbsoluteSizeX) * self.props.Max
						self.props.OnValueChanged(CurrentValue)

						self:setState({
							CurrentValue = CurrentValue,
							TextValue = CurrentValue * self.props.ValueLabelMultiply,
						})
					end
				end
			end,

			[Roact.Event.InputEnded] = function(_, InputObject: InputObject)
				if InputObject.UserInputType == Enum.UserInputType.MouseMovement then
					self:setState({
						MouseOver = false,
					})
				elseif CAN_ACTIVATE[InputObject.UserInputType] then
					self:setState({
						MouseDown = false,
					})
				end
			end,
		
--			[Roact.Event.InputEnded] = function(_, InputObject: InputObject)
--				if InputObject.UserInputType == Enum.UserInputType.MouseMovement then
--					self:setState({
--						MouseOver = false,
--					})
--				elseif CAN_ACTIVATE[InputObject.UserInputType] then
--					self:setState({
--						MouseDown = false,
--					})
--				end
--			end,
		}),

		BackFrame = Roact.createElement(RoactAnimate.Frame, {
			BackgroundColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			Size = self.state.BackFrameSize,
			BorderSizePixel = 0,
		}),

--		GridFrame = Roact.createElement("Frame", {
--			
--		}),

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
			Position = self.state.SliderPosition,
			Size = self.state.SliderSize,
			ZIndex = self.props.ZIndex + 3,
			Image = "rbxassetid://1217158727",
			ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
		}, {
			MouseOnRipple = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = self.state.MouseOnSize,
				Image = "rbxassetid://1217158727",
				ImageTransparency = 0.85,
				ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			}),

			MouseDownRipple = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = self.state.MouseDownSize,
				Image = "rbxassetid://1217158727",
				ImageTransparency = 0.85,
				ImageColor3 = ThemeAccessor.Get(self, "SliderPrimaryColor3"),
			}),

			EventHandler = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2,
--				[Roact.Event.InputBegan] = function(_, InputObject: InputObject)
--					if not self.props.Disabled then
--						if InputObject.UserInputType == Enum.UserInputType.MouseMovement then
--							self:setState({
--								MouseOver = true,
--							})
----						elseif CAN_ACTIVATE[InputObject.UserInputType] then
----							self:setState({
----								MouseDown = true,
----							})
--						end
--					end
--				end,
--
--				[Roact.Event.InputEnded] = function(_, InputObject: InputObject)
--					if InputObject.UserInputType == Enum.UserInputType.MouseMovement then
--						self:setState({
--							MouseOver = false,
--						})
----					elseif CAN_ACTIVATE[InputObject.UserInputType] then
----						self:setState({
----							MouseDown = false,
----						})
--					end
--				end,
			}),

			ValueLabel = Roact.createElement(RoactAnimate.ImageLabel, {
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0, 2),
				Size = self.state.ValueLabelSize,
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
					Text = self.state.TextValue,
					TextSize = 14,
				}),
			}),
		}),
	})
end

function Slider:_DoChangeValue()
	local CurrentValue = self.state.CurrentValue
	self:setState({
		
	})
end

return Slider