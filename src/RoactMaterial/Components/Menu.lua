local Configuration = require(script.Parent.Parent.Configuration)

local Button = require(script.Parent.Button)
local Card = require(script.Parent.Card)
local TextView = require(script.Parent.TextView)

local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local Menu = Roact.Component:extend("MaterialMenu")
Menu.Divider = newproxy(false)

local MENU_TWEEN_DATA_OPENING = {
	Time = 0.2,
	EasingStyle = "Deceleration",
	StepType = "Heartbeat",
}

local MENU_TWEEN_DATA_CLOSING = {
	Time = 0.2,
	EasingStyle = "Acceleration",
	StepType = "Heartbeat",
}

function Menu:init()
	self:setState({
		_size = RoactAnimate.Value.new(UDim2.new()),
	})
end

function Menu:didUpdate()
	if self.props.Open then
		RoactAnimate(self.state._size, MENU_TWEEN_DATA_OPENING, self:_computeOpenSize()):Start()
	else
		RoactAnimate(self.state._size, MENU_TWEEN_DATA_CLOSING, UDim2.new()):Start()
	end
end

function Menu:_computeOpenSize()
	local width = self.props.Width
	local height = 0

	for _, option in ipairs(self.props.Options) do
		if option == Menu.Divider then
			height += 7
		else
			height += 32
		end
	end

	return UDim2.new(width.Scale, width.Offset, 0, height)
end

function Menu:render()
	local contents = {
		__Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		}),
	}

	for index, option in ipairs(self.props.Options) do
		if option == Menu.Divider then
			contents["Divider_" .. index] = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 7),
				LayoutOrder = index,
				BackgroundTransparency = 1,
			}, table.create(1, Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromScale(0, 0.5),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 0.85,
				BackgroundColor3 = ThemeAccessor.Get(self, "InverseBackgroundColor"),
				BorderSizePixel = 0,
			})))
		else
			local buttonContent, key
			if type(option) == "string" then
				key = option
				buttonContent = table.create(1, Roact.createElement(TextView, {
					Class = "Body1",
					Text = option,
					Size = UDim2.new(1, -24, 1, 0),
					Position = UDim2.fromOffset(24, 0),
					TextXAlignment = Enum.TextXAlignment.Left,
				}))
			elseif type(option) == "table" then
				local optionContent = option.Content
				key = option.Key or tostring(optionContent)

				if type(optionContent) == "string" then
					buttonContent = Roact.createElement(TextView, {
						Class = "Body1",
						Text = optionContent,
						Size = UDim2.new(1, -24, 1, 0),
						TextXAlignment = Enum.TextXAlignment.Left,
					})
				else
					buttonContent = optionContent
				end
			end

			contents["Option_" .. key] = Roact.createElement(Button, {
				Flat = true,
				Size = UDim2.new(1, 0, 0, 32),
				Text = "",
				LayoutOrder = index,
				InkColor3 = Color3.new(0.6, 0.6, 0.6),
				HoverColor3 = Color3.new(0.8, 0.8, 0.8),
				PressColor3 = Color3.new(0.7, 0.7, 0.7),

				OnClicked = function()
					self.props.OnOptionSelected(option)
				end,
			}, buttonContent)
		end
	end

	return Roact.createElement(Card, {
		Elevation = self.props.Open and 2 or 0,
		ZIndex = self.props.ZIndex,
		Size = self.state._size,
		Position = self.props.Position,
		AnchorPoint = self.props.AnchorPoint,
	}, contents)
end

return Menu
