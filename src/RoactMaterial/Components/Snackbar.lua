local TextService = game:GetService("TextService")
local Configuration = require(script.Parent.Parent.Configuration)
local Shadow = require(script.Parent.Shadow)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate
local enumerate = Configuration.enumerate

local Snackbar = Roact.PureComponent:extend("MaterialSnackbar")
Snackbar.SnackbarPosition = enumerate("SnackbarPosition", {"Center", "Left", "Right"})
Snackbar.defaultProps = {
	Position = Snackbar.SnackbarPosition.Center,
	Text = "Hello, world!",
	Visible = false,

	ActionText = "",
	OnAction = function()
	end,
}

local CORNER_OFFSET = 8
local HEIGHT = 48

local function setStateFromProps(self, props)
	if props.Position == Snackbar.SnackbarPosition.Center then
		if props.Visible then
			self:setState({
				SnackbarAnchorPoint = RoactAnimate.Value.new(Vector2.new(0.5, 0)),
				SnackbarPosition = RoactAnimate.Value.new(UDim2.new(0.5, 0, 1, -HEIGHT - CORNER_OFFSET)),
				Visible = true,
			})
		else
			self:setState({
				SnackbarAnchorPoint = RoactAnimate.Value.new(Vector2.new(0.5, 0)),
				SnackbarPosition = RoactAnimate.Value.new(UDim2.fromScale(0.5, 1)),
				Visible = false,
			})
		end
	elseif props.Position == Snackbar.SnackbarPosition.Left then
		if props.Visible then
			self:setState({
				SnackbarAnchorPoint = RoactAnimate.Value.new(Vector2.new()),
				SnackbarPosition = RoactAnimate.Value.new(UDim2.new(0, 7, 1, -HEIGHT - CORNER_OFFSET)),
				Visible = true,
			})
		else
			self:setState({
				SnackbarAnchorPoint = RoactAnimate.Value.new(Vector2.new()),
				SnackbarPosition = RoactAnimate.Value.new(UDim2.new(0, 7, 1, 0)),
				Visible = false,
			})
		end
	elseif props.Position == Snackbar.SnackbarPosition.Right then
		if props.Visible then
			self:setState({
				SnackbarAnchorPoint = RoactAnimate.Value.new(Vector2.new(1, 0)),
				SnackbarPosition = RoactAnimate.Value.new(UDim2.new(1, -7, 1, -HEIGHT - CORNER_OFFSET)),
				Visible = true,
			})
		else
			self:setState({
				SnackbarAnchorPoint = RoactAnimate.Value.new(Vector2.new(1, 0)),
				SnackbarPosition = RoactAnimate.Value.new(UDim2.new(1, -7, 1, 0)),
				Visible = false,
			})
		end
	else
		error("Bad Position type!")
	end
end

Snackbar.init = setStateFromProps
function Snackbar:willUpdate(nextProps, nextState)
	if nextState.Visible then
		
	else
		
	end

	local goalColor
	if nextState._pressed then
		goalColor = self.props.PressColor3 or ThemeAccessor.Get(self, self.props.Flat and "FlatButtonPressColor" or "ButtonPressColor", Color3.new(0.9, 0.9, 0.9))
	elseif nextState._mouseOver then
		goalColor = self.props.HoverColor3 or ThemeAccessor.Get(self, self.props.Flat and "FlatButtonHoverColor" or "ButtonHoverColor", WHITE_COLOR3)
	else
		goalColor = self.props.BackgroundColor3 or ThemeAccessor.Get(self, self.props.Flat and "FlatButtonColor" or "ButtonColor", WHITE_COLOR3)
	end

	RoactAnimate(self.state._bgColor, COLOR_TWEEN_INFO, goalColor):Start()
end

function Snackbar:render()
	return Roact.createElement(RoactAnimate.Frame, {
		BackgroundTransparency = 1,
	}, {
		
	})
end

return Snackbar