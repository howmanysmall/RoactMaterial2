local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configuration = {
	Promise = require(ReplicatedStorage.Promise),
	Roact = require(ReplicatedStorage.Roact),
	RoactAnimate = require(ReplicatedStorage.RoactAnimate),
	t = require(ReplicatedStorage.t),
	Warnings = {},
}

return Configuration
