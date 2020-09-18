local TextService = game:GetService("TextService")
local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact

local TEXT_CLASSES = {
	Display4Font = Enum.Font.SourceSansLight,
	Display4Size = 96,
	Display3Font = Enum.Font.SourceSans,
	Display3Size = 72,
	Display2Font = Enum.Font.SourceSans,
	Display2Size = 56,
	Display1Font = Enum.Font.SourceSans,
	Display1Size = 48,

	Body2Font = Enum.Font.SourceSansSemibold,
	Body2Size = 18,
	Body1Font = Enum.Font.SourceSans,
	Body1Size = 18,

	TitleFont = Enum.Font.SourceSansSemibold,
	TitleSize = 24,
	HeadlineFont = Enum.Font.SourceSans,
	HeadlineSize = 32,
	SubheadingFont = Enum.Font.SourceSans,
	SubheadingSize = 20,

	ButtonFont = Enum.Font.SourceSansSemibold,
	ButtonSize = 18,
	CaptionFont = Enum.Font.SourceSans,
	CaptionSize = 14,

	SnackbarFont = Enum.Font.SourceSans,
	SnackbarSize = 20,
}

local TextView = Roact.Component:extend("MaterialTextView")

function TextView.getTextBounds(text, textClass, boundingRect)
	boundingRect = boundingRect or Vector2.new(10000, 10000)
	local font = TEXT_CLASSES[textClass .. "Font"]
	local size = TEXT_CLASSES[textClass .. "Size"]

	return TextService:GetTextSize(text, size, font, boundingRect)
end

function TextView:render()
	local textClass = self.props.Class
	local font = TEXT_CLASSES[textClass .. "Font"]
	local size = TEXT_CLASSES[textClass .. "Size"]

	return Roact.createElement("TextLabel", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		Font = font,
		LayoutOrder = self.props.LayoutOrder,
		LineHeight = self.props.LineHeight,
		Position = self.props.Position,
		Size = self.props.Size,
		Text = self.props.Text,
		TextColor3 = self.props.TextColor3 or ThemeAccessor.Get(self, "TextColor"),
		TextSize = size,
		TextStrokeColor3 = self.props.TextStrokeColor3,
		TextStrokeTransparency = self.props.TextStrokeTransparency,
		TextTransparency = self.props.TextTransparency,
		TextXAlignment = self.props.TextXAlignment,
		TextYAlignment = self.props.TextYAlignment,
		ZIndex = self.props.ZIndex,
	}, self.props[Roact.Children])
end

return TextView
