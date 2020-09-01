local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local RoactAnimate = Configuration.RoactAnimate
local Roact = Configuration.Roact

local MaterialTextField = Roact.PureComponent:extend("MaterialTextField")
MaterialTextField.defaultProps = {
	AnchorPoint = Vector2.new(),
	ClearTextOnFocus = false,
	LayoutOrder = 0,
	Size = UDim2.fromScale(1, 0.15),
	TextEditable = true,
	ZIndex = 1,
	Font = Enum.Font.SourceSansBold,

	AnimationSpeed = 1,
	PlaceholderText = "",
	ErrorText = "Error",
	IsErroring = false,
	IsFocused = false,
	HelperText = "Helper",
}

function MaterialTextField:init(props)
	self:setState({
		PlaceholderTextColor3 = RoactAnimate.Value.new(ThemeAccessor.new(self, props.IsErroring and "TextFieldErrorColor" or (props.IsFocused and "TextFieldOnColor" or "TextFieldOffColor"))),
		PlaceholderPosition = RoactAnimate.Value.new(props.IsFocused and UDim2.fromOffset(0, -2) or UDim2.fromScale(0, 0.5)),
		
	})

	self.TextBoxRef = Roact.createRef()
end

function MaterialTextField:willUpdate(NextProps)
	local Animations = {}
	local Length = 0

	if self.props.Active ~= NextProps.Active then
		
	end
end

function MaterialTextField:render()
	local ZIndex = self.props.ZIndex

	return Roact.createElement("TextBox", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		LayoutOrder = self.props.LayoutOrder,
		Size = self.props.Size,
		TextEditable = self.props.TextEditable,
		Font = Enum.Font.SourceSans,
		ZIndex = ZIndex,
		[Roact.Ref] = self.TextBoxRef,
	}, {
		
	})
end