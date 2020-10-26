local Configuration = require(script.Parent.Parent.Configuration)
local RadioButton = require(script.Parent.RadioButton)
local TextView = require(script.Parent.TextView)

local Roact = Configuration.Roact

local RadioGroup = Roact.Component:extend("MaterialRadioGroup")

function RadioGroup:init(props)
	self:setState({
		CurrentId = props.CurrentId,
	})
end

function RadioGroup:render()
	local children = {
		Layout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, 8),
			SortOrder = "Name",
		}),
	}

	for id, label in pairs(self.props.Options) do
		local element = Roact.createElement("TextButton", {
			BackgroundTransparency = 1,
			Text = "",
			Size = UDim2.new(1, 0, 0, 24),

			[Roact.Event.Activated] = function()
				if self.props.CurrentIdChanged then
					self.props.CurrentIdChanged(id)
				end

				self:setState({
					CurrentId = id,
				})
			end,
		}, {
			RadioButton = Roact.createElement(RadioButton, {
				Checked = id == self.state.CurrentId,
				OnClicked = function()
					if self.props.CurrentIdChanged then
						self.props.CurrentIdChanged(id)
					end

					self:setState({
						CurrentId = id,
					})
				end
			}),

			TextLabel = Roact.createElement(TextView, {
				Class = "Body1",
				Position = UDim2.fromOffset(30, 0),
				Size = UDim2.new(1, -30, 0, 24),
				Text = label,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
		})

		children["RadioButton__" .. tostring(id)] = element
	end

	local size = self.props.Size

	if self.props.SizeFromContents then
		local maximumTextWidth = 0
		for _, label in pairs(self.props.Options) do
			local bounds = TextView.getTextBounds(tostring(label), "Body1")

			if bounds.X > maximumTextWidth then
				maximumTextWidth = bounds.X
			end
		end

		size = UDim2.fromOffset(30 + maximumTextWidth + 8, 32)
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		Position = self.props.Position,
	}, children)
end

return RadioGroup
