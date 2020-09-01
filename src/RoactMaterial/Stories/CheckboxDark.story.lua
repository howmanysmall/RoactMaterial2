local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local ExampleComponent = Roact.Component:extend("CheckExampleComponent")

function ExampleComponent:init()
	self:setState({
		a = true,
		b = false,
	})
end

function ExampleComponent:render()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Dark,
	}, {
		Backing = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, {
			Roact.createElement("UIGridLayout", {
				CellSize = UDim2.fromOffset(24, 24),
				CellPadding = UDim2.fromOffset(10, 10),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			CheckboxA = Roact.createElement(RoactMaterial.Checkbox, {
				Checked = self.state.a,
				OnChecked = function(newValue)
					self:setState({
						a = newValue,
					})
				end,
			}),

			CheckboxB = Roact.createElement(RoactMaterial.Checkbox, {
				Checked = self.state.b,
				OnChecked = function(newValue)
					self:setState({
						b = newValue,
					})
				end,
			}),
		}),
	})
end

return function(Target)
	local Tree = Roact.mount(Roact.createElement(ExampleComponent), Target)

	return function()
		Roact.unmount(Tree)
	end
end