local RunService = game:GetService("RunService")
local Configuration = require(script.Parent.Parent.Configuration)
local ThemeAccessor = require(script.Parent.Parent.Utility.ThemeAccessor)

local Promise = Configuration.Promise
local RoactAnimate = Configuration.RoactAnimate
local Roact = Configuration.Roact

local LOADING_TITLE_HEIGHT = 20
local LOADING_TITLE_PADDING = 10

local IndeterminateProgress = Roact.Component:extend("IndeterminateProgress")
IndeterminateProgress.defaultProps = {}

type validateProps = {
	LoadingTime: number?;
	HoldPercent: number?;
	IsFinished: boolean?;
	Size: UDim2?;
	Position: UDim2?;
}

function IndeterminateProgress:init()
	self:setState({
		progress = 0,
		time = 0,
	})
end

local function loadUntil(self, percent)
	while self.state.progress < percent do
		local dt = RunService.RenderStepped:Wait()
		if not self.isMounted then
			break
		end

		local newTime = self.state.time + dt
		self:setState({
			time = newTime,
			progress = newTime / self.props.LoadingTime,
		})
	end
end

function IndeterminateProgress:didMount()
	self.isMounted = true
	self.promise = Promise.Try(function()
		loadUntil(self, self.props.HoldPercent)
		while self.isMounted and not self.props.IsFinished do
			RunService.RenderStepped:Wait()
		end

		loadUntil(self, 1)
		loadUntil(self, 1.5)
	end)
end

function IndeterminateProgress:willUnmount()
	if self.promise then
		self.promise:Cancel()
		self.promise = nil
	end

	self.isMounted = false
end

function IndeterminateProgress:render()
	local props = self.props
	local progress = math.min(math.max(self.state.progress, 0), 1)
	local loadingText = props.LoadingText .. " ( " .. math.floor((progress * 100) + 0.5) .. "% )"

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = props.Size,
		Position = props.Position,
	}, {
		LoadingTitle = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSans,
			Position = UDim2.fromOffset(0, -(LOADING_TITLE_HEIGHT + LOADING_TITLE_PADDING)),
			Size = UDim2.new(1, 0, 0, LOADING_TITLE_HEIGHT),
			Text = loadingText,
			TextColor3 = Color3.fromRGB(204, 204, 204),
			TextSize = 16,
		}),

		LoadingBackgroundBar = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = Color3.fromRGB(46, 46, 46),
			Size = UDim2.fromScale(1, 1),
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),

			LoadingBar = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(102, 102, 102),
				Size = UDim2.fromScale(progress, 1),
			}, {
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 4),
				}),
			}),
		}),
	})
end

return IndeterminateProgress