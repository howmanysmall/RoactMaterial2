local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Promise = Configuration.Promise
local Roact = Configuration.Roact

local IndeterminateCircle = Roact.Component:extend("MaterialIndeterminateCircle")
IndeterminateCircle.defaultProps = {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	AnimationSpeed = 1,
	Disabled = false,
}

local IMAGE_IDS = table.create(42)
IMAGE_IDS[1] = "rbxassetid://3952960164"
IMAGE_IDS[2] = "rbxassetid://3952960362"
IMAGE_IDS[3] = "rbxassetid://3952960550"
IMAGE_IDS[4] = "rbxassetid://3952960755"
IMAGE_IDS[5] = "rbxassetid://3952960944"
IMAGE_IDS[6] = "rbxassetid://3952961113"
IMAGE_IDS[7] = "rbxassetid://3952961293"
IMAGE_IDS[8] = "rbxassetid://3952961506"
IMAGE_IDS[9] = "rbxassetid://3952962226"
IMAGE_IDS[10] = "rbxassetid://3952962487"
IMAGE_IDS[11] = "rbxassetid://3952962701"
IMAGE_IDS[12] = "rbxassetid://3952962866"
IMAGE_IDS[13] = "rbxassetid://3952963067"
IMAGE_IDS[14] = "rbxassetid://3952963292"
IMAGE_IDS[15] = "rbxassetid://3952963728"
IMAGE_IDS[16] = "rbxassetid://3952964345"
IMAGE_IDS[17] = "rbxassetid://3952964533"
IMAGE_IDS[18] = "rbxassetid://3952964779"
IMAGE_IDS[19] = "rbxassetid://3952965122"
IMAGE_IDS[20] = "rbxassetid://3952965450"
IMAGE_IDS[21] = "rbxassetid://3952965807"
IMAGE_IDS[22] = "rbxassetid://3952966033"
IMAGE_IDS[23] = "rbxassetid://3952966267"
IMAGE_IDS[24] = "rbxassetid://3952966594"
IMAGE_IDS[25] = "rbxassetid://3952966889"
IMAGE_IDS[26] = "rbxassetid://3952967186"
IMAGE_IDS[27] = "rbxassetid://3952967551"
IMAGE_IDS[28] = "rbxassetid://3952967854"
IMAGE_IDS[29] = "rbxassetid://3952968048"
IMAGE_IDS[30] = "rbxassetid://3952968265"
IMAGE_IDS[31] = "rbxassetid://3952969357"
IMAGE_IDS[32] = "rbxassetid://3952971376"
IMAGE_IDS[33] = "rbxassetid://3952971597"
IMAGE_IDS[34] = "rbxassetid://3952971787"
IMAGE_IDS[35] = "rbxassetid://3952972018"
IMAGE_IDS[36] = "rbxassetid://3952972255"
IMAGE_IDS[37] = "rbxassetid://3952972457"
IMAGE_IDS[38] = "rbxassetid://3952972678"
IMAGE_IDS[39] = "rbxassetid://3952972852"
IMAGE_IDS[40] = "rbxassetid://3952973062"
IMAGE_IDS[41] = "rbxassetid://3952973251"
IMAGE_IDS[42] = "rbxassetid://3952973467"

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
	end;
})

local memoizeRotation = setmetatable({}, {
	__index = function(self, index)
		local value = {rotation = index}
		self[index] = value
		return value
	end;
})

for index = 1, 42 do
	local _ = memoizeIndex[index]
end

function IndeterminateCircle:didMount()
	self.isMounted = true
	coroutine.wrap(function()
		while self.isMounted do
			for index = 1, 42 do
				self:setState(memoizeIndex[index])
				Promise.delay(0.03 / self.props.AnimationSpeed):await()
				local newRotation = self.state.rotation + 2
				self:setState(memoizeRotation[newRotation > 360 and newRotation - 360 or newRotation])
			end
		end
	end)()
end

function IndeterminateCircle:willUnmount()
	self.isMounted = false
end

function IndeterminateCircle:render()
	return Roact.createElement("Frame", {
		AnchorPoint = self.props.AnchorPoint,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(50, 50),
		Position = self.props.Position,
	}, {
		Circle = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Image = IMAGE_IDS[self.state.index],
			ImageColor3 = ThemeAccessor.Get(self, "PrimaryColor"),
		}),
	})
end

return IndeterminateCircle