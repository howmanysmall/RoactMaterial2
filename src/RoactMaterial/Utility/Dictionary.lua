local Dictionary = {
	None = newproxy(true),
}

getmetatable(Dictionary.None).__tostring = function()
	return "Dictionary.None"
end

local None = Dictionary.None

function Dictionary.Copy(Table)
	assert(type(Table) == "table", "expected a table for first argument, got " .. typeof(Table))
	local NewTable = {}
	for Index, Value in next, Table do
		NewTable[Index] = Value
	end

	return NewTable
end

function Dictionary.Join(...)
	local NewTable = {}

	for Index = 1, select("#", ...) do
		local Table = select(Index, ...)
		if Table then
			for Key, Value in next, Table do
				if Value == None then
					NewTable[Key] = nil
				else
					NewTable[Key] = Value
				end
			end
		end
	end

	return NewTable
end

return Dictionary
