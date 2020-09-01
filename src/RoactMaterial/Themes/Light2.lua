local BaseTheme = require(script.Parent.Base)
local Colors = require(script.Parent.Parent.Colors)

local LightTheme = {
	TextColor = Colors.Grey900,
	PrimaryColor = Colors.Blue500,
	BackgroundColor = Colors.White,
	InverseBackgroundColor = Colors.Black,
	ButtonHoverColor = Colors.Lighten("Blue500", 1),
	ButtonPressColor = Colors.Darken("Blue500", 1),
	FlatButtonHoverColor = Colors.Lighten("Blue500", 4),
	FlatButtonPressColor = Colors.Lighten("Blue500", 3),
	FlatButtonColor = Colors.White,
	ButtonColor = Colors.Blue500,

	SwitchTrackOnColor = Colors.Blue100,
	SwitchTrackOffColor = Colors.Grey400,
	SwitchToggleOnColor = Colors.Blue500,
	SwitchToggleOffColor = Colors.Grey100,
	SwitchRippleOnColor = Colors.Blue500,
	SwitchRippleOffColor = Colors.Grey400,

	TextFieldOnColor = Colors.Blue500,
	TextFieldOffColor = Colors.Grey500,
	TextFieldErrorColor = Colors.Red500,

	ProgressIndicatorForeground = Colors.Blue500,
	ProgressIndicatorBackground = Colors.Blue100,

	SliderPrimaryColor3 = Colors.Blue500,
	SliderSecondaryColor3 = Colors.Grey400,
	SliderValueColor3 = Colors.White,

	CheckOutlineColor = {
		Color = Colors.Black,
		Transparency = 0.46,
	},
}

return setmetatable(LightTheme, {__index = BaseTheme})
