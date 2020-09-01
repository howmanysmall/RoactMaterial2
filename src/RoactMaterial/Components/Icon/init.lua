local Configuration = require(script.Parent.Parent.Configuration)
local Spritesheet = require(script.Spritesheets)

local Roact = Configuration.Roact
local RoactAnimate = Configuration.RoactAnimate

local SHEET_ASSETS = table.create(20)
SHEET_ASSETS[1] = "rbxassetid://1330514658"
SHEET_ASSETS[2] = "rbxassetid://1330515143"
SHEET_ASSETS[3] = "rbxassetid://1330573324"
SHEET_ASSETS[4] = "rbxassetid://1330573609"
SHEET_ASSETS[5] = "rbxassetid://1330573880"
SHEET_ASSETS[6] = "rbxassetid://1330574454"
SHEET_ASSETS[7] = "rbxassetid://1330575498"
SHEET_ASSETS[8] = "rbxassetid://1330575765"
SHEET_ASSETS[9] = "rbxassetid://1330575939"
SHEET_ASSETS[10] = "rbxassetid://1330582217"
SHEET_ASSETS[11] = "rbxassetid://1330582416"
SHEET_ASSETS[12] = "rbxassetid://1330582591"
SHEET_ASSETS[13] = "rbxassetid://1330582964"
SHEET_ASSETS[14] = "rbxassetid://1330583109"
SHEET_ASSETS[15] = "rbxassetid://1330588230"
SHEET_ASSETS[16] = "rbxassetid://1330588493"
SHEET_ASSETS[17] = "rbxassetid://1330588679"
SHEET_ASSETS[18] = "rbxassetid://1330588820"
SHEET_ASSETS[19] = "rbxassetid://1330588932"
SHEET_ASSETS[20] = "rbxassetid://1330592123"

local function ClosestResolution(icon, goalResolution)
	local closest = 0
	local closestDelta = nil

	for resolution in pairs(icon) do
		if goalResolution % resolution == 0 or resolution % goalResolution == 0 then
			return resolution
		elseif not closestDelta or math.abs(resolution - goalResolution) < closestDelta then
			closest = resolution
			closestDelta = math.abs(resolution - goalResolution)
		end
	end

	return closest
end

local function Icon(props)
	local iconName = props.Icon
	local icon = Spritesheet[iconName]

	local chosenResolution = props.Resolution

	if not chosenResolution then
		if props.Size.X.Scale ~= 0 or props.Size.Y.Scale ~= 0 then
			chosenResolution = ClosestResolution(icon, math.huge)
		else
			assert(props.Size.X.Offset == props.Size.Y.Offset, "If using offset Icon size must result in a square")
			chosenResolution = ClosestResolution(icon, props.Size.X.Offset)
		end
	end

	local variant = icon[chosenResolution]

	return Roact.createElement(RoactAnimate.ImageLabel, {
		Image = SHEET_ASSETS[variant.Sheet],
		BackgroundTransparency = 1,
		ImageRectSize = Vector2.new(variant.Size, variant.Size),
		ImageRectOffset = Vector2.new(variant.X, variant.Y),
		ImageColor3 = props.IconColor3,
		ImageTransparency = props.IconTransparency,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
	})
end

return Icon