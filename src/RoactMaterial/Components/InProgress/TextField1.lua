local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local RoactAnimate = Configuration.RoactAnimate
local Roact = Configuration.Roact

local TextField = Roact.PureComponent:extend("TextField")
TextField.defaultProps = {
	AnchorPoint = Vector2.new(),
	ClearTextOnFocus = false,
	LayoutOrder = 0,
	Size = UDim2.fromScale(1, 0.15),
	TextEditable = true,
	ZIndex = 1,
	Font = Enum.Font.SourceSansBold,

	Active = false,
	Erroring = false,
	Label = "Url",
}

function TextField:init(props)
	self:setState({
		UnderbarSize = RoactAnimate.Value.new(props.Active and UDim2.new(1, 0, 0, 2) or UDim2.fromOffset(0, 2)),
		UnderbarBackgroundColor3 = RoactAnimate.Value.new(ThemeAccessor.Get(self, props.Erroring and "TextFieldErrorColor" or "TextFieldDefaultColor")),

		BoxTextSize = RoactAnimate.Value.new(props.Active and UDim2.fromScale(1, 0.5) or UDim2.fromScale(1, 1)),
		BoxTextPosition = RoactAnimate.Value.new(props.Active and UDim2.fromScale(0, -0.3) or UDim2.new()),
		BoxTextTextTransparency = RoactAnimate.Value.new(props.Active and 0 or 0.4),
		BoxTextTextColor3 = RoactAnimate.Value.new(props.Active and 0 or 0.4),

		PseudoTextTextColor3 = RoactAnimate.Value.new(),
	})

	self.TextRef = Roact.createRef()
end

function TextField:willUpdate(NextProps)
	local Animations = {}
	local Length = 0

	if self.props.Active ~= NextProps.Active then
		
	end
end

function TextField:render()
	local ZIndex = self.props.ZIndex

	return Roact.createElement("TextBox", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		ClearTextOnFocus = self.props.ClearTextOnFocus,
		LayoutOrder = self.props.LayoutOrder,
		Size = self.props.Size,
		TextEditable = self.props.TextEditable,
		TextTransparency = 1,
		ZIndex = ZIndex,
	}, {
		PseudoText = Roact.createElement(RoactAnimate.TextLabel, {
			TextTransparency = 0.129,

			[Roact.Event.Focused] = function()
				
			end,

			[Roact.Event.FocusLost] = function()
				
			end,
		}, table.create(1, Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0.11, 0),
			PaddingLeft = UDim.new(0.05, 0),
			PaddingTop = UDim.new(0.11, 0),
		}))),

		Underbar = Roact.createElement(RoactAnimate.Frame, {
			AnchorPoint = Vector2.new(0.5, 1),
			BackgroundColor3 = self.state.UnderbarBackgroundColor3,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0.5, 1),
			Size = self.state.UnderbarSize,
			ZIndex = ZIndex - 1,
		}),

		BoxText = Roact.createElement(RoactAnimate.TextLabel, {
			Size = self.state.BoxTextSize,
			Position = self.state.BoxTextPosition,
			TextColor3 = self.state.BoxTextTextColor3,
			TextTransparency = self.state.BoxTextTextTransparency,
			Text = self.props.Label,
		}, table.create(1, Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0.11, 0),
			PaddingLeft = UDim.new(0.05, 0),
			PaddingTop = UDim.new(0.11, 0),
		}))),
	})
end