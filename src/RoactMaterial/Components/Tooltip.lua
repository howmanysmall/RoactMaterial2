local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

---@type Roact
local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local Tooltip = Roact.PureComponent:extend("MaterialTooltip")

function Tooltip:init()
	self.alpha, self.setAlpha = Roact.createBinding(0)
end

function Tooltip:render()
end

return Tooltip
