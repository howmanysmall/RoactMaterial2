-- Wraps a component to produce a new component that responds to animated values.

local TweenService = game:GetService("TweenService")
local AnimatedValue = require(script.Parent.AnimatedValue)
local Roact = require(script.Parent.Parent.Roact)

local NON_PRIMITIVE_ERROR = "The component %q cannot be animated because it is not a primitive component."

local function makeAnimatedComponent(toWrap)
	if type(toWrap) ~= "string" then
		error(string.format(NON_PRIMITIVE_ERROR, tostring(toWrap)), 2)
	end

	local wrappedComponent = Roact.Component:extend("_animatedComponent:" .. toWrap)

	function wrappedComponent:didMount()
		self:_disconnectListeners()
		self._listeners = {}

		for key, value in pairs(self.props) do
			if type(value) == "table" and value._class == AnimatedValue then
				local _currentTween = nil

				table.insert(self._listeners, value.AnimationStarted:Connect(function(to, tweenInfo)
					if self._rbx then
						if _currentTween then
							_currentTween:Cancel()
							_currentTween = _currentTween:Destroy()
						end

						local tween = TweenService:Create(self._rbx, tweenInfo, {[key] = to})
						tween:Play()
						_currentTween = tween

						_currentTween.Completed:Connect(function(status)
							if status == Enum.PlaybackState.Completed then
								value:FinishAnimation()
								tween = nil
								_currentTween = _currentTween:Destroy()
							end
						end)
					end
				end))

				table.insert(self._listeners, value.Changed:Connect(function(new)
					if self._rbx then
						self._rbx[key] = new
					end
				end))
			end
		end
	end

	function wrappedComponent:willUnmount()
		self:_disconnectListeners()
	end

	function wrappedComponent:render()
		local ref = self.props[Roact.Ref]
		local props = {}

		for key, value in pairs(self.props) do
			if type(value) == "table" and value._class == AnimatedValue then
				props[key] = value.Value
			else
				props[key] = value
			end
		end

		props[Roact.Ref] = function(rbx)
			self._rbx = rbx
			if ref then
				if type(ref) == "function" then
					ref(rbx)
				elseif type(ref) == "table" then
					ref.current = rbx
				end
			end
		end

		return Roact.createElement(toWrap, props)
	end

	function wrappedComponent:_disconnectListeners()
		if not self._listeners then
			return
		end

		for index, listener in ipairs(self._listeners) do
			self._listeners[index] = listener:Disconnect()
		end
	end

	return wrappedComponent
end

return makeAnimatedComponent