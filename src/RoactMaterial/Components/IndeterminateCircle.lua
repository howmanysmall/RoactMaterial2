local Configuration = require(script.Parent.Parent.Configuration)
local Scheduler = require(script.Parent.Parent.Utility.Scheduler)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Roact = Configuration.Roact

local IndeterminateCircle = Roact.PureComponent:extend("MaterialIndeterminateCircle")
IndeterminateCircle.defaultProps = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	AnimationSpeed = 1,
	Disabled = false,
	Position = UDim2.fromScale(0.5, 0.5),
}

local Scheduler_Wait = Scheduler.Wait

local IMAGE_IDS = {
	"rbxassetid://3952960164",
	"rbxassetid://3952960362",
	"rbxassetid://3952960550",
	"rbxassetid://3952960755",
	"rbxassetid://3952960944",
	"rbxassetid://3952961113",
	"rbxassetid://3952961293",
	"rbxassetid://3952961506",
	"rbxassetid://3952962226",
	"rbxassetid://3952962487",
	"rbxassetid://3952962701",
	"rbxassetid://3952962866",
	"rbxassetid://3952963067",
	"rbxassetid://3952963292",
	"rbxassetid://3952963728",
	"rbxassetid://3952964345",
	"rbxassetid://3952964533",
	"rbxassetid://3952964779",
	"rbxassetid://3952965122",
	"rbxassetid://3952965450",
	"rbxassetid://3952965807",
	"rbxassetid://3952966033",
	"rbxassetid://3952966267",
	"rbxassetid://3952966594",
	"rbxassetid://3952966889",
	"rbxassetid://3952967186",
	"rbxassetid://3952967551",
	"rbxassetid://3952967854",
	"rbxassetid://3952968048",
	"rbxassetid://3952968265",
	"rbxassetid://3952969357",
	"rbxassetid://3952971376",
	"rbxassetid://3952971597",
	"rbxassetid://3952971787",
	"rbxassetid://3952972018",
	"rbxassetid://3952972255",
	"rbxassetid://3952972457",
	"rbxassetid://3952972678",
	"rbxassetid://3952972852",
	"rbxassetid://3952973062",
	"rbxassetid://3952973251",
	"rbxassetid://3952973467",
}

function IndeterminateCircle:init()
	self:setState({
		index = 1,
		rotation = 0,
	})
end

local memoizeIndex = setmetatable({}, {
	__index = function(self, index)
		local value = {index = index}
		self[index] = value
		return value
	end,
})

local memoizeRotation = setmetatable({}, {
	__index = function(self, index)
		local value = {rotation = index}
		self[index] = value
		return value
	end,
})

for index = 1, 42 do
	local _ = memoizeIndex[index]
end

function IndeterminateCircle:didMount()
	self.isMounted = true
	Scheduler.FastSpawn(function()
		while self.isMounted do
			for index = 1, 42 do
				if not self.isMounted then
					break
				end

				self:setState(memoizeIndex[index])
				Scheduler_Wait(0.03 / self.props.AnimationSpeed)
				local newRotation = self.state.rotation + 2
				if not self.isMounted then
					break
				end

				self:setState(memoizeRotation[newRotation > 360 and newRotation - 360 or newRotation])
			end
		end
	end)
end

function IndeterminateCircle:willUnmount()
	self.isMounted = false
end

function IndeterminateCircle:render()
	return Roact.createElement("Frame", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		Position = self.props.Position,
		Size = UDim2.fromOffset(50, 50),
	}, {
		Circle = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = IMAGE_IDS[self.state.index],
			ImageColor3 = ThemeAccessor.Get(self, "PrimaryColor"),
			Size = UDim2.fromScale(1, 1),
		}),
	})
end

return IndeterminateCircle
