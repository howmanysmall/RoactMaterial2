local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local ExampleComponent = Roact.Component:extend("MenuExampleComponent")

function ExampleComponent:init()
	self:setState({
		open = false,
	})
end

function ExampleComponent:render()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Light,
	}, {
		Backing = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, {
			ToggleButton = Roact.createElement(RoactMaterial.Button, {
				Text = "Open Menu",
				Size = UDim2.fromOffset(200, 40),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),

				OnClicked = function()
					self:setState({
						open = true,
					})
				end,
			}, {
				Menu = Roact.createElement(RoactMaterial.Menu, {
					Width = UDim.new(0, 200),
					Open = self.state.open,
					Options = {
						"Test",
						"Test 2",
						RoactMaterial.Menu.Divider,
						"Test 3"
					},

					ZIndex = 2,
					OnOptionSelected = function(option)
						print(option)
						self:setState({
							open = false,
						})
					end,
				}),
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