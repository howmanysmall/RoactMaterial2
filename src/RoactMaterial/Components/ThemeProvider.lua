local Configuration = require(script.Parent.Parent.Configuration)
local Roact = Configuration.Roact

local ThemeProvider = Roact.PureComponent:extend("MaterialThemeProvider")

function ThemeProvider:init(props)
	self._context._materialTheme = props.Theme
end

function ThemeProvider:render()
	return Roact.oneChild(self.props[Roact.Children])
end

return ThemeProvider
