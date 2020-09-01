local BaseTheme = require(script.Parent.Base)
local Colors = require(script.Parent.Parent.Colors)

local DarkTheme = {
	TextColor = Colors.White,
	PrimaryColor = Colors.Teal500,
	BackgroundColor = Colors.Grey900,
	InverseBackgroundColor = Colors.Grey100,
	ButtonHoverColor = Colors.Lighten("Teal500", 1),
	ButtonPressColor = Colors.Darken("Teal500", 1),
	FlatButtonHoverColor = Colors.Lighten("Teal500", 4),
	FlatButtonPressColor = Colors.Lighten("Teal500", 3),
	FlatButtonColor = Colors.Black,
	ButtonColor = Colors.Teal500,

	SwitchTrackOnColor = Colors.Teal100,
	SwitchTrackOffColor = Colors.Grey400,
	SwitchToggleOnColor = Colors.Teal500,
	SwitchToggleOffColor = Colors.Grey100,
	SwitchRippleOnColor = Colors.Teal500,
	SwitchRippleOffColor = Colors.Grey400,

	TextFieldOnColor = Colors.Teal500,
	TextFieldOffColor = Colors.Grey500,
	TextFieldErrorColor = Colors.Red500,

	ProgressIndicatorForeground = Colors.Teal500,
	ProgressIndicatorBackground = Colors.Teal100,

	SliderPrimaryColor3 = Colors.Teal500,
	SliderSecondaryColor3 = Colors.Grey200,
	SliderValueColor3 = Colors.White,

	CheckOutlineColor = {
		Color = Colors.Black,
		Transparency = 0.46,
	},
}

return setmetatable(DarkTheme, {__index = BaseTheme})
