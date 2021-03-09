local Roact = require(script.Parent.Parent.Parent.Roact)
local RoactMaterial = require(script.Parent.Parent)

local ExampleComponent = Roact.PureComponent:extend("MenuExampleComponent")

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
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
		}, {
			ToggleButton = Roact.createElement(RoactMaterial.Button, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				OnClicked = function()
					self:setState({
						open = true,
					})
				end,

				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(200, 40),
				Text = "Open Menu",
			}, {
				Menu = Roact.createElement(RoactMaterial.Menu, {
					OnOptionSelected = function(option)
						print(option)
						self:setState({
							open = false,
						})
					end,

					Open = self.state.open,
					Options = {
						"Test",
						"Test 2",
						RoactMaterial.Menu.Divider,
						"Test 3",
					},

					Width = UDim.new(0, 200),
					ZIndex = 2,
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
