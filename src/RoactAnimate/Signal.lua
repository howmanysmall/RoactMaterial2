--[[
	A signal that calls listeners synchronously.
]]

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_listeners = {},
	}, Signal)
end

function Signal:Connect(listener)
	table.insert(self._listeners, listener)

	return {
		Disconnect = function()
			local listeners = self._listeners
			for i = #listeners, 1, -1 do
				if listeners[i] == listener then
					table.remove(self._listeners, i)
					break
				end
			end
		end,
	}
end

function Signal:Fire(...)
	for _, listener in ipairs(self._listeners) do
		listener(...)
	end
end

return Signal
