local Animation = require(script.Animation)
local AnimationSequence = require(script.AnimationSequence)
local PrepareStep = require(script.PrepareStep)
local makeAnimatedComponent = require(script.makeAnimatedComponent)

local RoactAnimate = {
	Value = require(script.AnimatedValue),
	makeAnimatedComponent = makeAnimatedComponent,
}

-- Create animated variants of all the Roblox classes
for _, className in ipairs({"Frame", "ImageButton", "ImageLabel", "ScrollingFrame", "TextBox", "TextButton", "TextLabel", "ViewportFrame"}) do
	RoactAnimate[className] = makeAnimatedComponent(className)
end

-- Creates an animation for a value.
RoactAnimate.Animate = Animation.new

-- Creates an animation from a table of animations.
-- These animations will be run one-by-one.
function RoactAnimate.Sequence(animations)
	return AnimationSequence.new(animations, false)
end

-- Creates an animation from a table of animations.
-- These animations will be run all at once.
function RoactAnimate.Parallel(animations)
	return AnimationSequence.new(animations, true)
end

-- Creates a preparation step.
-- This allows instantaneous resetting of a value prior to animations completing.
RoactAnimate.Prepare = PrepareStep.new

return setmetatable(RoactAnimate, {
	__call = function(_, ...)
		return RoactAnimate.Animate(...)
	end,
})