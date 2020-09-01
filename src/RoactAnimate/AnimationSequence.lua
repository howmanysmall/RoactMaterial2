local Signal = require(script.Parent.Signal)

local AnimationSequence = {}
AnimationSequence.__index = AnimationSequence

--[[
	Creates a new animation sequence.
]]
function AnimationSequence.new(animations, parallel)
	return setmetatable({
		_animations = animations,
		_parallel = parallel,
		AnimationFinished = Signal.new(),
	}, AnimationSequence)
end

--[[
	Starts the animation sequence. All animations are run asynchronously; this
	method does not yield!

	If called when the animation sequence is already playing, this will halt
	the current sequence and start over from the beginning.
]]
function AnimationSequence:Start()
	coroutine.wrap(function()
		if self._parallel then
			local count = #self._animations

			for _, animation in ipairs(self._animations) do
				local connection
				connection = animation.AnimationFinished:Connect(function()
					connection = connection:Disconnect()
					count -= 1

					if count <= 0 then
						self.AnimationFinished:Fire()
					end
				end)

				animation:Start()
			end
		else
			self:_startSequential(1)
		end
	end)()
end

--[[
	Starts playing animations sequentially at a given index.
]]
function AnimationSequence:_startSequential(index)
	local animation = self._animations[index]

	local connection
	connection = animation.AnimationFinished:Connect(function()
		connection = connection:Disconnect()

		local newIndex = index + 1
		if newIndex > #self._animations then
			self.AnimationFinished:Fire()
		else
			self:_startSequential(newIndex)
		end
	end)

	animation:Start()
end

return AnimationSequence