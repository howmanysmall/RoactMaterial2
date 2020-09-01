-- TODO: Convert to use Context API - https://roblox.github.io/roact/advanced/context/
local ThemeAccessor = {}

function ThemeAccessor.Get(object, key, default)
	local materialTheme = object._context._materialTheme
	return materialTheme[key] or default
end

return ThemeAccessor
